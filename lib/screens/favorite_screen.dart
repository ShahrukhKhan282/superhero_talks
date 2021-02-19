import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'wallpaper_screen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<dynamic> data = [];
  @override
  void initState() {
    _getData();
    super.initState();
  }

  Box box = Hive.box("urlBox");
  void _getData() {
    data = box.values.toSet().toList();
    box.deleteAll(box.keys);
    for (int i = 0; i < data.length; i++) {
      box.add(data[i]);
    }

    data = data.reversed.toList();
  }

  void _removeFavorite(int index) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("Remove From Favorite."),
                content: Text("Are you sure?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Box box = Hive.box("urlBox");
                        box.deleteAt(index);
                        _getData();
                      });
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Removed From Favorites.")));
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Text("No"),
                  ),
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Remove From Favorite."),
                content: Text("Are you sure?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          Box box = Hive.box("urlBox");
                          box.deleteAt(index);
                          _getData();
                        },
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Removed From Favorites."),
                        ),
                      );
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No"),
                  ),
                ],
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return box.isEmpty
        ? Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              centerTitle: false,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).backgroundColor,
                        content: Container(
                          height: MediaQuery.of(context).size.height * .25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10),
                              Text(
                                "Long Press Wallpaper To Remove From Favorites.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              Divider(),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"))
                            ],
                          ),
                        )),
                  ),
                ),
              ],
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
              title: Text(
                "Favorites",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            body: Center(
              child: Text(
                "No Favorites Found!\nTry Adding Some.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor),
              ),
            ),
          )
        : Container(
            color: Theme.of(context).backgroundColor,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  centerTitle: false,
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            backgroundColor: Theme.of(context).backgroundColor,
                            content: Container(
                              height: MediaQuery.of(context).size.height * .25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 40,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(height: 10),
                                  Divider(),
                                  SizedBox(height: 10),
                                  Text(
                                    "Long Press Wallpaper To Remove From Favorites.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Divider(),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"))
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                  backgroundColor: Theme.of(context).backgroundColor,
                  elevation: 0,
                  title: Text(
                    "Favorites",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  floating: true,
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return InkWell(
                      onLongPress: () =>
                          _removeFavorite(data.length - index - 1),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) =>
                              WallpaperView(data, index, FavoriteScreen),
                        ))
                            .then((value) {
                          setState(() {
                            _getData();
                          });
                        });
                      },
                      child: Card(
                        color: Theme.of(context).backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 10,
                        child: Hero(
                          tag: index,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Image.asset(
                                'assets/logo/loading.gif',
                                fit: BoxFit.cover,
                              ),
                              imageUrl: data[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }, childCount: data.length),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 1 / 1.7),
                ),
              ],
            ),
          );
  }
}
