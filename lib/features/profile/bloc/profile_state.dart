part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserProfileModels userProfileModels;

  const ProfileSuccess({required this.userProfileModels});

  @override
  List<Object> get props => [userProfileModels];
}

class ProfileError extends ProfileState {}
