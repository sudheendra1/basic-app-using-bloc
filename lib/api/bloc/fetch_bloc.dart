import 'package:bloc/bloc.dart';
import 'package:learning_sqflite_and_bloc/api/base_state.dart';
import 'package:learning_sqflite_and_bloc/api/bloc/repository.dart';
import 'package:meta/meta.dart';

part 'fetch_event.dart';

class FetchBloc extends Bloc<FetchEvent, BaseState> {
  FetchBloc({required BaseState initialstate}) : super(initialstate) {
    on<fetchRecipes>(_fetchRecipes);
  }

  void _fetchRecipes(fetchRecipes event, Emitter<BaseState> emit) async {
    emit(Loading());
    try {
      // await Repository().getandstoredata(event.limit, event.skip);
      // var response = await Repository().retrieveData();
      var response = await Repository().getData(event.limit, event.skip);
      if (response != null && response.isNotEmpty) {
        emit(Dataloaded(event: "GetData", data: response));
      } else {
        emit(Dataloaded(event: "GetData", data: null));
      }
    } catch (e) {
      emit(BaseError(errormsg: e.toString()));
    }
  }
}
