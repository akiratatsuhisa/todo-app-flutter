part of 'home_bloc.dart';

sealed class HomeState {}

@freezed
class HomeInitial extends HomeState with _$HomeInitial {
  const factory HomeInitial() = _HomeInitial;
}

@freezed
class HomeInProgress extends HomeState with _$HomeInProgress {
  const factory HomeInProgress({required int currentIndex}) = _HomeInProgress;
}

@freezed
class HomeDone extends HomeState with _$HomeDone {
  const factory HomeDone() = _HomeDone;
}
