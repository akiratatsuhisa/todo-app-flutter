import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(const HomeInitial()) {
    on<HomePageSet>(_onHomePageSet);
    on<HomePageIncreased>(_onHomePageIncreased);
    on<HomePageDecreased>(_onHomePageDecreased);
    on<HomeWelcomeReadingChecked>(_onHomeWelcomeReadingChecked);
    on<HomeWelcomeReadingCompleted>(_onHomeWelcomeReadingCompleted);
  }

  void _onHomePageSet(
    HomePageSet event,
    Emitter<HomeState> emit,
  ) {
    final currentState = state;
    if (currentState is! HomeInProgress) {
      return;
    }

    emit(HomeInProgress(currentIndex: event.index));
  }

  void _onHomePageIncreased(
    HomePageIncreased event,
    Emitter<HomeState> emit,
  ) {
    final currentState = state;
    if (currentState is! HomeInProgress) {
      return;
    }

    emit(HomeInProgress(currentIndex: currentState.currentIndex + 1));
  }

  void _onHomePageDecreased(
    HomePageDecreased event,
    Emitter<HomeState> emit,
  ) {
    final currentState = state;
    if (currentState is! HomeInProgress) {
      return;
    }

    emit(HomeInProgress(currentIndex: currentState.currentIndex - 1));
  }

  Future<void> _onHomeWelcomeReadingChecked(
    HomeWelcomeReadingChecked event,
    Emitter<HomeState> emit,
  ) async {
    // For development only
    await _homeRepository.setHasReadWelcome(false);

    final hasReadWelcome = _homeRepository.getHasReadWelcome();

    if (hasReadWelcome) {
      emit(const HomeDone());
    } else {
      emit(const HomeInProgress(currentIndex: 0));
    }
  }

  Future<void> _onHomeWelcomeReadingCompleted(
    HomeWelcomeReadingCompleted event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is! HomeInProgress) {
      return;
    }

    await _homeRepository.setHasReadWelcome(true);

    emit(const HomeDone());
  }
}
