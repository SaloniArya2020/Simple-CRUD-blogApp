import 'dart:io';

import 'package:blog_app/Screens/home.dart';
import 'package:blog_app/Screens/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadBlogScreen extends StatefulWidget {
  const UploadBlogScreen({Key? key}) : super(key: key);

  @override
  _UploadBlogScreenState createState() => _UploadBlogScreenState();
}

class _UploadBlogScreenState extends State<UploadBlogScreen> {
  bool isUploading = false;
  final _key = GlobalKey<FormState>();
  XFile? file;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String blogId = FirebaseFirestore.instance.collection('blogs').doc().id;

  handleTakePhoto() async {
    Navigator.pop(context);
    print('file');
    file = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxHeight: 675,
        maxWidth: 960);

    setState(() {
      this.file = file;
    });
  }

  handleChoosePhoto() async {
    Navigator.pop(context);

    file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 675,
        maxWidth: 960,
        imageQuality: 85);

    setState(() {
      this.file = file;
    });
  }

  showDialogBox(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select Image'),
            children: [
              SimpleDialogOption(
                onPressed: handleTakePhoto,
                child: Text('Take Photo'),
              ),
              SimpleDialogOption(
                onPressed: handleChoosePhoto,
                child: Text('Choose Photo'),
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Future<String> uploadImageToStorage(File imgFile) async {
    Reference ref = FirebaseStorage.instance.ref('path_$blogId.jpg');

    final TaskSnapshot snapshot = await ref.putFile(imgFile);

    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  uploadBlogToFirebase(String mediaUrl, String title, String content) async {
    try {

      await FirebaseFirestore.instance.collection('blogs').doc(blogId).set({
        'ownerId': currentUser!.uid,
        'username': currentUser!.username,
        'blogId': blogId,
        'mediaUrl': mediaUrl,
        'title': title,
        'content': content,
        'timestamp': DateTime.now()
      }).whenComplete(() {
        _contentController.clear();
        _titleController.clear();

        blogId = FirebaseFirestore.instance.collection('blogs').doc().id;


        setState(() {
          isUploading = false;
          file = null;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

        final snackBar = SnackBar(content: Text('Blog Posted Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });

    } catch (e) {
      print(e.toString());
    }
  }

  handleSubmit() async {
    if (_key.currentState!.validate()) {
      setState(() {
        isUploading = true;
      });
      String mediaUrl = await uploadImageToStorage(File(file!.path));

      uploadBlogToFirebase(mediaUrl, _titleController.text.trim(),
          _contentController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          isUploading ? LinearProgressIndicator() : Text(''),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  file == null
                      ? Container(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              showDialogBox(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green[600]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.link,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '  Select Image',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 300,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        File(file!.path),
                                      ))),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),

                  // Title field
                  TextFormField(
                    controller: _titleController,
                    validator: (val) =>
                        val!.isEmpty ? 'Please write title' : null,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  //
                  TextFormField(
                    validator: (val) {},
                    controller: _contentController,
                    decoration: InputDecoration(
                        hintText: 'Content ...',
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey))),
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Upload Button
                  GestureDetector(
                    onTap: isUploading ? null : handleSubmit,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: double.infinity - 190,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isUploading
                              ? Colors.blue[200]
                              : Colors.blue[500]),
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
