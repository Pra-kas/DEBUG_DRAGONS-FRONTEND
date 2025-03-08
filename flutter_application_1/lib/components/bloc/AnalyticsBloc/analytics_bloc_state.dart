part of 'analytics_bloc_bloc.dart';

@immutable
sealed class AnalyticsBlocState {}

final class AnalyticsBlocInitial extends AnalyticsBlocState {}

class AnalyticsLoadingState extends AnalyticsBlocState {}

class AnalyticsLoadedState extends AnalyticsBlocState {
  List<int>xList;
  List<int>yList;
  String xTitle;
  String yTitle;
  AnalyticsLoadedState(this.xList, this.yList, this.xTitle, this.yTitle);
}

class AnalyticsLoadFailedState extends AnalyticsBlocState {}
