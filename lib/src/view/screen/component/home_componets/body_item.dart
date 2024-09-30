import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:n_air_qua/src/view/screen/service/websocket_viewmodel.dart';
import 'package:provider/provider.dart';

class BodyItem extends StatefulWidget {
  const BodyItem({Key? key}) : super(key: key);

  @override
  State<BodyItem> createState() => _BodyItemState();
}

class _BodyItemState extends State<BodyItem> {
  final List<String> locations = [
    "IAQ_Marylebone",
    "IAQ_Oxford",
    "IAQ_Greenwich",
  ];

  final List<int> aqiData = [
    123,
    200,
    150
  ]; // AQI values for different locations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Swiper(
          itemCount: locations.length,
          layout: SwiperLayout.STACK,
          itemWidth: 400,
          itemHeight: 250,
          loop: true,
          scrollDirection: Axis.vertical,
          autoplay: true,
          autoplayDelay: 8000,
          duration: 1500,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: LocationCard(
                location: locations[index],
                aqi: aqiData[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  final String location;
  final int aqi;

  const LocationCard({super.key, required this.location, required this.aqi});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.ltr, // Add this line
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centers the row content horizontally
                      textDirection:
                          TextDirection.ltr, // Ensures left-to-right text flow
                      children: [
                        const Text(
                          "AQI:",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        Text(
                          aqi.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: aqi <= 100
                                ? Colors.green
                                : (aqi <= 200 ? Colors.orange : Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      // This centers the Echarts widget inside the SizedBox
                      child: SizedBox(
                        height: 170, // You can adjust these values as needed
                        width: 180, // You can adjust these values as needed
                        child: Echarts(
                          option: '''
              {
                series: [{
                  type: 'gauge',
                  startAngle: 180,
                  endAngle: 0,
                  min: 0,
                  max: 300,
                  splitNumber: 6,
                  axisLine: {
                    lineStyle: {
                      width: 25,
                      color: [
                        [0.165, '#00E400'],
                        [0.333, '#FFFF00'],
                        [0.5, '#FF7E00'],
                        [0.67, '#FF0000'],
                        [0.83, '#8F3F97'],
                        [1, '#7E0023']
                      ]
                    }
                  },
                  pointer: {
                    icon: 'path://M 2 8 L 5 -1 L 8 8',
                    length: '70%',
                    width: 10,
                    offsetCenter: [0, '0']
                  },
                  axisTick: {
                    show: false
                  },
                  splitLine: {
                    show: false
                  },
                  axisLabel: {
                    show: false
                  },
                  title: {
                    show: false
                  },
                  detail: {
                    show: true,
                    valueAnimation: true,
                  },
                  data: [{
                    value: $aqi
                  }],
                  animationDurationUpdate: 1000,
                  animationEasingUpdate: 'cubicInOut'
                }]
              }
              ''',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
