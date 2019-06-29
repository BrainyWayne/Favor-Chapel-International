import 'package:favor_chapel_international/commons/theme.dart';
import 'package:favor_chapel_international/model/navigation_models.dart';
import 'package:flutter/material.dart';

import '../about_us.dart';
import '../favorites.dart';
import '../locate_us.dart';
import '../main.dart';
import '../settings.dart';
import 'collapsing_list_tile.dart';

class CollapsingNavigationDrawer extends StatefulWidget {
  @override
  _CollapsingNavigationDrawerState createState() {
    return new _CollapsingNavigationDrawerState();
  }
}

class _CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 220;
  double minWidth = 0;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> _widthAnimation;
  int currentSelectedIndex = 0;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 00));
    _widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => getWidget(context, widget),
    );
  }

  Widget getWidget(BuildContext context, Widget widget) {
    return Material(
      elevation: 16,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: _widthAnimation.value,
        color: drawerBackgroundColor,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            CollapsingListTile(
              title: 'Francis Eshun',
              icon: Icons.person,
              animationController: _animationController,
            ),
            Divider(
              color: Colors.grey,
              height: 30,
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, counter) {
                    return Divider(
                      height: 20,
                    );
                  },
                  itemBuilder: (context, counter) {
                    return CollapsingListTile(
                      onTap: () {
                        setState(() {
                          currentSelectedIndex = counter;
                          if (currentSelectedIndex == 7) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutUs()));
                          } else if (currentSelectedIndex == 6) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocateUs()));
                          } else if (currentSelectedIndex == 4) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Settings()));
                          } else if (currentSelectedIndex == 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          } else if(currentSelectedIndex == 2){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Favorites()));
                          }
                        });
                      },
                      isSelected: currentSelectedIndex == counter,
                      title: navigationItems[counter].title,
                      icon: navigationItems[counter].icon,
                      animationController: _animationController,
                    );
                  },
                  itemCount: navigationItems.length),
            ),

            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
