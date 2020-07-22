import 'package:flutter/material.dart';
import 'package:locationreminder/modules/add_location/models/add_new_location.dart';
import 'package:locationreminder/modules/dashboard/index.dart';
import 'package:locationreminder/modules/home/index.dart';
import 'package:locationreminder/modules/info/index.dart';
import 'package:locationreminder/modules/add_location/index.dart';
import 'package:locationreminder/services/loader/config_loader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConfigLoader loader=ConfigLoader();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Reminder',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        buttonColor: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "/":(context)=>HomePage(title: "Location Reminder"),
        "/dashboard":(context)=>DashboardPage(),
        "/add":(context)=>AddANewLocationPage(),
        "/info":(context)=>InfoPage()
        //TODO-Start from here
      },
      initialRoute: '/',
    );
  }
}