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
}