part of 'todo_save_bloc.dart';

sealed class TodoSaveState {}

@freezed
class TodoSaveInitial extends TodoSaveState with _$TodoSaveInitial {
  const factory TodoSaveInitial() = _TodoSaveInitial;
}

@freezed
class TodoSaveLoading extends TodoSaveState with _$TodoSaveLoading {
  const factory TodoSaveLoading() = _TodoSaveLoading;
}

@freezed
class TodoSaveInProgress extends TodoSaveState with _$TodoSaveInProgress {
  const factory TodoSaveInProgress({
    @Default(TodoText.pure()) TodoText text,
    @Default(TodoDescription.pure()) TodoDescription description,
  }) = _TodoSaveInProgress;
}

@freezed
class TodoSaveSuccess extends TodoSaveState with _$TodoSaveSuccess {
  const factory TodoSaveSuccess({required Todo todo}) = _TodoSaveSuccess;
}

@freezed
class TodoSaveFailure extends TodoSaveState
    with _$TodoSaveFailure
    implements FailureState {
  const factory TodoSaveFailure({
    required String title,
    required String message,
  }) = _TodoSaveFailure;
}
