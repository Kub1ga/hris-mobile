import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navbar_state.dart';

class NavbarCubit extends Cubit<int> {
  NavbarCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }
}
