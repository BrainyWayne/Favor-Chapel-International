import 'dart:io';

import 'package:favor_chapel_international/commons/collapsing_navigation_drawer.dart';
import 'package:favor_chapel_international/util/Items.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhoto extends StatefulWidget {
  @override
  _UploadPhotoState createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  DatabaseReference itemRef;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Item item;
  var downloadUrl;
  TextEditingController titleController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    item = Item("", "", "", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRef = database.reference().child("photos").child('items');
  }

  @override
  Widget build(BuildContext context) {
    var startdate = "Choose start date";
    var enddate = "Choose end date";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: Scaffold(
          drawer: CollapsingNavigationDrawer(),
          appBar: GradientAppBar(
            elevation: 10.0,
            backgroundColorStart: Colors.redAccent,
            backgroundColorEnd: Colors.yellow,
            title: Text(
              'Upload Photo',
              style: TextStyle(fontSize: 18),
            ),
          ),
          body: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 0,
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Flex(
                          direction: Axis.vertical,
                          children: <Widget>[
                            ListTile(
                                leading: Icon(Icons.info),
                                title: TextField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'ENTER DESCRIPTION',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: InkWell(
                                onTap: () {
                                  handleSubmit();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Upload Photo',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void handleSubmit() async {
    if (titleController.text != null) {
      item.title = titleController.text;
    } else {
      return;
    }

    item.startDate = "";
    item.endDate = "";
    item.postedBy = "";

    await photoOption();

    itemRef.push().set(item.toJson());

    titleController.text = "";
  }

  Future<String> photoOption() async {
    try {
      File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("photos")
          .child("images")
          .child(DateTime.now().millisecondsSinceEpoch.toString());
      StorageUploadTask uploadTask = ref.putFile(imageFile);

      downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      // downloadUrl = (await ref.getDownloadURL()).toString();
      item.imageUrl = downloadUrl.toString();

      /*     downloadUrl =
          (await uploadTask.onComplete).ref.getDownloadURL();*/

      print(downloadUrl);
    } catch (error) {
      print(error);
    }

    return downloadUrl;
  }
}
