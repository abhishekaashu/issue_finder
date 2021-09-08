import 'package:flutter/material.dart';
import './search_page_screen.dart';
import './client.dart';

class IssueFinderApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: SearchPage(title: 'Issues',dio: dio),
    );
  }
}

