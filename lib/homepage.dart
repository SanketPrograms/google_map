import 'package:flutter/material.dart';
import 'package:google_map/searchLocation.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
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
class Homepage extends StatelessWidget {
  TextEditingController locationController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Address"),),
      body: Container(
          child: Consumer<LocationProvider>(builder: (context, item, _) {
            
            locationController.text = item.locationGlobal;
            return Container(child:
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:  TextFormField(
                    // minLines: 2,//todo:changes uncomment
                    // maxLength: 4,
                    controller: locationController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search_sharp),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocationAutoComplete()));
                          },
                        ),
                        labelText: 'Full Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)))),
                  ),
                ),

            );
          })),
    );
  }
}