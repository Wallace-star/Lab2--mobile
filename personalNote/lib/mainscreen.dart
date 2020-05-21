import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.email}) : super(key: key);
  final String email;

  @override
   _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  _MainScreenState({Key key, this.email}) : super();
  final String email;
  List productdata;
  double screenHeight, screenWidth;
 
  @override
  Widget build(BuildContext context) {
if (productdata == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Products List'),
          ),
          body: Container(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading Products",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )));
  }
}
}