part of 'analytics_bloc_bloc.dart';

@immutable
abstract class AnalyticsBlocState {}

class AnalyticsBlocInitial extends AnalyticsBlocState {}

class AnalyticsLoadingState extends AnalyticsBlocState {}

class AnalyticsLoadedState extends AnalyticsBlocState {
  final List<int> xList;
  final List<int> yList;
  final String xTitle;
  final String yTitle;
  final Map<int, List<int>> weeklyData;
  final Map<int, List<int>> weeklyExpense;
  final Map<int, List<int>> weeklyIncome;
  final int selectedMonth;

  AnalyticsLoadedState({
    required this.xList,
    required this.yList,
    required this.xTitle,
    required this.yTitle,
    required this.weeklyData,
    required this.weeklyExpense,
    required this.weeklyIncome,
    required this.selectedMonth
  });
}

class AnalyticsInitialState extends AnalyticsBlocState {}

class AnalyticsChatBotLoadingState extends AnalyticsBlocState {}

class AnalyticsChatBotLoadedState extends AnalyticsBlocState {
  final String message;
  final dynamic data;

  AnalyticsChatBotLoadedState({required this.message, this.data});
}

class AnalyticsErrorState extends AnalyticsBlocState {
  final String error;

  AnalyticsErrorState({required this.error});
}

class AnalyticsChipSelectedState extends AnalyticsBlocState {
  final String selectedChip;

  AnalyticsChipSelectedState({required this.selectedChip});
}

class AnalyticsGraphShowingState extends AnalyticsBlocState {
  final List<double> xList;
  final List<double> yList;
  final String xTitle;
  final String yTitle;
  AnalyticsGraphShowingState(
      {required this.xList,
      required this.yList,
      required this.xTitle,
      required this.yTitle});
}
