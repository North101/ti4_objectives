import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ti4_objectives/database.dart';
import 'package:ti4_objectives/screens/game_list_page.dart';

const OBJECTIVE_IMAGE_HEIGHT = 752 * 0.34;
const OBJECTIVE_IMAGE_WIDTH = 499 * 0.34;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AppDb>(
      create: (BuildContext context) => AppDb(),
      dispose: (BuildContext context, AppDb value) {
        value.close();
      },
      child: MaterialApp(
        title: 'Twilight Imperium 4',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GameListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
