import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  final String searchText;
  const ChatMessages({super.key, this.searchText = ''});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'CreatedAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No message found.'),
          );
        }
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Somthing went wrong...'),
          );
        }
        final loadedMessages = chatSnapshots.data!.docs
            .where((doc) {
              final data = doc.data();
              final text = data['text'] ?? '';
              if (searchText.isEmpty) return true;
              // filter เฉพาะข้อความ (ไม่ filter รูปภาพ)
              return text.toString().toLowerCase().contains(searchText.toLowerCase());
            })
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final messageData = loadedMessages[index].data();
            final nextMessageData = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            final currentMessageId = messageData['userId'];
            final nextMessageUserId =
                nextMessageData != null ? nextMessageData['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageId;

            // ถ้าเป็นข้อความ
            if (messageData['text'] != null) {
              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: messageData['text'] ?? '',
                  isMe: authenticatedUser.uid == currentMessageId,
                );
              } else {
                return MessageBubble.first(
                  userImage: messageData['userImage'],
                  username: messageData['username'],
                  message: messageData['text'] ?? '',
                  isMe: authenticatedUser.uid == currentMessageId,
                );
              }
            }
            // ถ้าเป็นรูปภาพ
            else if (messageData['imageUrl'] != null) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: authenticatedUser.uid == currentMessageId
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Image.network(
                    messageData['imageUrl'],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
            // fallback
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
