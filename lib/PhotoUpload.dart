import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'HomePage.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File sampleImage;
  String _myvalue;
  final formkey = new GlobalKey<FormState>();
  String url;

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    var tempImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = File(tempImage.path);
    });
  }

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      var timekey = new DateTime.now();
      final StorageReference storageReference =
          FirebaseStorage().ref().child("Post Images");
      final StorageUploadTask uploadTask = storageReference
          .child(timekey.toString() + ".jpg")
          .putFile(sampleImage);
      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = ImageUrl.toString();
      print("Image Url" + url);
      goToHomePage();
      saveToDatabase(url);
    }
  }

  void saveToDatabase(url) {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d,yyyy');
    var formatTime = new DateFormat('EEEE,hh:mm aaa');
    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {
      "image": url,
      "description": _myvalue,
      "date": date,
      "time": time,
    };
    ref.child("Posts").push().set(data);
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.red, Colors.blue])),
        ),
        title: Text("Upload Image"),
        centerTitle: true,
      ),
      body: new Center(
        child: sampleImage == null ? Text("Select an Image") : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Form(
        key: formkey,
        child: Column(
          children: <Widget>[
            Image.file(
              sampleImage,
              height: 330,
              width: 660,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                return value.isEmpty ? 'Blog Description is required' : null;
              },
              onSaved: (value) {
                return _myvalue = value;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              elevation: 10.0,
              child: Text("Add a New Post"),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: uploadStatusImage,
            )
          ],
        ),
      ),
    );
  }
}
