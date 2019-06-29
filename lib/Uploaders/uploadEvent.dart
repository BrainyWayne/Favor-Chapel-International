import 'dart:io';

import 'package:favor_chapel_international/commons/collapsing_navigation_drawer.dart';
import 'package:favor_chapel_international/util/Items.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';

class UploadEvent extends StatefulWidget {
  @override
  _UploadEventState createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  DatabaseReference itemRef;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Item item;
  var downloadUrl;
  TextEditingController titleController = new TextEditingController();
  TextEditingController bodyController = new TextEditingController();
  TextEditingController startDateController = new TextEditingController();
  TextEditingController endDateController = new TextEditingController();
  TextEditingController postedByController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    item = Item("", "", "", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRef = database.reference().child("events").child('items');
    //   BackButtonInterceptor.add(myInterceptor);
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
              'Upload Event',
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
                                    hintText: 'ENTER TITLE',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                )),
                            ListTile(
                                leading: Icon(Icons.info),
                                title: TextField(
                                  controller: bodyController,
                                  textAlign: TextAlign.left,
                                  minLines: 1,
                                  maxLines: 20,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'ENTER BODY',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                )),
                            ListTile(
                                leading: Icon(Icons.person),
                                title: TextField(
                                  controller: postedByController,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Post by',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                )),
                            ListTile(
                                leading: Icon(Icons.date_range),
                                title: TextField(
                                  controller: startDateController,
                                  enabled: false,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Start Date',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 56),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: FlatButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(2018, 3, 5),
                                          maxTime: DateTime(2025, 6, 7),
                                          onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (startDate) {
                                        print('confirm $startDate');
                                        setState(() {
                                          var StartDate =
                                              startDate.toString().split(" ");
                                          startDateController.text =
                                              StartDate[0];
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Text(
                                      '$startdate',
                                      style: TextStyle(color: Colors.blue),
                                    )),
                              ),
                            ),
                            ListTile(
                                leading: Icon(Icons.date_range),
                                title: TextField(
                                  enabled: false,
                                  controller: endDateController,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'End Date',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 56),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: FlatButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(2018, 3, 5),
                                          maxTime: DateTime(2025, 6, 7),
                                          onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        print('confirm $date');
                                        setState(() {
                                          var EndDate =
                                              date.toString().split(" ");
                                          endDateController.text = EndDate[0];
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Text(
                                      '$enddate',
                                      style: TextStyle(color: Colors.blue),
                                    )),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: InkWell(
                                onTap: () {
                                  handleSubmit();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Upload Event',
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

    if (bodyController.text != null) {
      item.body = bodyController.text;
    } else {
      return;
    }

    item.startDate = startDateController.text;
    item.endDate = endDateController.text;
    item.postedBy = postedByController.text;

    await photoOption();

    itemRef.push().set(item.toJson());

    titleController.text = "";
    bodyController.text = "";
    postedByController.text = "";
    startDateController.text = "";
    endDateController.text = "";
  }

  Future<String> photoOption() async {
    try {
      File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

      StorageReference ref = FirebaseStorage.instance
          .ref()
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
