import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import the animate package

class AlarmTab extends StatelessWidget {
  const AlarmTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            // Animated image with FadeInUp effect
            Image.asset(
              'assets/image/maintenance.png',
              width: 200, // Set the width of the image (optional)
              height: 200, // Set the height of the image (optional)
            )
                .animate()
                .fadeIn()
                .slideY(begin: 1.0, duration: 500.ms), // FadeInUp animation
            const SizedBox(height: 20), // Spacing between image and text

            const Text(
              "Alarm is under maintenance",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16, // Set font size to 16
                fontWeight: FontWeight.bold, // Make text bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
