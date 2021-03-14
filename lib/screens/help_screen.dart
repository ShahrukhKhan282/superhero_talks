import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  Widget _buildTile(String title, String subtitle, BuildContext context) {
    return Container(
        child: ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _sendMail() async {
      final Uri params = Uri(
        scheme: 'mailto',
        path: 'shaizykhan282@gmail.com',
      );

      var url = params.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Help",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                "Frequently Asked Questions.",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            _buildTile(
                "Q. App crashed while downloading/setting wallpaper?",
                "Please check app's storage access permission in settings.\nYou can also uninstall than re-install the app to fix the problem.",
                context),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            _buildTile(
                "Q. Wallpaper not showing on lockscreen?",
                "Some companies like MI/Redmi doesn't allow third party apps to change lockscreen wallpaper due to security reasons.\nQuick Fix: Download wallpaper first and then set wallpaper from your gallery app.",
                context),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            _buildTile(
                "Q. How to enable Dark Mode?",
                "This app follows your system's default mode.\nEnable dark mode in your display settings and this app will automatically change its theme to dark mode.",
                context),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            _buildTile(
                "Q. Why the wallpapers are loading for too long?",
                "Either your internet connection is slow or the server is not responsing at that time.\nPlease try after an hour.",
                context),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            _buildTile(
                "Q. What is the frequency of new wallpaper updates?",
                "There is no fix schedule for new wallpapers.\nI will try my best to update the wallpapers regularly.",
                context),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            _buildTile(
                "Q. How to remove wallpapers from favorites?",
                "Long Press/Hold any favorite wallpaper to remove it.\nYou can also remove particular favorite wallpaper from the floating action button.",
                context),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            _buildTile(
                "Q. How to crop wallpaper? | How to set non-scrolling wallpaper?",
                "The scrolling behaviour of the wallpaper is due to your phone's default launcher.\nTo resolve this issue first download the wallpaper and than set wallpaper from your phone's gallery app.",
                context),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            _buildTile(
                "Q. Any other queries?",
                "Contact app developer at contact@iamshahrukh.net\nSecondary email: shaizy.khanmintorian@gmail.com",
                context),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            Card(
              color: Theme.of(context).primaryColor,
              child: TextButton(
                onPressed: () => _sendMail(),
                child: Text(
                  "Report Bug",
                  style: TextStyle(color: Theme.of(context).backgroundColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
