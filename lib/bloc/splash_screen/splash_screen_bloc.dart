import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_profile/utils/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final Connection connection;

  SplashScreenBloc(this.connection) : super(SplashScreenInitial());

  @override
  Stream<SplashScreenState> mapEventToState(
    SplashScreenEvent event,
  ) async* {
    if (event is CheckInternet) {
      await Future.delayed(Duration(seconds: 2));
      yield SplashScreenLoading();
      await Future.delayed(Duration(seconds: 1));

      final isConnected = await connection.check();
      if (isConnected) {
        final isUserLogin = await isLoggedIn();

        if (isUserLogin) {
          yield SplashScreenFinishSuccessLoggedIn();
        } else {
          yield SplashScreenFinishSuccess();
        }
      } else {
        yield SplashScreenFinishFailed();
      }
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    if (uid != null) {
      return true;
    } else {
      return false;
    }
  }
}
