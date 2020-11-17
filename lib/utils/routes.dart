import 'package:flutter/material.dart';
import 'package:my_profile/page/dashboard/Dashboard.dart';
import 'package:my_profile/page/welcome_screen/welcome_screen.dart';

class WelcomeScreenRoute extends MaterialPageRoute {
  WelcomeScreenRoute() : super(builder: (BuildContext context) => new WelcomeScreen());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return new ScaleTransition(
      scale: animation,
      child: new FadeTransition(
        opacity: animation,
        child: new WelcomeScreen(),
      ),
    );
  }
}

class DashboardScreenRoute extends MaterialPageRoute {
  DashboardScreenRoute() : super(builder: (BuildContext context) => new Dashboard());
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return new ScaleTransition(
      scale: animation,
      child: new FadeTransition(
        opacity: animation,
        child: new Dashboard(),
      ),
    );
  }
}
