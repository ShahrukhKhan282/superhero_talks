import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'wallpaper_screen.dart';
import 'gallery_screen.dart';
import 'package:http/http.dart' as http;

// final List<String> imgList = [
//   'https://wallpapercave.com/wp/wp2663986.png',
//   'https://www.mordeo.org/files/uploads/2020/09/Iron-Man-Fortnite-4K-Ultra-HD-Mobile-Wallpaper-950x1689.jpg',
//   'https://wallpapercave.com/wp/wp3003488.jpg',
//   'https://wallpapercave.com/wp/wp2538828.jpg',
//   'https://wallpapercave.com/wp/wp3003500.jpg',
//   'https://wallpapercave.com/wp/wp3003513.jpg',
//   'https://wallpapercave.com/wp/wp3003529.jpg',
//   'https://wallpapercave.com/wp/wp3003553.jpg',
//   'https://wallpapercave.com/wp/wp3003581.jpg',
// ];

class CategoriesGrid extends StatefulWidget {
  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  List<String> imgList = [];
  @override
  void initState() {
    _getRecentImages();
    super.initState();
  }

  //Map<String, List<String>>
  bool isLoading = true;
  final List<String> supnames = [
    "batman",
    "blackpanther",
    "captainamerica",
    "deadpool",
    "doctorstrange",
    "flash",
    "ironman",
    "joker",
    "spiderman",
    "superman",
    "thanos",
    "thor",
    "venom",
    "wanda"
  ];
  Future<void> _getRecentImages() async {
    Map<String, dynamic> data = {};
    String url =
        "https://superhero-wallpapers-703d6-default-rtdb.firebaseio.com/wallpaper.json";
    await http.get(url).then((value) {
      data = jsonDecode(value.body) as Map<String, dynamic>;
      supnames.forEach((element) {
        print(element);
        (data[element]['url'] as List)
            .reversed
            .toList()
            .sublist(0, 2)
            .forEach((e) {
          imgList.add(e.toString());
        });
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      WallpaperView(imgList, 0, CategoriesGrid),
                ));
              },
              child: Card(
                color: Theme.of(context).backgroundColor,
                elevation: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Image.asset(
                      'assets/logo/loading.gif',
                      fit: BoxFit.cover,
                    ),
                    imageUrl: item,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ))
        .toList();
    Widget buildTile(String url, String title, String tag) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GalleryScreen(url, title, tag),
            ),
          );
        },
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Card(
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTile(
                footer: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: Hero(
                  tag: tag,
                  child: Image.asset(
                    'assets/logo/' + url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: Theme.of(context).backgroundColor,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              stretch: true,
              expandedHeight: MediaQuery.of(context).size.height * .37,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [StretchMode.zoomBackground],
                background: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      width: double.infinity,
                      child: Text(
                        "Recently Added!",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * .25,
                          child: isLoading
                              ? Container(
                                  child: Center(
                                    child: Text(
                                      "Loading...",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                )
                              : CarouselSlider(
                                  options: CarouselOptions(
                                    viewportFraction: 0.3,
                                    autoPlay: true,
                                    aspectRatio: 2,
                                    enlargeCenterPage: true,
                                  ),
                                  items: imageSliders,
                                ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: double.infinity,
                      child: Text(
                        "Categories",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
            ),
            SliverGrid.count(
              childAspectRatio: 1,
              crossAxisCount: 2,
              children: [
                buildTile('Ironman.jpeg', "Iron Man", 'ironman'),
                buildTile('Superman.jpg', "Superman", 'superman'),
                buildTile('BATMAN.jpg', "Batman", 'batman'),
                buildTile(
                    'CaptainAmerica.jpg', "Captain America", 'captainamerica'),
                buildTile('SpiderMan.jpeg', "Spider-Man", 'spiderman'),
                buildTile('flash.jpg', "Flash", 'flash'),
                buildTile('Deadpool.jpg', "Deadpool", 'deadpool'),
                buildTile('Joker.jpg', "Joker", 'joker'),
                buildTile('Venom.jpg', "Venom", 'venom'),
                buildTile('Thanos.jpg', "Thanos", 'thanos'),
                buildTile('BlackPanther.jpg', "Black Panther", 'blackpanther'),
                buildTile('Wanda.jpg', "Wanda", 'wanda'),
                buildTile(
                    'DoctorStrange.jpg', "Doctor Strange", 'doctorstrange'),
                buildTile('Thor.jpg', "Thor", 'thor'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
