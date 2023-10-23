import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/body/review_body.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences  sharedPreferences;
  ProductRepo({@required this.apiClient,this.sharedPreferences});

  Position currentposition;
  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  currentposition = await Geolocator.getCurrentPosition();
}


  Future<Response> getPopularProductList(String type) async {
   final prefs = await SharedPreferences.getInstance();
      double lat =  prefs.getDouble('lat');
       double lng =  prefs.getDouble('lng');
    // await _determinePosition ();
    return await apiClient.getData('${AppConstants.POPULAR_PRODUCT_URI}?type=$type&lat=$lat&lng=$lng');
  }

  Future<Response> getReviewedProductList(String type) async {
    // await _determinePosition ();
     final prefs = await SharedPreferences.getInstance();
      double lat =  prefs.getDouble('lat');
       double lng =  prefs.getDouble('lng');
    return await apiClient.getData('${AppConstants.REVIEWED_PRODUCT_URI}?type=$type&lat=$lat&lng=$lng');
  }

  Future<Response> submitReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.REVIEW_URI, reviewBody.toJson());
  }

  Future<Response> submitDeliveryManReview(ReviewBody reviewBody) async {
    return await apiClient.postData(AppConstants.DELIVER_MAN_REVIEW_URI, reviewBody.toJson());
  }
}
