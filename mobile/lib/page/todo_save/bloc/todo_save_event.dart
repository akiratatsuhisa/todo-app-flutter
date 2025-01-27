part of 'todo_save_bloc.dart';

sealed class TodoSaveEvent {}

@freezed
class TodoSaveInitialized extends TodoSaveEvent with _$TodoSaveInitialized {
  const factory TodoSaveInitialized({String? id}) = _TodoSaveInitialized;
}

@freezed
class TodoSaveSubmitted extends TodoSaveEvent with _$TodoSaveSubmitted {
  const factory TodoSaveSubmitted({
    String? id,
    required String text,
    String? description,
  }) = _TodoSaveSubmitted;
}
