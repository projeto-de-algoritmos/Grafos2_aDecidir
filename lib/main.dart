import 'package:app_carona_fga/pages/destination_page.dart';
import 'package:flutter/material.dart';
import 'pages/map_page.dart';
import 'pages/rides_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // on below line we are specifying title of our app
      title: 'Carona',
      // on below line we are hiding debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // on below line we are specifying theme
        primarySwatch: Colors.green,
      ),
      // First screen of our app
      home: DestinationPage(),
    );
  }
}
