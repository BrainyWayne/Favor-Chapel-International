import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'commons/theme.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    super.initState();

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
    return AnimatedContainer(
      color: Colors.white,
      duration: Duration(milliseconds: 200),
      curve: Curves.decelerate,
      child: new MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Quicksand'),
        home: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.redAccent, Colors.yellow])),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.redAccent, Colors.yellow])),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 40),
                          Container(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'About Us',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      )),
                  Image.asset("assets/images/churchlogo.png"),
                  Container(
                    child: Text(
                      'We are a holy spirit filled charismatic church raising generations full of the holy spirit, obedient to God and Zealous of good works. Achieving our mission through education, health care, social welfare interventions and descipling the nation \'s by teaching the unadultrated word of God. \n\nWe are passionate about making our church a centre for ideas and God given solutions for a better future',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Contact us',
                          style: TextStyle(
                              color: drawerBackgroundColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            decoration:
                                BoxDecoration(border: Border.all(width: 0.25)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.phone),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Phone',
                                    style: TextStyle(
                                        color: drawerBackgroundColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 8),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '+233 (0) 244 044 013',
                                      style: TextStyle(
                                          color: drawerBackgroundColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            _launchDialer();
                          },
                        ),

                        /*  FlutterYoutubeView(
                  onViewCreated: _onYoutubeCreated,
                  listener: this,
                  scaleMode: YoutubeScaleMode.none, // <option> fitWidth, fitHeight
                  params: YoutubeParam(
                      videoId: 'gcj2RUWQZ60',
                      showUI: false,
                      startSeconds: 0.0) // <option>
              ),*/

                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.email),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                        color: drawerBackgroundColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 8),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'eshunfrancisboateng@gmail.com',
                                      style: TextStyle(
                                          color: drawerBackgroundColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            _launchEmail('eshunfrancisboateng@gmail.com',
                                'Favor Chapel International', 'Hello,\n');
                          },
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchEmail(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch email';
    }
  }
}

_launchDialer() async {
  const url = "tel:0244044013";

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
