import 'package:apitayari/app/data/api_provider.dart';
import 'package:apitayari/app/helper/socket_helper.dart';
import 'package:apitayari/app/models/country_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeController extends GetxController {
  RxList<CountryModel> countryList = RxList();

  RxList<String> countryFirstStringList = RxList();

  var latitude=0.0.obs;
  var longitude=0.0.obs;
  var addressNew="".obs;

  final socketHelper = Get.find<SocketHelper>();
  late IO.Socket socketIO;

  late ApiProvider _apiProvider;




  Rx<Set<Circle>> circles = Rx<Set<Circle>>({
    Circle(
      circleId: CircleId("area_circle"),
      center: LatLng(28.6139, 77.2090),
      radius: 4000,
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.blue.withOpacity(0.2),
    ),
  });


  GoogleMapController? mapController;

  void addCircle(LatLng location, double radius) {
    circles.value = {
      Circle(
        circleId: CircleId("new_circle"),
        center: location,
        radius: radius,
        strokeWidth: 2,
        strokeColor: Colors.red,
        fillColor: Colors.red.withOpacity(0.2),
      )
    };
  }

  @override
  void onInit() {
    // TODO: implement onInit
    _apiProvider = ApiProvider();
    getData();
    socketIO = socketHelper.socket;

    super.onInit();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print("Location permission denied.");
        return;
      }
    }

    Position? position;
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      position = await Geolocator.getLastKnownPosition();
      position ??= await determinePosition();
    }

    if (position != null) {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      await getAddressFromLatLng(latitude.value, longitude.value);
    } else {
      print("Unable to fetch location.");
    }
  }

  static Future  determinePosition() async {
    // LocationPermission permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     //
    //   }
    // }
    // if (permission == LocationPermission.deniedForever) {
    //
    // }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }
    Position currentLocation = await Geolocator.getCurrentPosition();
    var lat = currentLocation.latitude.toPrecision(3);
    var lng = currentLocation.longitude.toPrecision(3);
    debugPrint("latitude=> $lat longitude=> $lng");
    if (currentLocation != null) {
      return currentLocation;
    } else {
      return null;
    }
  }

  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        print("Address: $address");
        addressNew.value = address; // Update the UI or state

      } else {
        print("No address found.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  Future getData() async {
    var data = await _apiProvider.getData();

    if (data.isNotEmpty) {
      countryList.value = data;
      print(countryList.value);

      for (var country in countryList) {
        for (var element in country.tld) {
          countryFirstStringList.add(element);
        }
      }

      countryList.forEach((country) {
        country.tld.forEach((element) {
          countryFirstStringList.add(element);
        });
      });
    }else{
      print("No country data");
    }
  }
}
