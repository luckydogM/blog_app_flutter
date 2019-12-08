import 'package:flutter/material.dart';

class TabBarItem extends BottomNavigationBarItem {
  TabBarItem(icon,String title):super(
    icon: icon,
    title: Text(title)
  );
}