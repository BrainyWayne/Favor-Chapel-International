import 'dart:io';

import 'package:favor_chapel_international/uploadEvent.dart';
import 'package:favor_chapel_international/util/Items.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'SermonDetails.dart';
import 'commons/collapsing_navigation_drawer.dart';
import 'commons/theme.dart';
import 'locate_us.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import 'package:image_picker_ui/image_picker_handler.dart';
import 'package:transparent_image/transparent_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var url;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Quicksand'),
      home: Scaffold(
          floatingActionButton: new FloatingActionButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadEvent())),
            tooltip: 'Add new weight entry',
            child: new Icon(Icons.add),
          ),
          drawer: CollapsingNavigationDrawer(),
          appBar: GradientAppBar(
            elevation: 0.0,
            backgroundColorStart: Colors.redAccent,
            backgroundColorEnd: Colors.red,
            title: Text(
              'Favor Chapel International',
              style: TextStyle(fontSize: 18),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                child: Home(),
              ),

              // LocateUs(),
            ],
          )),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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

    itemRef = database.reference().child('items');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white30,
      body: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              physics: BouncingScrollPhysics(),
              reverse: true,
              query: itemRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
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
                                    child: RefreshProgressIndicator(),
                                    alignment: Alignment.center,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: FadeInImage.memoryNetwork(
                                          fit: BoxFit.cover,
                                          placeholder: kTransparentImage,
                                          image: items[index].imageUrl),
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  )
                                ],
                              ),
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ],
                        ),
                        Align(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.play_arrow, color: Colors.redAccent,),
                                    Flexible(
                                      child: Align(
                                        child: Text(
                                          items[index].title,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        alignment: Alignment.topLeft,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 26),
                                  child: Divider(
                                    height: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 26.0),
                                  child: Align(
                                    child: Text(
                                      items[index].body,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
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
                                            const EdgeInsets.only(left: 26.0),
                                        child: Row(
                                          children: <Widget>[
                                            Align(
                                              child: Text(
                                                items[index].postedBy,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              alignment: Alignment.topLeft,
                                            ),
                                            Align(
                                              child: Text(
                                                " | " + items[index].startDate,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              alignment: Alignment.topLeft,
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
    );
  }


}
