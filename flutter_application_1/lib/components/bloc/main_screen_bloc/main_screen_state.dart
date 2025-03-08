part of 'main_screen_bloc.dart';

abstract class MainScreenState {}

abstract class MainScreenActionState extends MainScreenState {}

final class MainScreenInitial extends MainScreenState {}

class MainScreenBottomNavigationBarSwitchingState extends MainScreenActionState {
  final int index;

  MainScreenBottomNavigationBarSwitchingState(this.index);
}
