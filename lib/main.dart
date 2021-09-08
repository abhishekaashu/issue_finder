import 'dart:convert';
import 'dart:ffi';



import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import './src/issue_finder_app.dart';
import './src/app_state.dart';
import 'package:provider/provider.dart';
import './src/api.dart';


void main() {
  //await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => GithubApi()),
        Provider(create: (context) => AppState()),
      ],
      
      child: IssueFinderApp(),
      ),
   );
}



