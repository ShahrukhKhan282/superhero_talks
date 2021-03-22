import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'gallery_screen.dart';
import 'package:http/http.dart' as http;

class CategoriesGrid extends StatefulWidget {
  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    getDates();
  }

  Future<void> checkForUpdate() async {
    NewVersion(
      context: context,
      androidId: 'net.iamshahrukh.superhero_talks',
    ).showAlertIfNecessary();
  }

  final List<dynamic> imgList = [
    "1.jpg",
    "2.jpg",
    "3.jpg",
  ];

  Map<String, dynamic> dateList = {};
  Future<void> getDates() async {
    await http.get("https://iamshahrukh.net/wallpapers/test.php").then(
      (value) {
        dateList = jsonDecode(value.body) as Map<String, dynamic>;

        setState(() {
          isLoading = false;
        });
      },
    );
  }

  double childAspectRatio = 1;
  int crossAxisCount = 2;
  void _changeGrid() {
    if (childAspectRatio == 1) {
      setState(() {
        childAspectRatio = 2;
        crossAxisCount = 1;
      });
    } else {
      setState(() {
        childAspectRatio = 1;
        crossAxisCount = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map(
          (item) => Image.asset("assets/logo/" + item),
        )
        .toList();
    Widget buildTile(String title, String tag, String date) {
      final dateAgo = isLoading
          ? 0
          : DateTime.now().difference(DateTime.parse(date)).inDays;

      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GalleryScreen(title, tag),
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
                header: Center(
                  child: Text(
                    isLoading
                        ? ""
                        : dateAgo == 0
                            ? "Updated Today!"
                            : "Updated $dateAgo Days Ago",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                footer: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                child: Hero(
                  tag: tag,
                  child: Image.asset(
                    'assets/logo/' + tag + ".jpg",
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
              leading: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Image.asset("assets/logo/superherotalks.png"),
              ),
              title: Text(
                "SuperHero Talks",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              stretch: true,
              expandedHeight: MediaQuery.of(context).size.height * .35,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [StretchMode.zoomBackground],
                background: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 50),
                          height: double.infinity,
                          width: double.infinity,
                          child: CarouselSlider(
                            options: CarouselOptions(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Categories",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          IconButton(
                              iconSize: 35,
                              icon: crossAxisCount == 2
                                  ? Icon(Icons.list)
                                  : Icon(Icons.grid_view),
                              onPressed: _changeGrid)
                        ],
                      ),
                    ),
                  ],
                )),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
            ),
            SliverGrid.count(
              childAspectRatio: childAspectRatio,
              crossAxisCount: crossAxisCount,
              children: [
                buildTile("Iron Man", 'ironman',
                    isLoading ? "" : dateList["ironman"]),
                buildTile("Superman", 'superman',
                    isLoading ? "" : dateList['superman']),
                buildTile(
                    "Batman", 'batman', isLoading ? "" : dateList['batman']),
                buildTile("Captain America", 'captainamerica',
                    isLoading ? "" : dateList['captainamerica']),
                buildTile("Spider-Man", 'spiderman',
                    isLoading ? "" : dateList['spiderman']),
                buildTile("Flash", 'flash', isLoading ? "" : dateList['flash']),
                buildTile("Wolverine", 'wolverine',
                    isLoading ? "" : dateList['wolverine']),
                buildTile("Hulk", 'hulk', isLoading ? "" : dateList['hulk']),
                buildTile("Deadpool", 'deadpool',
                    isLoading ? "" : dateList['deadpool']),
                buildTile("Joker", 'joker', isLoading ? "" : dateList['joker']),
                buildTile("Venom", 'venom', isLoading ? "" : dateList['venom']),
                buildTile(
                    "Thanos", 'thanos', isLoading ? "" : dateList['thanos']),
                buildTile("Black Panther", 'blackpanther',
                    isLoading ? "" : dateList['blackpanther']),
                buildTile("Wanda", 'wanda', isLoading ? "" : dateList['wanda']),
                buildTile("Thor", 'thor', isLoading ? "" : dateList['thor']),
                buildTile("Doctor Strange", 'doctorstrange',
                    isLoading ? "" : dateList['doctorstrange']),
                buildTile(
                    "Vision", 'vision', isLoading ? "" : dateList['vision']),
                buildTile("Winter Soldier", 'wintersoldier',
                    isLoading ? "" : dateList['wintersoldier']),
                buildTile("Avengers", 'avengers',
                    isLoading ? "" : dateList['avengers']),
                buildTile("Ghost Rider", 'ghostrider',
                    isLoading ? "" : dateList['ghostrider']),
                buildTile("Wonder Woman", 'wonderwoman',
                    isLoading ? "" : dateList['wonderwoman']),
                buildTile(
                    "Aquaman", 'aquaman', isLoading ? "" : dateList['aquaman']),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
