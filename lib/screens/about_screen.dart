import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "About",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .3,
                child: Card(
                  color: Theme.of(context).backgroundColor,
                  elevation: 15,
                  shape: CircleBorder(),
                  child: Image.asset("assets/logo/superherotalks.png"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                color: Theme.of(context).backgroundColor,
                child: Text(
                  "SuperHero Talks\nWallpaper App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "SuperHero Talks is a YouTube channel which provides all the comic book and superheroes related stuff.\nThis app is created for all the supporting subscribers of SuperHero Talks to provide them high quality superhero wallpapers.",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Image.asset(
                          "assets/logo/youtube.png",
                          width: 60,
                        ),
                        onPressed: () =>
                            launch("https://www.youtube.com/superherotalks")),
                    IconButton(
                      icon: Image.asset("assets/logo/facebook.png"),
                      onPressed: () =>
                          launch("https://www.facebook.com/myselfshaizy/"),
                    ),
                    IconButton(
                      icon: Image.asset("assets/logo/insta.png"),
                      onPressed: () =>
                          launch("https://www.instagram.com/shaizy._stark/"),
                    ),
                    IconButton(
                      icon: Image.asset("assets/logo/linkedin.png"),
                      onPressed: () => launch(
                          "https://www.linkedin.com/in/shahrukh-khan-a527b38a/"),
                    ),
                    IconButton(
                      icon: Image.asset("assets/logo/web.png"),
                      onPressed: () => launch("https://iamshahrukh.net/"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              Container(
                child: Text(
                  "Developer: Shahrukh Khan",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 17),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
