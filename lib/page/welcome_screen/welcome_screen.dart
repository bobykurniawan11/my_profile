import 'package:flutter/material.dart';
import 'package:my_profile/page/login_screen/login_screen.dart';
import 'package:my_profile/page/register_screen/register_screen.dart';
import 'package:my_profile/utils/app_theme_data.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset("./assets/images/logo_transparent.png"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: AppThemeData(context: context).myTextTheme.headline2,
              ),
            ],
          ),
          SizedBox(height: 70),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                key: Key("go_login_screen"),
                height: 40.0,
                minWidth: MediaQuery.of(context).size.width * .75,
                color: AppThemeData(context: context).myCustomTheme.primaryColor,
                child: new Text(
                  "Login",
                  style: AppThemeData(context: context).myTextTheme.button,
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                },
                shape: RoundedRectangleBorder(
                  borderRadius: AppThemeData(context: context).borderRadius,
                ),
              ),
              MaterialButton(
                key: Key("go_register_screen"),
                height: 40.0,
                minWidth: MediaQuery.of(context).size.width * .75,
                color: AppThemeData(context: context).myCustomTheme.primaryColor,
                child: new Text(
                  "Register",
                  style: AppThemeData(context: context).myTextTheme.button,
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  ),
                },
                shape: RoundedRectangleBorder(
                  borderRadius: AppThemeData(context: context).borderRadius,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
