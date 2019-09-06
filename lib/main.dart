import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/moor_database.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      // The single instance of AppDatabase
      builder: (_) => AppDatabase(),
      child: MaterialApp(
        title: 'Material App',
        home: HomePage(),
      ),
    );
  }
}