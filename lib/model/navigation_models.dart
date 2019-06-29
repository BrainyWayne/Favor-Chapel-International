import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;

  NavigationModel({this.title, this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: 'Sermon', icon: Icons.book),
  NavigationModel(title: 'Donate', icon: Icons.work),
  NavigationModel(title: 'Videos', icon: Icons.video_library),
  NavigationModel(title: 'Photos', icon: Icons.photo),
  NavigationModel(title: 'Favorites', icon: Icons.favorite),
  NavigationModel(title: 'Events', icon: Icons.event),
  NavigationModel(title: 'Settings', icon: Icons.settings),
  NavigationModel(title: 'Follow us', icon: Icons.alternate_email),
  NavigationModel(title: 'Locate us', icon: Icons.location_on),
  NavigationModel(title: 'About us', icon: Icons.group),
];
