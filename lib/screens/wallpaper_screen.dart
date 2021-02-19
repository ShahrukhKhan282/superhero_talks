import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class WallpaperView extends StatefulWidget {
  final int index;
  final List data;
  final Type screen;
  WallpaperView(this.data, this.index, this.screen);

  @override
  _WallpaperViewState createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  PageController _pageController;
  String _url;
  int location;
  var file;
  @override
  void initState() {
    _url = widget.data[widget.index];

    _getPath();
    super.initState();
  }

  _getPath() async {
    file = await DefaultCacheManager().getSingleFile(_url);
  }

  Future<void> _shareImage() async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(_url));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file(
              'SuperHero Talks', 'superhero_talks.jpg', bytes, 'image/jpg')
          .then((value) {
        Navigator.pop(context);
      });
    } catch (e) {
      print('error: $e');
    }
  }

  void _downloadImage() {
    if (Platform.isIOS) {
      Permission.photos.request();
    }
    try {
      ImageDownloader.downloadImage(_url).then((value) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Wallpaper Downloaded!"),
          ),
        );
      });
    } on PlatformException catch (error) {
      print(error);
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).backgroundColor,
          child: Container(
              width: MediaQuery.of(context).size.width * .2,
              height: MediaQuery.of(context).size.height * .18,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextButton(
                    onPressed: () {
                      location = WallpaperManager.HOME_SCREEN;
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Home Screen",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      location = WallpaperManager.LOCK_SCREEN;
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Lock Screen",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      location = WallpaperManager.BOTH_SCREENS;
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Set Both",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              )),
        );
      },
    ).then((value) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).backgroundColor,
            child: Container(
              padding: EdgeInsets.all(20),
              height: 75,
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Changing Wallpaper..",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
          );
        },
      );
      Timer(Duration(seconds: 1), () => _setWallpaper());
    });
  }

  void _setWallpaper() async {
    try {
      Platform.isIOS
          ? Permission.photos.request()
          : Permission.storage.request();
      file = await DefaultCacheManager().getSingleFile(_url);
      await WallpaperManager.setWallpaperFromFile(file.path, location)
          .then((value) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Wallpaper Set Successfully"),
          ),
        );
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void _addToFavorite(String url) {
    Box box = Hive.box("urlBox");
    box.add(url);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Added To Favorites."),
      ),
    );
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
                      Box box = Hive.box("urlBox");
                      box.deleteAt(index);

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Removed From Favorites.")));
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
                      Box box = Hive.box("urlBox");
                      box.deleteAt(index);
                      Navigator.of(context).pop();
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
    _pageController = PageController(
      initialPage: widget.index,
    );
    return Scaffold(
      extendBody: true,
      floatingActionButton: SpeedDial(
        backgroundColor: Theme.of(context).backgroundColor,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(
          size: 22.0,
          color: Theme.of(context).primaryColor,
        ),
        children: [
          SpeedDialChild(
            label: widget.screen.toString() == "FavoriteScreen"
                ? 'Remove From Favorites'
                : 'Add To Favorites',
            child: IconButton(
              icon: Icon(
                widget.screen.toString() == "FavoriteScreen"
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: () => {
                if (widget.screen.toString() == "FavoriteScreen")
                  {
                    _removeFavorite(widget.data.length - widget.index - 1),
                  }
                else
                  {_addToFavorite(_url)}
              },
            ),
          ),
          SpeedDialChild(
            label: 'Download',
            child: IconButton(
              icon: Icon(
                Icons.download_sharp,
                color: Colors.white,
              ),
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Theme.of(context).backgroundColor,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        height: 75,
                        child: new Row(
                          children: [
                            new CircularProgressIndicator(),
                            SizedBox(
                              width: 15,
                            ),
                            new Text(
                              "Downloading..",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                _downloadImage(),
              },
            ),
          ),
          SpeedDialChild(
            label: 'Share',
            child: IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Theme.of(context).backgroundColor,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        height: 75,
                        child: new Row(
                          children: [
                            new CircularProgressIndicator(),
                            SizedBox(
                              width: 15,
                            ),
                            new Text(
                              "Please Wait...",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                _shareImage(),
              },
            ),
          ),
          Platform.isIOS
              ? SpeedDialChild(
                  backgroundColor: Colors.transparent, elevation: 0)
              : SpeedDialChild(
                  label: 'Set as Wallpaper',
                  child: IconButton(
                    icon: Icon(
                      Icons.mobile_friendly,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _showDialog();
                    },
                  ),
                ),
        ],
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(
          onPageChanged: (value) {
            _url = widget.data[value];
          },
          controller: _pageController,
          children: widget.data.map((e) {
            return Hero(
              tag: widget.index,
              child: CachedNetworkImage(
                placeholder: (context, url) => Image.asset(
                  'assets/logo/loading.gif',
                  fit: BoxFit.cover,
                ),
                imageUrl: e,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          }).toList()),
    );
  }
}
