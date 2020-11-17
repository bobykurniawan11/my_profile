import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/splash_screen/splash_screen_bloc.dart';
import 'package:my_profile/utils/app_theme_data.dart';
import 'package:my_profile/utils/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenBloc splashScreenBloc;
  @override
  void initState() {
    splashScreenBloc = BlocProvider.of<SplashScreenBloc>(context);
    splashScreenBloc.add(CheckInternet());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("scaff_splashscreen"),
      body: Center(
        child: BlocListener<SplashScreenBloc, SplashScreenState>(
          listener: (context, state) async {
            if (state is SplashScreenLoading) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppThemeData(context: context).myCustomTheme.primaryColor,
                  content: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularProgressIndicator(),
                        Text(
                          "Checking your internet ...",
                          style: AppThemeData(context: context).myTextTheme.button,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is SplashScreenFinishFailed) {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppThemeData(context: context).myCustomTheme.primaryColor,
                  content: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.warning),
                        Text(
                          "Please Check Your Internet Connection",
                          style: AppThemeData(context: context).myTextTheme.button,
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is SplashScreenFinishSuccess) {
              Navigator.of(context).pushReplacement(new WelcomeScreenRoute());
            } else if (state is SplashScreenFinishSuccessLoggedIn) {
              Navigator.of(context).pushReplacement(new DashboardScreenRoute());
            }
          },
          child: Center(
            child: Image.asset(
              "./assets/images/logo_transparent.png",
              key: Key("splash_screen_image"),
            ),
          ),
        ),
      ),
    );
  }
}
