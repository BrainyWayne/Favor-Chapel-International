import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  SharedPreferences prefs;

  @override
  initState() {
    super.initState();

    checkFirstTime();
  }

  PageController _pageController = new PageController(viewportFraction: 1);
  TextEditingController titleController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Shader _linearGradient = LinearGradient(
      colors: <Color>[Colors.red, Colors.orange],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200, 70));

    TextStyle _welcomeTextStyleSmall = TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w500,
        foreground: Paint()..shader = _linearGradient);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: Scaffold(
        body: new AnimatedContainer(
            color: Colors.red,
            duration: Duration(milliseconds: 400),
            child: Center(
              child: Stack(
                children: <Widget>[
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Image.asset(
                                          "assets/images/churchlogo.png"),
                                      SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                Text(
                                  'Tell us a bit about you for a personalized experience',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Tell us your name',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: ListTile(
                                        leading: Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                        ),
                                        title: TextField(
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          controller: titleController,
                                          keyboardType: TextInputType.text,
                                          cursorColor: Colors.white,
                                          textAlign: TextAlign.left,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter Your Name',
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.red,
                                          Colors.orange
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _pageController.animateToPage(1,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.decelerate);
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(colors: [
                                              Colors.red,
                                              Colors.orange
                                            ])),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 22, vertical: 10),
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        margin: EdgeInsets.only(
                                            top: 20, bottom: 30),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.white, Colors.white]),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset("assets/images/churchlogo.png"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Hi ' + titleController.text,
                                    style: _welcomeTextStyleSmall),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Tell us your email',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: ListTile(
                                        leading: Icon(
                                          Icons.email,
                                          color: Colors.white,
                                        ),
                                        title: TextField(
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          controller: emailController,
                                          keyboardType: TextInputType.text,
                                          cursorColor: Colors.white,
                                          textAlign: TextAlign.left,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'someone@example.com',
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.red,
                                          Colors.orange
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    proceed();
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(colors: [
                                              Colors.red,
                                              Colors.orange
                                            ])),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 22, vertical: 10),
                                          child: Text(
                                            'Done',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        margin: EdgeInsets.only(top: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _pageController.animateToPage(0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.decelerate);
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            gradient: LinearGradient(colors: [
                                              Colors.white,
                                              Colors.white
                                            ])),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 22, vertical: 10),
                                          child: Text(
                                            'Go back And Edit Name',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        margin: EdgeInsets.only(top: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.white, Colors.white]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void proceed() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", titleController.text);
    print(titleController.text + " saved as name");
    await prefs.setString("email", emailController.text);
    print(emailController.text + " saved as email");
    await prefs.setBool("firsttime", false);
    print("firsttime is false now");
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  Future checkFirstTime() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    try {
      if (prefs.getBool("firsttime") == false) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      } else {}
    } catch (e) {}
  }
}
