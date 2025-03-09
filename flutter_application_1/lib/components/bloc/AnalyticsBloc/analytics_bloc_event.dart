part of 'analytics_bloc_bloc.dart';

@immutable
abstract class AnalyticsBlocEvent {}

class AnalyticsLoadEvent extends AnalyticsBlocEvent {}

class AnalyticsMonthSelectedEvent extends AnalyticsBlocEvent {
  final int monthIndex;

  AnalyticsMonthSelectedEvent(this.monthIndex);
}

class SendAnalyticsQueryEvent extends AnalyticsBlocEvent {
  final String query;

  SendAnalyticsQueryEvent(this.query);
}

class SelectAnalyticsChipEvent extends AnalyticsBlocEvent {
  final String chipName;

  SelectAnalyticsChipEvent(this.chipName);
}
