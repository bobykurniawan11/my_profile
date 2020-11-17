part of 'splash_screen_bloc.dart';

abstract class SplashScreenState extends Equatable {
  const SplashScreenState();

  @override
  List<Object> get props => [];
}

class SplashScreenInitial extends SplashScreenState {}

class SplashScreenLoading extends SplashScreenState {}

class SplashScreenFinishSuccess extends SplashScreenState {}

class SplashScreenFinishSuccessLoggedIn extends SplashScreenState {}

class SplashScreenFinishFailed extends SplashScreenState {}
