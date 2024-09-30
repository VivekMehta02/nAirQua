import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:n_air_qua/src/router/routerr.dart';
import 'package:n_air_qua/src/view/screen/service/websocket_viewmodel.dart';
import 'package:n_air_qua/src/view/screen/splash_screen.dart';
import 'package:n_air_qua/src/viewmodel/bottom_navigate_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (_) => WsService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: Routerr.generateRoute,
        home: const SplashScreen(),
      ),
    );
  }
}
