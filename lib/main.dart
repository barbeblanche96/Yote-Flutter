import 'package:flutter/material.dart';
import 'package:yote_maic/screens/board_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    const MaterialColor custom = const MaterialColor(
      0xFFfcebcd,
      const <int, Color>{
        50: const Color(0xFFfcebcd),
        100: const Color(0xFFfcebcd),
        200: const Color(0xFFfcebcd),
        300: const Color(0xFFfcebcd),
        400: const Color(0xFFfcebcd),
        500: const Color(0xFFfcebcd),
        600: const Color(0xFFfcebcd),
        700: const Color(0xFFfcebcd),
        800: const Color(0xFFfcebcd),
        900: const Color(0xFFfcebcd),
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yoté',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: custom,
      ),
      home: BoardScreen(),
    );
  }
}