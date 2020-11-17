import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/utils/app_theme_data.dart';
import 'package:my_profile/utils/connection.dart';

import 'bloc/splash_screen/splash_screen_bloc.dart';
import 'page/splash_screen/splash_screeen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Connection connection = new Connection();
  @override
  Widget build(BuildContext context) {
    return AppTheme(
      child: MaterialApp(
        theme: AppThemeData(context: context).myCustomTheme,
        home: BlocProvider(
          create: (context) {
            return SplashScreenBloc(connection);
          },
          child: SplashScreen(),
        ),
      ),
    );
  }
}
