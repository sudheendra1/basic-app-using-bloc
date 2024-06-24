part of 'fetch_bloc.dart';

@immutable
sealed class FetchEvent {}

class fetchRecipes extends FetchEvent {
  fetchRecipes({required this.limit, required this.skip});
  final limit;
  final skip;
}
