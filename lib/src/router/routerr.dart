// router.dart
import 'package:flutter/material.dart';
import 'package:n_air_qua/src/router/router_path.dart';
import 'package:n_air_qua/src/view/screen/splash_screen.dart';

class Routerr {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreens:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case LoginScreens:
      // return MaterialPageRoute(builder: (_) => const LoginScreen());
      case HomeScreens:
      // return MaterialPageRoute(builder: (_) => const HomeScreen());
      // case DetailProductScreens:
      //   final productId = settings.arguments as String; // Example argument
      //   return MaterialPageRoute(
      //       builder: (_) => DetailProductScreen(productId: productId));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
