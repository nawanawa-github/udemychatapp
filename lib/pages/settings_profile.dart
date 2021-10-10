import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SettingsProfilePage extends StatefulWidget {
 @override
  _SettingsProfilePageState createState() => _SettingsProfilePageState();
}

class _SettingsProfilePageState extends State<SettingsProfilePage> {
  File? image;
  ImagePicker picker = ImagePicker();

  Future<void> getInamgeFormGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      image = File(pickedFile.path);
      uploadImage();
      setState(() {});
    }
  }

  Future<String> uploadImage() async{
    final ref = FirebaseStorage.instance.ref('sample');
    final storedImage = await ref.putFile(image!);
    String imagePath = await loadImage(storedImage);
    return imagePath;
  }

  Future<String> loadImage(TaskSnapshot storedImage) async{
    String downloadUrl = await storedImage.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィール編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(width: 100, child: Text('名前')),
                Expanded(child: TextField()),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Container(width: 100, child: Text('サムネイル')),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 150, height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          getInamgeFormGallery();
                        },
                        child: Text('画像を選択'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height:  30,),
            image == null ? Container() : Container(
              width: 200,
              height: 200,
              child:  Image.file(image!, fit: BoxFit.cover),
            ),

          ],
        ),
      ),
    );
  }
}