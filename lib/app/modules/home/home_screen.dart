import 'package:apitayari/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});


   HomeController homeController =Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Obx(() => GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(28.6139, 77.2090),
          zoom: 14,
        ),
        circles: homeController.circles.value,
        onMapCreated: (GoogleMapController controller) {
          homeController.mapController = controller;
        },
        onTap: (LatLng tappedLocation) {
          homeController.addCircle(tappedLocation, 3000); // 3km circle
        },
      )),
    );
  }
}
