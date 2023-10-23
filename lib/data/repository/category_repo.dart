import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CategoryRepo {
  final ApiClient apiClient;
  final SharedPreferences  sharedPreferences;
  CategoryRepo({@required this.apiClient,this.sharedPreferences});


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

  
  currentposition = await Geolocator.getCurrentPosition();
}

  Future<Response> getCategoryList() async {
    final prefs = await SharedPreferences.getInstance();
    double lat =  prefs.getDouble('lat');
    double lng =  prefs.getDouble('lng');
    // await _determinePosition ();
    // print('${AppConstants.CATEGORY_URI}?lat=${currentposition.latitude}&lng=${currentposition.longitude}');
    return await apiClient.getData('${AppConstants.CATEGORY_URI}?lat=$lat&lng=$lng');
  }

  Future<Response> getSubCategoryList(String parentID) async {
    final prefs = await SharedPreferences.getInstance();
    double lat =  prefs.getDouble('lat');
    double lng =  prefs.getDouble('lng');
    // await _determinePosition ();
    return await apiClient.getData('${AppConstants.SUB_CATEGORY_URI}$parentID?lat=$lat&lng=$lng');
    // return await apiClient.getData('${AppConstants.SUB_CATEGORY_URI}$parentID?lat=${currentposition.latitude}&lng=${currentposition.longitude}');
  }

  Future<Response> getCategoryProductList(String categoryID, int offset, String type) async {
      final prefs = await SharedPreferences.getInstance();
    double lat =  prefs.getDouble('lat');
    double lng =  prefs.getDouble('lng');
    // await _determinePosition ();
    return await apiClient.getData('${AppConstants.CATEGORY_PRODUCT_URI}$categoryID?limit=10&offset=$offset&type=$type&lat=$lat&lng=$lng');
    // return await apiClient.getData('${AppConstants.CATEGORY_PRODUCT_URI}$categoryID?limit=100&offset=$offset&type=$type&lat=${currentposition.latitude}&lng=${currentposition.longitude}');
  }

  Future<Response> getCategoryRestaurantList(String categoryID, int offset, String type) async {
    // await _determinePosition ();
    final prefs = await SharedPreferences.getInstance();
    double lat =  prefs.getDouble('lat');
    double lng =  prefs.getDouble('lng');
    return await apiClient.getData('${AppConstants.CATEGORY_RESTAURANT_URI}$categoryID?limit=10&offset=$offset&type=$type&lat=$lat&lng=$lng');
  }

  Future<Response> getSearchData(String query, String categoryID, bool isRestaurant, String type) async {
    return await apiClient.getData(
      '${AppConstants.SEARCH_URI}${isRestaurant ? 'restaurants' : 'products'}/search?name=$query&category_id=$categoryID&type=$type&offset=1&limit=50',
    );
  }

  Future<Response> saveUserInterests(List<int> interests) async {
    return await apiClient.postData(AppConstants.INTEREST_URI, {"interest": interests});
  }

}