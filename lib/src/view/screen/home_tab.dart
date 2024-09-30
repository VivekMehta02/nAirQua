import 'package:flutter/material.dart';
import 'package:n_air_qua/src/view/model/deviceItem.dart';
import 'package:n_air_qua/src/view/screen/component/home_componets/body_item.dart';
import 'package:n_air_qua/src/view/screen/component/home_componets/body_page.dart';
import 'package:n_air_qua/src/view/screen/service/websocket_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late WsService _wsService;
  bool _isConnected = false;
  List<DeviceItem> devices = [];

  @override
  void initState() {
    super.initState();
    _wsService = Provider.of<WsService>(context, listen: false);
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    bool connected = await _wsService.connect('your_websocket_url_here');
    if (connected) {
      setState(() {
        _isConnected = true;
      });
      _wsService.subscribe('device');
      print('WebSocket connected successfully');
      _wsService.getMessages('device').listen((data) {
        print('Received data: $data');
        setState(() {
          devices = (data['data'] as List)
              .map((item) => DeviceItem.fromJson(item))
              .toList();
        });
      });
    } else {
      print('Failed to connect to WebSocket');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BodyPage(devices: devices),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 170,
                child: BodyItem(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
