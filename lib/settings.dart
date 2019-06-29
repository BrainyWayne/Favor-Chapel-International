import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commons/collapsing_navigation_drawer.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    loadUserInfo();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!");
    Navigator.pop(context); // Do some stuff.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: Scaffold(
          drawer: CollapsingNavigationDrawer(),
          appBar: GradientAppBar(
            elevation: 0.0,
            backgroundColorStart: Colors.redAccent,
            backgroundColorEnd: Colors.yellow,
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 18),
            ),
          ),
          body: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                                leading: Icon(
                                  Icons.account_circle,
                                  color: Colors.redAccent,
                                  size: 30,
                                ),
                                title: TextField(
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.white,
                                  textAlign: TextAlign.left,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                            leading: Icon(
                              Icons.email,
                              color: Colors.redAccent,
                              size: 30,
                            ),
                            title: TextField(
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              controller: emailController,
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.white,
                              textAlign: TextAlign.left,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Version 1.0',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future loadUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String name = sharedPreferences.getString("name");
    print(name + " saved as name");
    titleController.text = name;

    String email = sharedPreferences.getString("email");
    print(email + " saved as email");
    emailController.text = email;
  }
}
