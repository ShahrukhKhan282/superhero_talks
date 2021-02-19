import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'wallpaper_screen.dart';

class GalleryScreen extends StatefulWidget {
  final String url, title, tag;
  GalleryScreen(this.url, this.title, this.tag);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<dynamic> data = [];
  String url = "";

  bool isLoading = true;
  Future<void> fetchUrl() async {
    url =
        "https://superhero-wallpapers-703d6-default-rtdb.firebaseio.com/wallpaper/" +
            widget.tag +
            "/url.json";
    final response = await http.get(url);
    data = jsonDecode(response.body) as List;
    data = data.reversed.toList();
  }

  @override
  initState() {
    fetchUrl().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  double _scaleFactor = 250;
  double _baseScaleFactor = 100.0;
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
                      'assets/logo/' + widget.url,
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
            SliverGrid(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          WallpaperView(data, index, GalleryScreen),
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
                                imageUrl: data[index],
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
