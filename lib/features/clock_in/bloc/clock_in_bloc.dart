import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'clock_in_event.dart';
part 'clock_in_state.dart';

class ClockInBloc extends Bloc<ClockInEvent, ClockInState> {
  ClockInBloc() : super(ClockInInitial()) {
    on<ClockInEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
