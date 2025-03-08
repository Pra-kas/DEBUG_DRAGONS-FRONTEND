part of 'main_screen_bloc.dart';

abstract class MainScreenEvent {}

class MainScreenBottomNavigationBarSwitchingEvent extends  MainScreenEvent {
  final int index;

  MainScreenBottomNavigationBarSwitchingEvent(this.index);
}
