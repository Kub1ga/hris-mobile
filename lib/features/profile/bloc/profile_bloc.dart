import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:workmate_mobile/features/profile/models/user_profile_models.dart';
import 'package:workmate_mobile/features/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository = ProfileRepository();
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final response = await _profileRepository.getUserProfile();
        emit(ProfileSuccess(userProfileModels: response));
      } catch (e) {
        emit(ProfileError());
      }
    });
  }
}
