import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_map/GoogleMap.dart';
import 'package:google_map/homepage.dart';
import 'package:google_map/searchLocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider(),
          ),
        ],
        child: MaterialApp(
          home: LocationAutoComplete(),
        ));
  }
}



