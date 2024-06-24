import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_sqflite_and_bloc/api/base_state.dart';
import 'package:learning_sqflite_and_bloc/api/bloc/fetch_bloc.dart';
import 'package:learning_sqflite_and_bloc/database/database_helper.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../models/json_model.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Homepagestate();
}

class _Homepagestate extends State<Homepage> {
  final FetchBloc _bloc = FetchBloc(initialstate: Loading());
  List<Recipe>? response = [];
  int limit = 10;
  int skip = 0;
  int pagesize = 9;
  bool islastpage = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        skip += 10;

        setState(() {});
        getData();
      }
    });
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DatabaseHelper().deletedata();
        },
        child: Icon(Icons.minimize),
      ),
      body: BlocProvider(
        create: (_) => _bloc,
        child: BlocListener<FetchBloc, BaseState>(
          listener: (context, state) {
            if (state is Loading) {
              print("Loading");
              return;
            }
            if (state is Dataloaded) {
              if (state.event == "GetData") {
                if (state.data != null) {
                  List<Recipe>? data = state.data;
                  if (data!.length < pagesize) {
                    islastpage = true;
                    print("islastpage: $islastpage");
                  }
                  response?.addAll(data);
                  print("reponse length: ${response!.length}");
                } else {
                  return;
                }
              }
            }
            if (state is BaseError) {
              return;
            }
          },
          child: BlocBuilder<FetchBloc, BaseState>(
            builder: (context, state) {
              return uiWidget();
            },
          ),
        ),
      ),
    );
  }

  uiWidget() {
    return Skeletonizer(
        enabled: false,
        child: ListView.builder(
            controller: _scrollController,
            itemCount: response!.isNotEmpty
                ? islastpage
                    ? response?.length
                    : response!.length + 1
                : 0,
            itemBuilder: (context, index) {
              if (response!.isNotEmpty) {
                if (index == response?.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var data = response?[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/recipe",
                        arguments: data),
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                              height: 100,
                              width: 75,
                              child: Image.network(data!.image.toString())),
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(data.name.toString()),
                                  Text(
                                      "Prep Time:${data.prepTimeMinutes.toString()}"),
                                  Text("Cook Time: ${data.cookTimeMinutes}"),
                                  Text("Servings: ${data.servings}")
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Cuisine: ${data.cuisine}"),
                                  Text("Difficulty: ${data.difficulty}"),
                                  Text(
                                      "Calories per serving: ${data.caloriesPerServing}"),
                                  Text("Ratings: ${data.rating}")
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
              }
              return null;
            }));
  }

  void getData() {
    if (!islastpage) {
      _bloc.add(fetchRecipes(limit: limit, skip: skip));
    }
  }
}
