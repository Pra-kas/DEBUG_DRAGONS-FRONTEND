import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/service/helper/global_service.dart';
import 'package:meta/meta.dart';

part 'analytics_bloc_event.dart';
part 'analytics_bloc_state.dart';

class AnalyticsBlocBloc extends Bloc<AnalyticsBlocEvent, AnalyticsBlocState> {
  AnalyticsBlocBloc() : super(AnalyticsBlocInitial()) {
    on<AnalyticsLoadEvent>(analyticsLoadEvent);
    on<AnalyticsMonthSelectedEvent>(analyticsMonthSelectedEvent);
    on<SendAnalyticsQueryEvent>(_handleQueryEvent);
    on<SelectAnalyticsChipEvent>(_handleChipEvent);
  }

  Future<void> analyticsLoadEvent(
      AnalyticsLoadEvent event, Emitter<AnalyticsBlocState> emit) async {
    emit(AnalyticsLoadingState());
    Map<String,dynamic> response = await GlobalService.globalService(endpoint: "getPrevYear", method: "GET");
    if (response["status"] == false) {
      return ;
    }
    Map<String,dynamic> data = Map<String,dynamic>.from(response["message"]);
    // Generate random expense data for months
    List<int> xList = List<int>.from(data['xList']);
    List<int> yList = List<int>.from(data['yList']);
    String xTitle = data['xTitle'];
    String yTitle = data['yTitle'];

    // Parse weekly data
    Map<int, List<int>> weeklyExpense = {};
    Map<int, List<int>> weeklyIncome = {};
    Map<int, List<int>> weeklyData = {}; // For chart

    Map<String, dynamic> weeklyDataMap = data['weeklyData'];
    weeklyDataMap.forEach((month, monthData) {
      int monthIndex = int.parse(month);
      weeklyExpense[monthIndex] = List<int>.from(monthData['expense']);
      weeklyIncome[monthIndex] = List<int>.from(monthData['income']);
      weeklyData[monthIndex] = List<int>.from(monthData['expense']);
    });

    emit(AnalyticsLoadedState(
        xList: xList,
        yList: yList,
        xTitle: xTitle,
        yTitle: yTitle,
        weeklyData: weeklyData,
        weeklyExpense: weeklyExpense,
        weeklyIncome: weeklyIncome,
        selectedMonth: data['selectedMonth'] ?? -1
    ));
  }

  Future<void> analyticsMonthSelectedEvent(
      AnalyticsMonthSelectedEvent event, Emitter<AnalyticsBlocState> emit) async {
    if (state is AnalyticsLoadedState) {
      final currentState = state as AnalyticsLoadedState;

      emit(AnalyticsLoadedState(
          xList: currentState.xList,
          yList: currentState.yList,
          xTitle: currentState.xTitle,
          yTitle: currentState.yTitle,
          weeklyData: currentState.weeklyData,
          weeklyExpense: currentState.weeklyExpense,
          weeklyIncome: currentState.weeklyIncome,
          selectedMonth: event.monthIndex
      ));
    }
  }

  Future<void> _handleQueryEvent(
      SendAnalyticsQueryEvent event,
      Emitter<AnalyticsBlocState> emit
      ) async {
    emit(AnalyticsChatBotLoadingState());

    try {
      // Simulate API call

      // This would be replaced with actual analytics data fetching
      Map<String,dynamic> requestBody = {
        "botQuery": event.query
      };
      Map<String,dynamic> response = await GlobalService.globalService(endpoint: "botQuery", method: "POST", requestBody: requestBody);
      print("response form gemini : ${response["answer"]}");
      String message = (response["answer"] ?? _generateResponse(event.query));
      if (response["isGraph"] == true && false) {
        List<double> xList = List<double>.from(response["xList"]);
        List<double> yList = List<double>.from(response["yList"]);
        String xTitle = response["xTitle"];
        String yTitle = response["yTitle"];
        emit(AnalyticsGraphShowingState(xList: xList, yList: yList, xTitle: xTitle, yTitle: yTitle));
      }
      else {
        emit(AnalyticsChatBotLoadedState(message: message));
      }
    } catch (e) {
      emit(AnalyticsErrorState(error: e.toString()));
    }
  }

  Future<void> _handleChipEvent(
      SelectAnalyticsChipEvent event,
      Emitter<AnalyticsBlocState> emit
      ) async {
    emit(AnalyticsChipSelectedState(selectedChip: event.chipName));
  }

  String _generateResponse(String query) {
    if (query.toLowerCase().contains('revenue')) {
      return 'Based on current analytics, your revenue has increased by 15% compared to last month. The top performing channel is organic search with 43% contribution.';
    } else if (query.toLowerCase().contains('users') || query.toLowerCase().contains('visitors')) {
      return 'You had 24,582 unique visitors this month, which is up 8.3% from last month. Average session duration is 3:24 minutes.';
    } else if (query.toLowerCase().contains('conversion')) {
      return 'Your overall conversion rate is 3.2%, which is about industry average. Your best converting page is the Summer Sale landing page at 7.8%.';
    } else if (query.toLowerCase().contains('trend') || query.toLowerCase().contains('growth')) {
      return 'I\'ve analyzed your growth trend. You\'re seeing consistent week-over-week growth of 2.1% in traffic and 1.7% in conversions over the past 3 months.';
    } else {
      return 'I\'ve analyzed your analytics data. Overall performance looks positive with a 12% improvement in key metrics compared to the previous period. Would you like details on a specific metric?';
    }
  }
}