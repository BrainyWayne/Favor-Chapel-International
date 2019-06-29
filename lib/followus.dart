import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'commons/collapsing_navigation_drawer.dart';

class FollowUs extends StatefulWidget {
  @override
  _FollowUsState createState() => _FollowUsState();
}

class _FollowUsState extends State<FollowUs> {
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
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: Scaffold(
          backgroundColor: Colors.white,
          drawer: CollapsingNavigationDrawer(),
          appBar: GradientAppBar(
            elevation: 0.0,
            backgroundColorStart: Colors.redAccent,
            backgroundColorEnd: Colors.yellow,
            title: Text(
              'Follow Us',
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
                  Container(
                    child: Image.asset("assets/images/churchlogo.png"),
                    width: 300,
                    height: 300,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Image.asset(
                                      "assets/images/instagram.png"),
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Follow Us on Instagram',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            onTap: _launchUrl,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Image.asset("assets/images/twitter.png"),
                                width: 62,
                                height: 62,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Follow Us on Twitter',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          onTap: _launchUrlTwitter,
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
                ],
              ),
            ),
          )),
    );
  }

  _launchUrl() async {
    const url = "https://instagram.com/favorchapel?igshid=1xjftfh7mk1mj";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchUrlTwitter() async {
    const url = "https://twitter.com/favorchapel?s=09";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
