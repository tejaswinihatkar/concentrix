import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_apps/device_apps.dart';

// Generalized permission request function
Future<bool> requestPermission(Permission permission) async {
  var status = await permission.status;
  if (!status.isGranted) {
    status = await permission.request();
  }
  return status.isGranted;
}

class SelectAppsScreen extends StatefulWidget {
  const SelectAppsScreen({super.key});

  @override
  _SelectAppsScreenState createState() => _SelectAppsScreenState();
}

class _SelectAppsScreenState extends State<SelectAppsScreen> {
  bool _permissionGranted = false;
  List<Application> _installedApps = [];

  @override
  void initState() {
    super.initState();
    // Request the necessary permission (e.g., notifications or other)
    requestPermission(Permission.notification).then((granted) {
      setState(() {
        _permissionGranted = granted;
      });
      if (granted) {
        _fetchInstalledApps(); // Fetch apps if permission is granted
      }
    });
  }

  // Function to fetch installed apps
  Future<void> _fetchInstalledApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true, // Include app icons
      includeSystemApps: false, // Exclude system apps
    );

    setState(() {
      _installedApps = apps;
    });
  }

  // Show a dialog to confirm if the user wants to manage notifications for the app
  Future<void> _showManageNotificationDialog(Application app) async {
    bool allowAccess = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Manage notifications for ${app.appName}?'),
          content: const Text('Would you like to allow or deny access to manage notifications for this app?'),
          actions: [
            TextButton(
              onPressed: () {
                allowAccess = false;
                Navigator.of(context).pop();
              },
              child: const Text('Deny'),
            ),
            TextButton(
              onPressed: () {
                allowAccess = true;
                Navigator.of(context).pop();
              },
              child: const Text('Allow'),
            ),
          ],
        );
      },
    );

    if (allowAccess) {
      // Perform the action to allow notification management (You can handle the logic here)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You allowed access for ${app.appName}'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You denied access for ${app.appName}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Apps'),
        backgroundColor: Colors.amber,
      ),
      body: _permissionGranted
          ? _installedApps.isEmpty
              ? const Center(child: CircularProgressIndicator()) // Loading spinner
              : ListView.builder(
                  itemCount: _installedApps.length,
                  itemBuilder: (context, index) {
                    Application app = _installedApps[index];
                    return ListTile(
                      leading: app is ApplicationWithIcon
                          ? Image.memory(app.icon) // App icon
                          : null,
                      title: Text(app.appName), // App name
                      subtitle: Text(app.packageName), // Package name
                      onTap: () {
                        // Show the dialog when the app is tapped
                        _showManageNotificationDialog(app);
                      },
                    );
                  },
                )
          : const Center(
              child: Text(
                'Permission required to access notifications',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
    );
  }
}
