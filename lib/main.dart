import 'package:flutter/material.dart';
import 'package:learning_sqflite_and_bloc/api/UI/HomePage.dart';
import 'package:learning_sqflite_and_bloc/api/UI/openRecipe.dart';

import 'models/json_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        "/": (context) => Homepage(),
        "/recipe": (context) => Openrecipe(
              data: ModalRoute.of(context)!.settings.arguments as Recipe,
            )
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
