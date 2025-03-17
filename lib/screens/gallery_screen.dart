import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'wallpaper_screen.dart';

class GalleryScreen extends StatefulWidget {
  final title, tag;
  GalleryScreen(this.title, this.tag);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<dynamic> data = [];
  String url = "";

  bool isLoading = true;
  Future<void> fetchUrl() async {
    url = "https://iamshahrukh.net/wallpapers/" + widget.tag + "/fetch.php";
    await http.get(url).then((value) {
      setState(() {
        data = jsonDecode(value.body) as List;
        data = data.reversed.toList();
        isLoading = false;
      });
    });
  }

  double _scaleFactor = 250;
  double _baseScaleFactor = 100.0;

  @override
  void initState() {
    fetchUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            _scaleFactor = _baseScaleFactor * details.scale;
          });
        },
        onScaleStart: (details) {
          _baseScaleFactor = _scaleFactor;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black,
              stretch: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [StretchMode.zoomBackground],
                  centerTitle: true,
                  title: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  background: Hero(
                    tag: widget.tag,
                    child: Image.asset(
                      'assets/logo/' + widget.tag + ".jpg",
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
            SliverGrid(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return InkWell(
                  onTap: isLoading
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                WallpaperView(widget.tag, data, index),
                          ));
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
                        child: isLoading
                            ? Image.asset(
                                'assets/logo/loading.gif',
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                placeholder: (context, url) => Image.asset(
                                  'assets/logo/loading.gif',
                                  fit: BoxFit.cover,
                                ),
                                imageUrl:
                                    "https://iamshahrukh.net/wallpapers/" +
                                        widget.tag +
                                        "/" +
                                        data[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                    ),
                  ),
                );
              }, childCount: isLoading ? 10 : data.length),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  maxCrossAxisExtent: _scaleFactor,
                  childAspectRatio: 1 / 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
