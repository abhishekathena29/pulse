import 'package:flutter/material.dart';
import 'package:pulse/homepage.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Connection Required'),
      //   backgroundColor: Colors.orange,
      // ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Warning Icon
            const Icon(
              Icons.wifi_lock,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Important Connection Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.wifi, color: Colors.green),
                    title: Text('Connect to ESP Device WiFi'),
                    subtitle: Text(
                        'Go to WiFi settings and connect to "ESP8266-AP" network'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.signal_cellular_off, color: Colors.red),
                    title: Text('Turn OFF Mobile Data'),
                    subtitle:
                        Text('Disable mobile data to ensure proper connection'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Proceed Button
            ElevatedButton(
              onPressed: () {
                // Navigate to home screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Homepage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Proceed to Home Page',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
