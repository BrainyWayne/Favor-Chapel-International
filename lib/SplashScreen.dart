/*
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin  {

  Animation _iconAnimation;
  void handleTimeout() {

  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeout);
  }

  @override
  void initState() {
    AnimationController _iconAnimationController;

    // TODO: implement initState
    super.initState();

    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));

    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeIn);
    _iconAnimation.addListener(() => this.setState(() {}));

    _iconAnimationController.forward();

    Future.delayed(const Duration(milliseconds: 2000), () {

// Here you can write your code

      setState(() {
        // Here you can write your code for open new view
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp()));
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: new Scaffold(
        backgroundColor: Colors.white,
        body: new Scaffold(
          backgroundColor: Colors.white,
          body: new Center(
              child: new Image(
                image: new AssetImage("assets/images/churchlogo.png"),
                width: _iconAnimation.value * 200,
                height: _iconAnimation.value * 200,
              )),
        ),
      ),
    );
  }
}

*/

import 'package:favor_chapel_international/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new WelcomePage(),
        image: new Image.asset("assets/images/churchlogo.png"),
        backgroundColor: Colors.white,
        photoSize: 100.0,
      ),
    );
  }
}
