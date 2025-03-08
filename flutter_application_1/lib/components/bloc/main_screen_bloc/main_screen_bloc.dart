import 'dart:async';

import 'package:bloc/bloc.dart';

part 'main_screen_event.dart';
part 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(MainScreenInitial()) {
    on<MainScreenBottomNavigationBarSwitchingEvent> (mainScreenBottomNavigationBarSwitching);
  }

  FutureOr<void> mainScreenBottomNavigationBarSwitching(MainScreenBottomNavigationBarSwitchingEvent event, Emitter<MainScreenState> emit) {
    emit(MainScreenBottomNavigationBarSwitchingState(event.index));
  }
}
