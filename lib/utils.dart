import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:latlong2/latlong.dart';

Future<String> getLocalIpAddress() async {
  final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4, includeLinkLocal: true);

  try {
    // Try VPN connection first
    NetworkInterface vpnInterface =
        interfaces.firstWhere((element) => element.name == "tun0");
    return vpnInterface.addresses.first.address;
  } on StateError {
    // Try wlan connection next
    try {
      NetworkInterface interface = interfaces
          .firstWhere((element) => element.name.contains(RegExp("wlan0")));
      return interface.addresses.first.address;
    } catch (ex) {
      // Try any other connection next
      try {
        NetworkInterface interface = interfaces.firstWhere(
            (element) => !(element.name == "tun0" || element.name == "wlan0"));
        return interface.addresses.first.address;
      } catch (ex) {
        return "error";
      }
    }
  }
}

enum ACTIVITY { GROUND, STILL, RUMINATE, GRAZE, WALK, OTHER }

class Message {
  int time = 0;
  double lat = 0.0;
  double lon = 0.0;
  double battery = 0.0;
  ACTIVITY lastActivity = ACTIVITY.OTHER;
  int devID = 0;

  Message(this.time, this.lat, this.lon, this.devID);
  Message.FromString(String input) {
    final items = input.split(',');
    //this.devID = int.parse(items[2]);
    //this.time = int.parse(items[3]);
    this.lat = double.parse(items[0]);
    this.lon = double.parse(items[1]);
  }
}

class ImprovedMarker {
  LatLng coordinates;
  double opacity = 1;
  ImprovedMarker({required this.coordinates});

  Marker getMarker(BuildContext context) {
    return Marker(
      point: coordinates,
      builder: (context) => Container(
          child: Icon(
        Icons.location_on,
        size: opacity == 1 ? 35 : 25,
        color: opacity == 1 ? Colors.red : Colors.black.withOpacity(opacity),
      )),
    );
  }
}
