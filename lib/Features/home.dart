import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';
import 'dart:ui' as ui;

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  HomeViewBodyState createState() => HomeViewBodyState();
}

class HomeViewBodyState extends State<HomeViewBody> {
  File? _image;
  ui.Image? _imageData;
  List<Face> _faces = [];
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _faces = [];
        _isProcessing = true;
      });
      await _loadImage(_image!);
      await _detectFaces(_image!);
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _faces = [];
        _isProcessing = true;
      });
      await _loadImage(_image!);
      await _detectFaces(_image!);
    }
  }

  Future<void> _loadImage(File imageFile) async {
    final data = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frame = await codec.getNextFrame();
    setState(() {
      _imageData = frame.image;
    });
  }

  Future<void> _detectFaces(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    try {
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      setState(() {
        _faces = faces;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
      _imageData = null;
      _faces = [];
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Detection")),
      body: Column(
        children: [
          Expanded(
            child: _image == null || _imageData == null
                ? Center(child: Text("No Image Selected"))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      double scaleX = constraints.maxWidth / _imageData!.width;
                      double scaleY =
                          constraints.maxHeight / _imageData!.height;
                      return Stack(
                        children: [
                          Image.file(_image!,
                              fit: BoxFit.cover, width: constraints.maxWidth),
                          if (_isProcessing)
                            Center(child: CircularProgressIndicator()),
                          ..._faces.map(
                            (face) {
                              return Positioned(
                                left: face.boundingBox.left * scaleX,
                                top: face.boundingBox.top * scaleY,
                                width: face.boundingBox.width * scaleX,
                                height: face.boundingBox.height * scaleY,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.green, width: 3),
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.black54,
                              child: Text(
                                "Detected Faces: ${_faces.length}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: _pickImage, child: Text("Pick Photo")),
              ElevatedButton(onPressed: _takePhoto, child: Text("Take Photo")),
              ElevatedButton(onPressed: _clearImage, child: Text("Clear")),
            ],
          ),
        ],
      ),
    );
  }
}
