import 'dart:developer';

import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantRepo {
  final ApiClient apiClient;
  final SharedPreferences  sharedPreferences;
  RestaurantRepo({@required this.apiClient,this.sharedPreferences});

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

  Future<Response> getRestaurantList(int offset, String filterBy) async {
    return await apiClient.getData('${AppConstants.RESTAURANT_URI}/$filterBy?offset=$offset&limit=10');
  }

  Future<Response> getPopularRestaurantList(String type) async {
    return await apiClient.getData('${AppConstants.POPULAR_RESTAURANT_URI}?type=$type');
  }

  Future<Response> getLatestRestaurantList(String type) async {
    final prefs = await SharedPreferences.getInstance();
      double lat =  prefs.getDouble('lat');
       double lng =  prefs.getDouble('lng');
    return await apiClient.getData('${AppConstants.LATEST_RESTAURANT_URI}?type=$type&lat=$lat&lng=$lng');
  }
  
    Future<Response> getRestaurantDetails(String restaurantID ) async {
    final prefs = await SharedPreferences.getInstance();
      double lat =  prefs.getDouble('lat');
       double lng =  prefs.getDouble('lng');
      int categoryID = prefs.getInt('category_id');
      //  var response = await apiClient.getData('${AppConstants.RESTAURANT_DETAILS_URI}$restaurantID&lat=$lat&lng=$lng&category_id=$categoryID');
      //  log(response.toString());
      //  return response;
       return await apiClient.getData('${AppConstants.RESTAURANT_DETAILS_URI}$restaurantID&lat=$lat&lng=$lng&category_id=$categoryID');
       
  }

  Future<Response> getRestaurantProductList(int restaurantID, int offset, int categoryID, String type) async {
     final prefs = await SharedPreferences.getInstance();
      double lat =  prefs.getDouble('lat');
       double lng =  prefs.getDouble('lng');
    //  await _determinePosition ();
    return await apiClient.getData(
      '${AppConstants.RESTAURANT_PRODUCT_URI}?restaurant_id=$restaurantID&category_id=$categoryID&offset=$offset&limit=10&type=$type&lat=$lat&lng=$lng',
    );
  }

  Future<Response> getRestaurantSearchProductList(String searchText, String storeID, int offset, String type) async {
    return await apiClient.getData(
      '${AppConstants.SEARCH_URI}products/search?restaurant_id=$storeID&name=$searchText&offset=$offset&limit=10&type=$type',
    );
  }

  Future<Response> getRestaurantReviewList(String restaurantID) async {
    return await apiClient.getData('${AppConstants.RESTAURANT_REVIEW_URI}?restaurant_id=$restaurantID');
  }

}