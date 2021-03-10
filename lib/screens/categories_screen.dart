import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'gallery_screen.dart';
import 'package:http/http.dart' as http;

class CategoriesGrid extends StatefulWidget {
  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  bool isLoading;
  @override
  void initState() {
    isLoading = true;
    getDates();
    super.initState();
  }

  final List<dynamic> imgList = [
    "1.jpg",
    "2.jpeg",
    "3.jpg",
  ];

  List<dynamic> dateList = [];
  Future<void> getDates() async {
    await http.get("https://iamshahrukh.net/wallpapers/fetchdates.php").then(
      (value) {
        dateList = jsonDecode(value.body) as List<dynamic>;
        setState(() {
          isLoading = false;
        });
      },
    );
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
                buildTile("Iron Man", 'ironman', isLoading ? "" : dateList[2]),
                buildTile("Superman", 'superman', isLoading ? "" : dateList[7]),
                buildTile("Batman", 'batman', isLoading ? "" : dateList[11]),
                buildTile("Captain America", 'captainamerica',
                    isLoading ? "" : dateList[19]),
                buildTile(
                    "Spider-Man", 'spiderman', isLoading ? "" : dateList[9]),
                buildTile("Flash", 'flash', isLoading ? "" : dateList[12]),
                buildTile("Deadpool", 'deadpool', isLoading ? "" : dateList[4]),
                buildTile("Joker", 'joker', isLoading ? "" : dateList[5]),
                buildTile("Venom", 'venom', isLoading ? "" : dateList[6]),
                buildTile("Thanos", 'thanos', isLoading ? "" : dateList[16]),
                buildTile("Black Panther", 'blackpanther',
                    isLoading ? "" : dateList[14]),
                buildTile("Wanda", 'wanda', isLoading ? "" : dateList[3]),
                buildTile(
                    "Wolverine", 'wolverine', isLoading ? "" : dateList[10]),
                buildTile("Hulk", 'hulk', isLoading ? "" : dateList[0]),
                buildTile("Thor", 'thor', isLoading ? "" : dateList[8]),
                buildTile("Doctor Strange", 'doctorstrange',
                    isLoading ? "" : dateList[1]),
                buildTile("Vision", 'vision', isLoading ? "" : dateList[17]),
                buildTile("Winter Soldier", 'wintersoldier',
                    isLoading ? "" : dateList[13]),
                buildTile(
                    "Avengers", 'avengers', isLoading ? "" : dateList[15]),
                buildTile(
                    "Ghost Rider", 'ghostrider', isLoading ? "" : dateList[20]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
