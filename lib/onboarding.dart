import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pulse/homepage.dart';

class DeviceConnectionPage extends StatefulWidget {
  final String espDeviceName; // Name of your ESP device

  const DeviceConnectionPage({super.key, required this.espDeviceName});

  @override
  State<DeviceConnectionPage> createState() => _DeviceConnectionPageState();
}

class _DeviceConnectionPageState extends State<DeviceConnectionPage> {
  bool _isDeviceConnected = false; // Track connection status (initially false)
  bool _isWifiConnected = false; // Track wifi connection to device

  @override
  void initState() {
    super.initState();
    _checkDeviceConnection(); // Check connection when page loads
  }

  Future<void> _checkDeviceConnection() async {
    // Replace these with your actual connection logic
    // This is a placeholder for checking if the device is active and wifi is connected
    // You'll likely use a plugin or custom code to communicate with the ESP device.

    // Example (replace with your actual code):
    try {
      // 1. Check if the device is active (e.g., ping, Bluetooth connection check)
      bool deviceActive =
          await _isDeviceActive(); // Your function to check device activity

      if (deviceActive) {
        _isDeviceConnected = true;

        // 2. Check if wifi is connected to the ESP device's network.
        _isWifiConnected =
            await _isConnectedToESPDevice(); // Your function to check Wifi
      } else {
        _isDeviceConnected = false;
        _isWifiConnected =
            false; // If device isn't active, wifi likely won't be either
      }
    } catch (e) {
      // Handle errors (e.g., device not found)
      print("Error checking connection: $e");
      _isDeviceConnected = false; // Ensure these are false in error case
      _isWifiConnected = false;
    }

    setState(() {}); // Update the UI
  }

  Future<bool> _isDeviceActive() async {
    // Replace with your actual device activity check (e.g., ping, Bluetooth)
    // This is a placeholder – you'll need to implement the real logic.
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate a delay
    return true; // Replace with your logic to determine if the device is reachable
  }

  // Future<bool> isConnectedToESPDevice(String espDeviceSSID) async {
  //   final List<ConnectivityResult> result =
  //       await Connectivity().checkConnectivity();
  //   if (result.contains(ConnectivityResult.wifi)) {
  //     // Connected to a WiFi network
  //     ConnectivityResult.wifi.name;
  //     try {
  //       final String? currentSSID = await Connectivity().getWifiName();

  //       if (currentSSID != null) {
  //         print("Current SSID: $currentSSID"); // Print for debugging
  //         print("ESP Device SSID: $espDeviceSSID"); // Print for debugging

  //         // Case-insensitive comparison is generally a good idea
  //         return currentSSID.toLowerCase() == espDeviceSSID.toLowerCase();
  //       } else {
  //         print("Could not get current SSID.");
  //         return false; // Could not retrieve SSID
  //       }
  //     } catch (e) {
  //       print("Error getting SSID: $e");
  //       return false; // Error occurred
  //     }
  //   } else {
  //     print("Not connected to WiFi.");
  //     return false; // Not connected to WiFi at all
  //   }
  // }

// Example usage:
// String myESPDeviceSSID = "MyESPNetwork"; // Replace with your ESP's SSID

// isConnectedToESPDevice(myESPDeviceSSID).then((isConnected) {
//   if (isConnected) {
//     print("Connected to ESP device!");
//     // Proceed with your logic
//   } else {
//     print("Not connected to ESP device.");
//     // Show a message to the user
//   }
// });

  Future<bool> _isConnectedToESPDevice() async {
    // Replace with your actual wifi connection check (e.g., using connectivity_plus or wifi_iot)
    // Check if the current wifi SSID matches your ESP device's SSID
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate a delay
    return true; // Replace with your logic to check wifi connection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text(
              //   "Connecting to ${widget.espDeviceName}",
              //   style: const TextStyle(fontSize: 20),
              // ),
              // const SizedBox(height: 20),
              // if (_isDeviceConnected && _isWifiConnected) ...[
              //   // Show success message
              //   const Icon(Icons.check_circle, color: Colors.green, size: 60),
              //   const Text("Device and WiFi connected!",
              //       style: TextStyle(fontSize: 18, color: Colors.green)),
              // ] else if (_isDeviceConnected && !_isWifiConnected) ...[
              //   // Wifi not connected
              //   const Icon(Icons.wifi_off, color: Colors.orange, size: 60),
              //   const Text("Device Active, but WiFi not connected to device!",
              //       style: TextStyle(fontSize: 18, color: Colors.orange)),
              //   Text(
              //       "Please connect your phone's WiFi to the ${widget.espDeviceName} network.",
              //       style: const TextStyle(fontSize: 16)),
              // ] else ...[
              //   // Device not connected
              //   const Icon(Icons.bluetooth_disabled,
              //       color: Colors.red, size: 60),
              //   Text(
              //       "Could not find ${widget.espDeviceName}. Please make sure the device is turned on and in range.",
              //       style: const TextStyle(fontSize: 16)),
              // ],
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _checkDeviceConnection, // Re-check connection
              //   child: const Text("Recheck Connection"),
              // ),
              Text(
                  "Please ensure that you have connected your device with wifi and mobile data is turned off"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Homepage()));
                }, // Re-check connection
                child: const Text("Go to Dashboard"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
