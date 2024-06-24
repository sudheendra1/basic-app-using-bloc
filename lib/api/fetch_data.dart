import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:learning_sqflite_and_bloc/models/json_model.dart';

class FetchData {
  Future<List<Recipe>?> getRecipes(int limit, int skip) async {
    try {
      final dio = Dio();
      const url = "https://dummyjson.com/recipes";
      var body = {"limit": limit, "skip": skip};
      final response = await dio.get(url, queryParameters: body);
      if (response.statusCode == 200) {
        final responsedata = response.data;
        Products products = Products.fromJson(responsedata);
        print(products);
        return products.recipes;
      }
    } catch (e, s) {
      if (kDebugMode) {
        print("error while fetching data: $e");
      }
      if (kDebugMode) {
        print("stack trace while fetching data: $s");
      }
    }
    return null;
  }
}
