import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:favor_chapel_international/util/Items.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SermonDetails.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Item> items = List();
  Item item;
  DatabaseReference itemRef;
  DatabaseReference favoritesRef;
  FirebaseDatabase database;
  String email;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    database = FirebaseDatabase.instance;
    favoritesRef = database.reference().child('favorites');
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
      appBar: GradientAppBar(
        backgroundColorStart: Colors.red,
        backgroundColorEnd: Colors.yellow,
        elevation: 10.0,
        title: Row(
          children: <Widget>[
            Text(
              'Favorites',
            )
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              physics: BouncingScrollPhysics(),
              query: favoritesRef,
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
                                  pageSent: "favorites",
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
                                      child: CachedNetworkImage(
                                        imageUrl: items[index].imageUrl,
                                        placeholder: (context, url) =>
                                            new LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                        fit: BoxFit.fitWidth,
                                        fadeInCurve: Curves.easeInOutCirc,
                                      ),
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

  Future loadUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString("email");
    print(email + " saved as email");

    var splitEmail = email.split("@");
    email = splitEmail[0];
    print("Split email is " + email);

    database = FirebaseDatabase.instance;
    //Rather then just writing FirebaseDatabase(), get the instance.
    item = Item("", "", "", "", "", "");

    itemRef = database.reference().child('items');
    favoritesRef = database.reference().child(email).child('favorites');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
    favoritesRef.onChildAdded.listen(_onEntryAdded);
    favoritesRef.onChildChanged.listen(_onEntryChanged);
  }
}
