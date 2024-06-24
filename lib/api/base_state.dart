import 'package:equatable/equatable.dart';

class BaseState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class Loading extends BaseState {
  @override
  String toString() => "Loading";
  @override
  List<Object?> get props => [];
}

class Dataloaded<Data> extends BaseState {
  Dataloaded({required this.event, required this.data});
  final String? event;
  final Data? data;

  @override
  String toString() => "Data Loaded";
  @override
  List<Object?> get props => [event, data];
}

class BaseError extends BaseState {
  BaseError({required this.errormsg});
  final String? errormsg;
  @override
  String toString() => "Error";
  @override
  // TODO: implement props
  List<Object?> get props => [errormsg];
}
