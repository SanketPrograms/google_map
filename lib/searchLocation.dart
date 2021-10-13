import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_map/homepage.dart';
import 'package:google_map/searchLocation.dart';
import 'package:google_map/userAddressModal.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocationAutoComplete extends StatefulWidget {
  @override
  _LocationAutoCompleteState createState() => _LocationAutoCompleteState();
}

class _LocationAutoCompleteState extends State<LocationAutoComplete> {
  TextEditingController locationController = new TextEditingController();
  String filter;
  var address = "";
  @override
  void initState() {
    locationController.addListener(() {
      setState(() {
        filter = locationController.text;
      });
    });
    super.initState();
  }

  loadData() async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$filter&key=AIzaSyDVvdoJXCxXWgnHKdbJiY9mwexScQ7bnDY&sessiontoken=1234567890&components=country:IN');

    var response = await http.post(url);
    var message = jsonDecode(response.body);

    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Location"),
        elevation: 0,
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(20),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: TextFormField(
        //       controller: locationController,
        //       decoration: InputDecoration(
        //           border: OutlineInputBorder(
        //               borderRadius: BorderRadius.all(Radius.circular(25)))),
        //     ),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),

                   //     height: 45,
                  // width: 300,
                  child: TextFormField(
                    scrollPhysics: BouncingScrollPhysics(),
                    controller: locationController,
                    style: TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                        suffixIcon: filter == null?IconButton(
                          icon: Icon(Icons.search_sharp),
                          onPressed: () {

                          },
                        ):IconButton(icon: Icon(Icons.clear,size: 15,), onPressed: (){
                          locationController.clear();
                        }),
                        labelText: 'Search Address',

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)))),
                  ),
                             ),
              filter == null
                  ? Center(
                child: Text('Choose your location'),
              )
                  : FutureBuilder(
                future: loadData(),
                builder: (context, snapshot) => snapshot.hasData
                    ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount: snapshot.data['predictions'].length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(snapshot.data['predictions'][index]
                      ['description'],style: TextStyle(fontSize: 12),),
                      subtitle: Divider(),
                      onTap: () {
                         setState(() {
                        locationController.text = snapshot.data['predictions']
                        [index]['description'].toString();
                         });
                        Provider.of<LocationProvider>(context,
                            listen: false)
                            .changeLocation(snapshot.data['predictions']
                        [index]['description']);
                       //  Navigator.pop(context);
                      },
                    ))
                    : Center(child: CircularProgressIndicator()),
              ),
            ],
          ),

      ),
    );
  }
}

class LocationProvider extends ChangeNotifier {
  String locationGlobal;
  String houseDetailsGlobal = '';
  String landmarkGlobal = '';
  String userId;
  Position myPosition;
  String activeAddress;
  String activeAddressId;

  // saveUsersLocation(String houseFlatDetails, String locality) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   userId = preferences.getString('userId');
  //
  //   var url =  Uri.parse('https://api.meehelp.in/api/customer/address');
  //   var data = {
  //     "API_KEY": "70FF52C593B828281A",
  //     "customer_id": "$userId",
  //     "customer_address": houseFlatDetails,
  //     "customer_locality": locality,
  //     "google_address": locationGlobal.toString(),
  //     "latitude": myPosition.latitude.toString(),
  //     "longitude": myPosition.longitude.toString(),
  //   };
  //   var responce = await http.post(url, body: data);
  //   print(responce.body);
  //   preferences.setString('activeAddress', activeAddress);
  //   preferences.setString('activeAddressID', activeAddressId);
  //   return responce.body;
  // }

  changeLocation(String location) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    locationGlobal = location;
    var query = await Geocoder.local.findAddressesFromQuery(location);
    myPosition = Position(
        latitude: query.first.coordinates.latitude,
        longitude: query.first.coordinates.longitude);
    notifyListeners();
    // preferences.setString('activeAddress', activeAddress);
    // preferences.setString('activeAddressID', activeAddressId);
    print('changeLocation $locationGlobal');
    print('changeLocation $myPosition');
    notifyListeners();
  }

  getAddressFromCurrentLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('getAddress is running');
    myPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coOrdinates =
    new Coordinates(myPosition.latitude, myPosition.longitude);
    print('${coOrdinates.latitude},${coOrdinates.longitude}');
    var address =
    await Geocoder.local.findAddressesFromCoordinates(coOrdinates);
    print(
        '${address.first.addressLine},${address.first.adminArea},${address.first.subLocality}');
    locationGlobal = address.first.addressLine;
    notifyListeners();
    preferences.setString('activeAddress', activeAddress);
    preferences.setString('activeAddressID', activeAddressId);
    return locationGlobal;
  }

  setActiveAddress(UserAddress address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    activeAddress =
    '${address.customer_address},${address.customer_locality},${address.google_address}';
    activeAddressId = address.address_id;
    locationGlobal = address.google_address;
    houseDetailsGlobal = address.customer_address;
    landmarkGlobal = address.customer_locality;
    notifyListeners();
    preferences.setString('activeAddress', activeAddress);
    preferences.setString('activeAddressID', activeAddressId);
  }

  fetchSavedAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    activeAddress = preferences.getString('activeAddress');
    activeAddressId = preferences.getString('activeAddressID');
    notifyListeners();
  }
}