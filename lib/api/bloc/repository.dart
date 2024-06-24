import 'package:flutter/foundation.dart';
import 'package:learning_sqflite_and_bloc/api/fetch_data.dart';
import 'package:learning_sqflite_and_bloc/models/json_model.dart';

import '../../database/database_helper.dart';

class Repository {
  Future<List<Recipe>?> getData(int limit, int skip) async {
    List<Recipe>? response = [];
    response = await FetchData().getRecipes(limit, skip);
    return response;
  }

  Future<String> getandstoredata(int limit, int skip) async {
    List<Recipe>? response = [];
    response = await FetchData().getRecipes(limit, skip);
    DatabaseHelper _databsehelper = DatabaseHelper();
    if (response != null) {
      for (var item in response) {
        _databsehelper.insertdata(item);
      }
      var x = "data retrieved and stored successfully";
      if (kDebugMode) {
        print(x);
      }
      return x;
    } else {
      var y = "failed to load and store data";
      if (kDebugMode) {
        print(y);
      }
      return y;
    }
  }

  Future<List<Recipe>?> retrieveData() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    List<Recipe>? response = await databaseHelper.getrecipe();
    return response;
  }
}
