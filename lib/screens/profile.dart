import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _username;
  String? _imageUrl;
  String? _email;
  bool _loading = true;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    setState(() {
      _username = userDoc.data()?['username'] ?? '';
      _imageUrl = userDoc.data()?['image_url'] ?? '';
      _email = userDoc.data()?['email'] ?? '';
      _loading = false;
    });
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 300);
    if (pickedFile == null) return;
    setState(() { _uploading = true; });
    final user = FirebaseAuth.instance.currentUser!;
    final ref = FirebaseStorage.instance.ref().child('user_images').child('${user.uid}.jpg');
    await ref.putFile(File(pickedFile.path));
    final newImageUrl = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'image_url': newImageUrl});
    setState(() {
      _imageUrl = newImageUrl;
      _uploading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile image updated!')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty ? NetworkImage(_imageUrl!) : null,
                  child: _imageUrl == null || _imageUrl!.isEmpty ? const Icon(Icons.person, size: 60) : null,
                ),
                if (_uploading)
                  const Positioned.fill(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: _uploading ? null : _pickAndUploadImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(_email ?? '', style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            Text(_username ?? '', style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
