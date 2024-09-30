import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:n_air_qua/src/view/screen/login_screen.dart';
import 'package:n_air_qua/src/view/screen/widget_ring_animator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context,
            // MaterialPageRoute(builder: (context) => DashBoardScreen())));
            MaterialPageRoute(builder: (context) => Login())));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: const Color(0xFFD2B48C),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Center(
              child: WidgetRingAnimator(
                size: 200,
                ringIcons: const [
                  'assets/image/Hazardous2.png',
                  'assets/image/Healthy1.png',
                  'assets/image/Moderate2.png',
                  'assets/image/Severe2.png',
                  'assets/image/Unhealthy2.png',
                  'assets/image/Very Unhealthy2.png'
                ],
                ringIconsSize: 0.09, // Reduce the size of the icons
                ringIconsColor: Colors.transparent,
                ringAnimation: Curves.linear,
                ringColor: Colors.green,
                reverse: false,
                ringAnimationInSeconds: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: Image.asset(
                    'assets/image/nAirQua_logo.png',
                    height: 30,
                  ),
                ),
              ),
            ),
            Center(
              child: AvatarGlow(
                glowColor: Colors.lightGreen,
                endRadius: 200.0,
                duration: const Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                child: Material(
                  elevation: 8.0,
                  shape: const CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60.0,
                    child: Image.asset(
                      'assets/image/nAirQua_logo.png',
                      height: 100,
                    ),
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'nAirQua',
                  style: TextStyle(fontSize: 20),
                ),
                // child: Image.asset(
                //   'assets/ajeevi-logo.png', // company logo path
                //   height: 80,
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:n_air_qua/src/viewmodel/websocket_viewmodel.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final webSocketViewModel = Provider.of<WebSocketViewModel>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Splash Screen with WebSocket'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Received Message: ${webSocketViewModel.message}',
//               style: TextStyle(fontSize: 20),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Example of sending a message to the WebSocket server
//                 webSocketViewModel.sendMessage('Hello from Flutter!');
//               },
//               child: Text('Send WebSocket Message'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
