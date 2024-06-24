import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/json_model.dart';

class DatabaseHelper {
  int version = 2;
  String name = "Test.db";
  String Tablename = "Recipes";

  Future<Database> getDb() async {
    try {
      final defaultpath = await getDatabasesPath();
      final path = join(defaultpath, name);
      return openDatabase(
        path,
        version: version,
        onCreate: (db, version) async {
          await db.execute('''
CREATE TABLE $Tablename(
id INTEGER PRIMARY KEY,
name TEXT,
ingredients TEXT,
instructions TEXT,
preptimeminutes INTEGER,
cooktimeminutes INTEGER,
servings INTEGER
difficulty TEXT,
cuisine TEXT,
caloriesperserving INTEGER,
tags TEXT,
userid INTEGER,
image TEXT,
rating REAL,
reviewcount INTEGER,
mealtype TEXT

)

 ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < newVersion) {
            await db.execute("DROP TABLE IF EXISTS $Tablename");
            await db.execute('''
CREATE TABLE $Tablename(
  id INTEGER PRIMARY KEY,
  name TEXT,
  ingredients TEXT,
  instructions TEXT,
  preptimeminutes INTEGER,
  cooktimeminutes INTEGER,
  servings INTEGER,
  difficulty TEXT,
  cuisine TEXT,
  caloriesperserving INTEGER,
  tags TEXT,
  userid INTEGER,
  image TEXT,
  rating REAL,
  reviewcount INTEGER,
  mealtype TEXT
)
''');
          }
        },
      );
    } catch (e, s) {
      if (kDebugMode) {
        print("Error while creating table: $e");
      }
      if (kDebugMode) {
        print("Stacktrace of error: $s");
      }
      rethrow;
    }
  }

  Future<int> insertdata(Recipe recipe) async {
    try {
      final db = await getDb();
      final ingredients = jsonEncode(recipe.ingredients);
      final instructions = jsonEncode(recipe.instructions);
      final tags = jsonEncode(recipe.tags);
      final mealtypes = jsonEncode(recipe.mealType);
      return await db.insert(
          Tablename,
          {
            'id': recipe.id,
            'name': recipe.name,
            'ingredients': ingredients,
            'instructions': instructions,
            'preptimeminutes': recipe.prepTimeMinutes,
            'cooktimeminutes': recipe.cookTimeMinutes,
            'servings': recipe.servings,
            'difficulty': recipe.difficulty,
            'cuisine': recipe.cuisine,
            'caloriesperserving': recipe.caloriesPerServing,
            'tags': tags,
            'userid': recipe.userId,
            'image': recipe.image,
            'rating': recipe.rating,
            'reviewcount': recipe.reviewCount,
            'mealtype': mealtypes
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      if (kDebugMode) {
        print("error while inserting data: $e");
      }
      rethrow;
    }
  }

  Future<List<Recipe>?> getrecipe() async {
    try {
      final db = await getDb();
      final maps = await db.query(Tablename);
      List<Recipe> recipes = [];
      if (maps.isNotEmpty) {
        for (var map in maps) {
          final ingredientsjson = map['ingredients']?.toString();
          final instructionsjson = map['instructions']?.toString();
          final tagsjson = map['tags']?.toString();
          final mealtypejson = map['mealtype']?.toString();
          final ingredients = ingredientsjson != null
              ? List<String>.from(jsonDecode(ingredientsjson) as List<dynamic>)
              : [];
          final instructions = instructionsjson != null
              ? List<String>.from(jsonDecode(instructionsjson) as List<dynamic>)
              : [];
          final tags = tagsjson != null
              ? List<String>.from(jsonDecode(tagsjson) as List<dynamic>)
              : [];
          final mealType = mealtypejson != null
              ? List<String>.from(jsonDecode(mealtypejson) as List<dynamic>)
              : [];

          recipes.add(Recipe(
            id: map['id'] as int,
            name: map['name'].toString(),
            ingredients: ingredients as List<String>,
            instructions: instructions as List<String>,
            tags: tags as List<String>,
            mealType: mealType as List<String>,
            prepTimeMinutes: map['preptimeminutes'] as int,
            cookTimeMinutes: map['cooktimeminutes'] as int,
            servings: map['servings'] as int,
            difficulty: map['difficulty'].toString(),
            cuisine: map['cuisine'].toString(),
            caloriesPerServing: map['caloriesperserving'] as int,
            userId: map['userid'] as int,
            image: map['image'].toString(),
            rating: map['rating'] as double,
            reviewCount: map['reviewcount'] as int,
          ));
        }
      }
      return recipes;
    } catch (e, s) {
      if (kDebugMode) {
        print("error while getting data from db: $e");
      }
      if (kDebugMode) {
        print('error stack: $s');
      }
    }
  }

  Future<void> deletedata() async {
    try {
      final db = await getDb();
      print("Database deleted");
      return await db.execute("DROP TABLE IF EXISTS $Tablename");
    } catch (e) {
      print("error deleting data: $e");
      rethrow;
    }
  }
}
