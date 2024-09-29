import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/custom_navbar.dart';
import 'select_apps_screen.dart';
import 'select_contacts_screen.dart';

class FocusHomePage extends StatelessWidget {
  const FocusHomePage({super.key});

  Future<void> _requestPermissions() async {
    await [
      Permission.contacts,
      Permission.storage,
      Permission.systemAlertWindow,
      Permission.notification,
      Permission.ignoreBatteryOptimizations,
      Permission.accessNotificationPolicy,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    _requestPermissions(); // Request permissions when the widget is built

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to CONCENTRIX'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.contacts, size: 50, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SelectContactsScreen()),
                        );
                      },
                    ),
                    const Text(
                      'Contacts',
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.android, size: 50, color: Colors.green),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SelectAppsScreen()),
                        );
                      },
                    ),
                    const Text(
                      'Apps',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}