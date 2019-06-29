import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:favor_chapel_international/commons/collapsing_navigation_drawer.dart';
import 'package:favor_chapel_international/util/Items.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class UploadSermon extends StatefulWidget {
  @override
  _UploadSermonState createState() => _UploadSermonState();
}

class _UploadSermonState extends State<UploadSermon> {
  SharedPreferences sharedPreferences;

  DatabaseReference itemRef;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool alertShowing = false;
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
    saveDraft("load");
    item = Item("", "", "", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    itemRef = database.reference().child("sermon").child('items');
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!");
    saveDraft("save");
    // Do some stuff.
    return true;
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
              'Upload Sermon',
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
                                  clearAll();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Clear All',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
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
                                    'Upload Sermon',
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

  void showCloseDialog() {
    if (alertShowing == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Alert"),
              content:
                  new Text("Do you want to first save as draft or just exit?"),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      saveDraft("save");
                    },
                    child: new Text("Save Draft")),
                new FlatButton(
                    onPressed: () {
                      back();
                    },
                    child: new Text("Exit"))
              ],
            );
          });
    }
    alertShowing = !alertShowing;
  }

  Future saveDraft(String type) async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (type == "save") {
      print("Saving");
      sharedPreferences.setString("savedSermonTitle", titleController.text);
      print("savedSermonTitle: " + titleController.text);
      sharedPreferences.setString("savedSermonBody", bodyController.text);
      print("savedSermonBody: " + bodyController.text);
      sharedPreferences.setString("savedSermonPostBy", postedByController.text);
      print("savedSermonPostBy: " + postedByController.text);
      sharedPreferences.setString(
          "savedSermonStartDate", startDateController.text);
      print("savedSermonStartDate: " + startDateController.text);
      sharedPreferences.setString("savedSermonEndDate", endDateController.text);
      print("savedSermonEndDate: " + endDateController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    } else if (type == "load") {
      try {
        print("Loading");
        titleController.text = sharedPreferences.getString("savedSermonTitle");
        bodyController.text = sharedPreferences.getString("savedSermonBody");
        postedByController.text =
            sharedPreferences.getString("savedSermonPostBy");
        startDateController.text =
            sharedPreferences.getString("savedSermonStartDate");
        endDateController.text =
            sharedPreferences.getString("savedSermonEndDate");
        print("savedSermonTitle: " + titleController.text);
        print("savedSermonBody: " + bodyController.text);
        print("savedSermonPostBy: " + postedByController.text);
        print("savedSermonStartDate: " + startDateController.text);
        print("savedSermonEndDate: " + endDateController.text);
      } catch (e) {}
    }
  }

  void back() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  void clearAll() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print("Clearing");
    titleController.text = "";
    bodyController.text = "";
    postedByController.text = "";
    startDateController.text = "";
    endDateController.text = "";
    sharedPreferences.setString("savedSermonTitle", "");
    print("savedSermonTitle: " + titleController.text);
    sharedPreferences.setString("savedSermonBody", "");
    print("savedSermonBody: " + bodyController.text);
    sharedPreferences.setString("savedSermonPostBy", "");
    print("savedSermonPostBy: " + postedByController.text);
    sharedPreferences.setString("savedSermonStartDate", "");
    print("savedSermonStartDate: " + startDateController.text);
    sharedPreferences.setString("savedSermonEndDate", "");
    print("savedSermonEndDate: " + endDateController.text);
  }
}
