// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class BodyPage extends StatefulWidget {
//   const BodyPage({super.key});

//   @override
//   _BodyPageState createState() => _BodyPageState();
// }

// class _BodyPageState extends State<BodyPage> with TickerProviderStateMixin {
//   final MapController mapController = MapController();
//   LatLng latLng = const LatLng(48.8584, 2.2945); // Eiffel Tower coordinates
//   late AnimationController _markerAnimationController;
//   late Animation<double> _markerAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _markerAnimationController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//     _markerAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _markerAnimationController,
//       curve: Curves.elasticOut,
//     ));

//     // Start the animations after a short delay to ensure the map is loaded
//     Future.delayed(Duration(milliseconds: 100), () {
//       _markerAnimationController.forward();
//       _startZoomAnimation();
//     });
//   }

//   void _startZoomAnimation() {
//     const double initialZoom = 5;
//     const double finalZoom = 18;
//     const duration = Duration(seconds: 2);

//     double currentZoom = initialZoom;
//     final zoomSteps = 60; // Animate over 60 frames for smooth transition

//     void animate(Timer timer) {
//       if (currentZoom < finalZoom) {
//         currentZoom += (finalZoom - initialZoom) / zoomSteps;
//         mapController.move(latLng, currentZoom);
//       } else {
//         timer.cancel();
//       }
//     }

//     Timer.periodic(duration ~/ zoomSteps, animate);
//   }

//   @override
//   void dispose() {
//     _markerAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FlutterMap(
//         mapController: mapController,
//         options: MapOptions(
//           initialCenter: latLng,
//           initialZoom: 5, // Start with a zoomed-out view
//         ),
//         children: [
//           TileLayer(
//             urlTemplate:
//                 'https://api.mapbox.com/styles/v1/vivek2514/cm0wsg199010x01qkghjmdisw/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoidml2ZWsyNTE0IiwiYSI6ImNtMHdwaG4zeDA0NDIybXExbmw0dnZxeGgifQ.1wHZnFr7nL9BjlLjPW7SyQ',
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: latLng,
//                 width: 60,
//                 height: 60,
//                 child: AnimatedBuilder(
//                   animation: _markerAnimation,
//                   builder: (context, child) {
//                     return Transform.scale(
//                       scale: _markerAnimation.value,
//                       child: Icon(
//                         Icons.location_pin,
//                         color: Colors.red.shade700,
//                         size: 60,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:n_air_qua/src/view/model/deviceItem.dart';

class BodyPage extends StatefulWidget {
  final List<DeviceItem> devices;

  const BodyPage({Key? key, required this.devices}) : super(key: key);

  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> with TickerProviderStateMixin {
  final MapController mapController = MapController();
  late AnimationController _markerAnimationController;
  late Animation<double> _markerAnimation;

  @override
  void initState() {
    super.initState();
    _markerAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _markerAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _markerAnimationController,
      curve: Curves.elasticOut,
    ));

    Future.delayed(Duration(milliseconds: 100), () {
      _markerAnimationController.forward();
      _startZoomAnimation();
    });
  }

  void _startZoomAnimation() {
    if (widget.devices.isEmpty) return;

    List<LatLng> points = widget.devices
        .map((device) => LatLng(
              double.tryParse(device.data![0].lat ?? '') ?? 0,
              double.tryParse(device.data![0].long ?? '') ?? 0,
            ))
        .toList();

    double minLat = points.map((p) => p.latitude).reduce(min);
    double maxLat = points.map((p) => p.latitude).reduce(max);
    double minLong = points.map((p) => p.longitude).reduce(min);
    double maxLong = points.map((p) => p.longitude).reduce(max);

    LatLng center = LatLng(
      (minLat + maxLat) / 2,
      (minLong + maxLong) / 2,
    );

    double zoom = _calculateZoomLevel(minLat, maxLat, minLong, maxLong);

    mapController.move(center, zoom);
  }

  double _calculateZoomLevel(
      double minLat, double maxLat, double minLong, double maxLong) {
    const WORLD_PX_HEIGHT = 256.0;
    const WORLD_PX_WIDTH = 256.0;
    const ZOOM_MAX = 21.0;

    double latFraction = (maxLat - minLat) / 180.0;
    double longFraction = (maxLong - minLong) / 360.0;

    double latZoom = log(WORLD_PX_HEIGHT / latFraction) / ln2;
    double longZoom = log(WORLD_PX_WIDTH / longFraction) / ln2;

    return min(min(latZoom, longZoom), ZOOM_MAX) -
        1; // Subtract 1 to zoom out slightly
  }

  @override
  void dispose() {
    _markerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: widget.devices.isNotEmpty
              ? LatLng(
                  double.tryParse(widget.devices[0].data![0].lat ?? '') ?? 0,
                  double.tryParse(widget.devices[0].data![0].long ?? '') ?? 0,
                )
              : LatLng(0, 0),
          initialZoom: 5,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/vivek2514/cm0wsg199010x01qkghjmdisw/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoidml2ZWsyNTE0IiwiYSI6ImNtMHdwaG4zeDA0NDIybXExbmw0dnZxeGgifQ.1wHZnFr7nL9BjlLjPW7SyQ',
          ),
          MarkerLayer(
            markers: widget.devices.map((device) {
              return Marker(
                point: LatLng(
                  double.tryParse(device.data![0].lat ?? '') ?? 0,
                  double.tryParse(device.data![0].long ?? '') ?? 0,
                ),
                width: 60,
                height: 60,
                child: AnimatedBuilder(
                  animation: _markerAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _markerAnimation.value,
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.red.shade700,
                            size: 40,
                          ),
                          Text(
                            device.data![0].name ?? '',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
