import 'package:flutter/material.dart';

import '../../models/json_model.dart';

class Openrecipe extends StatelessWidget {
  const Openrecipe({super.key, required this.data});
  final Recipe data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(data.name.toString()),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              Text("Ingredients"),
              Container(
                height: 300,
                child: ListView.builder(
                    itemCount: data.ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredients = data.ingredients[index];
                      return ListTile(
                        title: Text(ingredients.toString()),
                      );
                    }),
              ),
              Text("Instructions"),
              Container(
                height: 400,
                child: ListView.builder(
                    itemCount: data.instructions.length,
                    itemBuilder: (context, index) {
                      final instructions = data.instructions[index];
                      return ListTile(
                        title: Text(instructions.toString()),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
