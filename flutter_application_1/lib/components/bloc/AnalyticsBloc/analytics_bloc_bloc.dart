import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'analytics_bloc_event.dart';
part 'analytics_bloc_state.dart';

class AnalyticsBlocBloc extends Bloc<AnalyticsBlocEvent, AnalyticsBlocState> {
  AnalyticsBlocBloc() : super(AnalyticsBlocInitial()) {
    on<AnalyticsLoadEvent>(analyticsLoadEvent);
  }

  Future<void> analyticsLoadEvent(
      AnalyticsLoadEvent event, Emitter<AnalyticsBlocState> emit) async {
    emit(AnalyticsLoadingState());

    // Generate random expense data
    List<int> xList = List.generate(12, (index) => index);
    List<int> yList = List.generate(12, (index) => Random().nextInt(5000) + 1000);

    emit(AnalyticsLoadedState(xList, yList, "Months", "Expense (₹)"));
  }
}