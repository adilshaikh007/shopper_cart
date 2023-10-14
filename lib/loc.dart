import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationAccessPage extends StatefulWidget {
  @override
  _LocationAccessPageState createState() => _LocationAccessPageState();
}

class _LocationAccessPageState extends State<LocationAccessPage> {
  PermissionStatus _permissionStatus = PermissionStatus.provisional;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    setState(() {
      _permissionStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Access Example"),
      ),
      body: Center(
        child: Text(
          "Location Permission Status: $_permissionStatus",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
