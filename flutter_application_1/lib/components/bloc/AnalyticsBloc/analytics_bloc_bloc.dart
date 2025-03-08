import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'analytics_bloc_event.dart';
part 'analytics_bloc_state.dart';

class AnalyticsBlocBloc extends Bloc<AnalyticsBlocEvent, AnalyticsBlocState> {

  AnalyticsBlocBloc() : super(AnalyticsBlocInitial()) {
    on<AnalyticsLoadEvent>(analyticsLoadEvent);
  }

  Future<void> analyticsLoadEvent(AnalyticsLoadEvent event, Emitter<AnalyticsBlocState> emit) async{
    emit(AnalyticsLoadingState());
    List<int>xList = List.generate(10,((_){
      return Random().nextInt(20);
    }));
    List<int>yList = List.generate(10,((_){
      return Random().nextInt(20);
    }));
    String xTitle = "X-Axis";
    String yTitle = "Y-Axis";
    emit(AnalyticsLoadedState(xList, yList, xTitle, yTitle));
  }
}
