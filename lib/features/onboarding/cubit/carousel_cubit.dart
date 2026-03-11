import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'carousel_state.dart';

class CarouselCubit extends Cubit<int> {
  CarouselCubit() : super(0);

  void changeIndicator(int index) {
    emit(index);
  }

  void nextPage(int totalPages) {
    if (state < totalPages - 1) {
      emit(state + 1);
      print("$state, $isLastPage");
    }
  }

  bool get isLastPage => state == 3;
}
