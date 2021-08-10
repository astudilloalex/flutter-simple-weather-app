import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_map_client/open_weather_map_client.dart';

class SliderSunriseSunset extends StatelessWidget {
  final OpenWeatherMap api;

  const SliderSunriseSunset({Key? key, required this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<City>(
      future: api.detailedCity,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return Stack(
          children: [
            SizedBox(
              width: 360.0,
              child: CustomPaint(
                painter: _Painter(
                  snapshot.data!.sunset!
                      .difference(snapshot.data!.sunrise!)
                      .inMinutes,
                  snapshot.data!.sunset!.difference(DateTime.now()).inMinutes,
                ),
              ),
            ),
            ClipOval(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: 150 / 360 / 100,
                child: Container(
                  color: Colors.amber,
                  width: 15.0,
                  height: 15.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Painter extends CustomPainter {
  final int sunsetSunriseDifference;
  final int sunsetNowDifference;
  const _Painter(this.sunsetSunriseDifference, this.sunsetNowDifference);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final Path path = Path();
    path.moveTo(0.0, size.height / 2);
    path.quadraticBezierTo(175.0, -105.0, size.width, size.height);
    canvas.drawPath(path, paint);
    // Selector
    double offsetx = 0.0;
    double offsety = 0.0;
    if (sunsetNowDifference <= 0) {
      offsetx = 350.0;
    } else if (sunsetNowDifference > sunsetSunriseDifference) {
      offsetx = 2.5;
    } else {
      offsetx = (1 - sunsetNowDifference / sunsetSunriseDifference) * 350.0;
      // Use cuadratic equation ax^2 +bx+c=0
      offsety = (3 / 1750) * pow(offsetx, 2) - 0.6 * offsetx;
    }
    canvas.drawCircle(
      Offset(offsetx, offsety),
      8.0,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.amber,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
