part of 'home_bloc.dart';

sealed class HomeEvent {}

@freezed
class HomePageSet extends HomeEvent with _$HomePageSet {
  const factory HomePageSet({required int index}) = _HomePageSet;
}

@freezed
class HomePageIncreased extends HomeEvent with _$HomePageIncreased {
  const factory HomePageIncreased() = _HomePageIncreased;
}

@freezed
class HomePageDecreased extends HomeEvent with _$HomePageDecreased {
  const factory HomePageDecreased() = _HomePageDecreased;
}

@freezed
class HomeWelcomeReadingChecked extends HomeEvent
    with _$HomeWelcomeReadingChecked {
  const factory HomeWelcomeReadingChecked() = _HomeWelcomeReadingChecked;
}

@freezed
class HomeWelcomeReadingCompleted extends HomeEvent
    with _$HomeWelcomeReadingCompleted {
  const factory HomeWelcomeReadingCompleted() = _HomeWelcomeReadingCompleted;
}
