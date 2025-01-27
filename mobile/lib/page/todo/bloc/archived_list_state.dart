part of 'archived_list_bloc.dart';

sealed class ArchivedListState {}

@freezed
class ArchivedListInitial extends ArchivedListState with _$ArchivedListInitial {
  const factory ArchivedListInitial() = _ArchivedListInitial;
}

@freezed
class ArchivedListLoading extends ArchivedListState with _$ArchivedListLoading {
  const factory ArchivedListLoading() = _ArchivedListLoading;
}

@freezed
class ArchivedListSuccess extends ArchivedListState with _$ArchivedListSuccess {
  const factory ArchivedListSuccess({required List<TodoDto> items}) =
      _ArchivedListSuccess;
}

@freezed
class ArchivedListFailure extends ArchivedListState
    with _$ArchivedListFailure
    implements FailureState {
  const factory ArchivedListFailure({
    required String title,
    required String message,
  }) = _ArchivedListFailure;
}
