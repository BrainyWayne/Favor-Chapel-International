import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:favor_chapel_international/util/Items.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FullImage.dart';

class SermonDetails extends StatefulWidget {
  final String title;
  final String details;
  final String imageUrl;
  final String postedBy;
  final String startDate;
  final String endDate;
  final String pageSent;

  SermonDetails(
      {Key key,
      @required this.title,
      @required this.details,
      this.pageSent,
      this.imageUrl,
      this.postedBy,
      this.startDate,
      this.endDate});

  @override
  _SermonDetailsState createState() => _SermonDetailsState();
}

class _SermonDetailsState extends State<SermonDetails> {
  String email;
  bool _visible = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  DatabaseReference favoritesRef;
  Item item;

  @override
  void initState() {
    super.initState();

    if (widget.pageSent == "favorites") {
      setState(() {
        _visible = false;
      });
    }

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
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              Scaffold(
                  appBar: GradientAppBar(
                    elevation: 10.0,
                    backgroundColorStart: Colors.redAccent,
                    backgroundColorEnd: Colors.yellow,
                    title: Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back)),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: Text(
                            widget.title,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Stack(
                    children: <Widget>[
                      Container(
                        child: SingleChildScrollView(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.decelerate,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      child: Stack(
                                        children: <Widget>[
                                          Align(
                                            child: RefreshProgressIndicator(),
                                            alignment: Alignment.center,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              child: CachedNetworkImage(
                                                imageUrl: widget.imageUrl,
                                                placeholder: (context, url) =>
                                                    new LinearProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                                fit: BoxFit.fitWidth,
                                                fadeInCurve:
                                                    Curves.easeInOutCirc,
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                          )
                                        ],
                                      ),
                                      height: 400,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullImage(
                                                    imageUrl: widget.imageUrl,
                                                  )));
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () async {
                                            var response = await FlutterShareMe()
                                                .shareToSystem(
                                                    msg:
                                                        "*A message from Favor Chapel International.*\n\n" +
                                                            "*Title: " +
                                                            widget.title +
                                                            "*" +
                                                            "\n\n" +
                                                            widget.details);
                                            if (response == 'success') {
                                              showInSnackBar(
                                                  "Sharing " + widget.title);
                                            }
                                          },
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 26),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                      size: 17,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Share",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Visibility(
                                          visible: _visible,
                                          child: InkWell(
                                            onTap: () {
                                              addToFavorites();
                                            },
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 16),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 12),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.favorite,
                                                        color: Colors.white,
                                                        size: 17,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Add to favorites",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 5),
                                      child: Text(
                                        "Posted by " +
                                            widget.postedBy +
                                            " on " +
                                            widget.startDate,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                  Align(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 5),
                                      child: Text(
                                        widget.title,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 5),
                                      child: Text(
                                        widget.details,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // LocateUs(),
                    ],
                  )),

              // LocateUs(),
            ],
          )),
    );
  }

  void addToFavorites() {
    if (widget.title != null) {
      item.title = widget.title;
      item.body = widget.details;
      item.startDate = widget.startDate;
      item.endDate = widget.endDate;
      item.postedBy = widget.postedBy;
      item.imageUrl = widget.imageUrl;

      favoritesRef.push().set(item.toJson());

      item.title = "";
      item.body = "";
      item.startDate = "";
      item.endDate = "";
      item.postedBy = "";
      item.imageUrl = "";

      showInSnackBar(widget.title + " added to favorites");
    }
  }

  Future loadUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    item = Item("", "", "", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    email = sharedPreferences.getString("email");
    print(email + " saved as email");

    var splitEmail = email.split("@");
    email = splitEmail[0];
    print("Split email is " + email);

    favoritesRef = database.reference().child(email).child('favorites');
  }
}
