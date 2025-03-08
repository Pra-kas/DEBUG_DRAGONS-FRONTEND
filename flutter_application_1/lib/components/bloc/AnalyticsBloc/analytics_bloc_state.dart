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
