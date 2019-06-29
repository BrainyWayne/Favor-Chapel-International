import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:favor_chapel_international/Uploaders/uploadPhoto.dart';
import 'package:favor_chapel_international/util/Items.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import 'FullImage.dart';
import 'commons/collapsing_navigation_drawer.dart';

class Photos extends StatefulWidget {
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  var url;
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final FirebaseDatabase database = FirebaseDatabase.instance;
    //Rather then just writing FirebaseDatabase(), get the instance.
    item = Item("", "", "", "", "", "");

    itemRef = database.reference().child("photos").child('items');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: Scaffold(
          floatingActionButton: new FloatingActionButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadPhoto())),
            tooltip: 'Add new weight entry',
            child: new Icon(Icons.add),
          ),
          drawer: CollapsingNavigationDrawer(),
          appBar: GradientAppBar(
            elevation: 0.0,
            backgroundColorStart: Colors.redAccent,
            backgroundColorEnd: Colors.yellow,
            title: Text(
              'Photos',
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
                                        builder: (context) => FullImage(
                                              imageUrl: items[index].imageUrl,
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
                                              MainAxisAlignment.center,
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
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Align(
                                                      child: Text(
                                                        items[index].title,
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      alignment: Alignment.center,
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

              // LocateUs(),
            ],
          )),
    );
  }
}
