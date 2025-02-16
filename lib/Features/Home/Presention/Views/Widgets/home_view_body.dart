// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart'; // Add this package

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  HomeViewBodyState createState() => HomeViewBodyState();
}

class HomeViewBodyState extends State<HomeViewBody> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _openCamera() async {
    bool hasPermission = await _requestCameraPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission is required!")),
      );
      return;
    }

    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select Method",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Detection From Real Time',
              icon: Icons.camera_alt,
              onPressed: _openCamera,
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Detection From Local Storage',
              icon: Icons.photo_library,
              onPressed: () {},
            ),
            SizedBox(height: 30),
            _image != null
                ? Image.file(_image!,
                    width: 250, height: 250, fit: BoxFit.cover)
                : Icon(Icons.image_not_supported,
                    color: Colors.white, size: 100),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}
