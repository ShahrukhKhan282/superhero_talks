import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'screens/tabs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appdirectory = await path.getApplicationDocumentsDirectory();
  Hive.init(appdirectory.path);
  await Hive.openBox("urlBoxx");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        backgroundColor: Colors.grey[900],
        primaryColor: Colors.white,
      ),
      title: 'SuperHero Talks',
      theme: ThemeData(
        backgroundColor: Colors.white,
        primaryColor: Colors.black,
        primarySwatch: Colors.red,
      ),
      home: TabScreen(),
    );
  }
}
