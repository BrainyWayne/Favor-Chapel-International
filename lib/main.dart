import 'package:cached_network_image/cached_network_image.dart';
import 'package:favor_chapel_international/util/Items.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import 'SermonDetails.dart';
import 'SplashScreen.dart';
import 'Uploaders/uploadSermon.dart';
import 'commons/collapsing_navigation_drawer.dart';

void main() => runApp(Splash());

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;
  DatabaseReference favoritesRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase.instance;
    //Rather then just writing FirebaseDatabase(), get the instance.
    item = Item("", "", "", "", "", "");

    itemRef = database.reference().child("sermon").child('items');
    favoritesRef = database.reference().child('favorites');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
    favoritesRef.onChildAdded.listen(_onEntryAdded);
    favoritesRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
    });
  }

  var url;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: Scaffold(
          floatingActionButton: new FloatingActionButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadSermon())),
            tooltip: 'Add new weight entry',
            child: new Icon(Icons.add),
          ),
          drawer: CollapsingNavigationDrawer(),
          appBar: GradientAppBar(
            elevation: 20.0,
            backgroundColorStart: Colors.redAccent,
            backgroundColorEnd: Colors.yellow,
            title: Text(
              'Favor Chapel International',
              style: TextStyle(fontSize: 18),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                child: Scaffold(
                  resizeToAvoidBottomPadding: false,
                  backgroundColor: Colors.white30,
                  body: Column(
                    children: <Widget>[
                      Flexible(
                        child: FirebaseAnimatedList(
                          physics: BouncingScrollPhysics(),
                          reverse: false,
                          query: itemRef,
                          itemBuilder: (BuildContext context,
                              DataSnapshot snapshot,
                              Animation<double> animation,
                              int index) {
                            //Post list item
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SermonDetails(
                                              title: items[index].title,
                                              details: items[index].body,
                                              imageUrl: items[index].imageUrl,
                                              startDate: items[index].startDate,
                                              postedBy: items[index].postedBy,
                                              endDate: items[index].endDate,
                                            )));
                              },
                              child: new Container(
                                margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(10, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          child: Stack(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        items[index].imageUrl,
                                                    placeholder: (context,
                                                            url) =>
                                                        new LinearProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
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
                                          height: 300,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.redAccent,
                                                ),
                                                Flexible(
                                                  child: Align(
                                                    child: Text(
                                                      items[index].title,
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 26),
                                              child: Divider(
                                                height: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 26.0),
                                              child: Align(
                                                child: Text(
                                                  items[index].body,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  maxLines: 7,
                                                ),
                                                alignment: Alignment.topLeft,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 26.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Align(
                                                          child: Text(
                                                            items[index]
                                                                .postedBy,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          alignment:
                                                              Alignment.topLeft,
                                                        ),
                                                        Align(
                                                          child: Text(
                                                            " | " +
                                                                items[index]
                                                                    .startDate,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          alignment:
                                                              Alignment.topLeft,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      alignment: Alignment.topLeft,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
