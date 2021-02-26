import 'package:flutter/material.dart';

import 'dart:io';
import 'about_screen.dart';
import 'categories_screen.dart';
import 'favorite_screen.dart';
import 'help_screen.dart';

class TabScreen extends StatefulWidget {
  TabScreen();

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': CategoriesGrid(),
      'title': "Categories",
    },
    {
      'page': FavoriteScreen(),
      'title': 'Favorites',
    },
    {
      'page': AboutPage(),
      'title': "About",
    },
    {
      'page': HelpPage(),
      'title': 'Help',
    },
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  bool isConnected = true;
  Future<void> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  void initState() {
    _checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _selectPage,
            backgroundColor: Theme.of(context).backgroundColor,
            unselectedItemColor: Theme.of(context).primaryColor,
            selectedItemColor: Theme.of(context).accentColor,
            currentIndex: _selectedPageIndex,
            items: [
              BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).backgroundColor,
                  icon: Icon(Icons.category),
                  label: 'Categories'),
              BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).backgroundColor,
                  icon: Icon(Icons.favorite),
                  label: 'Favorites'),
              BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).backgroundColor,
                  icon: Icon(Icons.group_rounded),
                  label: 'About Us'),
              BottomNavigationBarItem(
                  backgroundColor: Theme.of(context).backgroundColor,
                  icon: Icon(Icons.help),
                  label: 'Help'),
            ]),
        body: isConnected
            ? _pages[_selectedPageIndex]['page']
            : Center(
                child: Text("No Internet Connection"),
              ));
  }
}
