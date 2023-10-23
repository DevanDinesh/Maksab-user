import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/body/place_order_body.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({@required this.apiClient, @required this.sharedPreferences});

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

  Future<Response> getRunningOrderList(int offset) async {
    return await apiClient.getData('${AppConstants.RUNNING_ORDER_LIST_URI}?offset=$offset&limit=${100}');
  }

  Future<Response> getHistoryOrderList(int offset) async {
    return await apiClient.getData('${AppConstants.HISTORY_ORDER_LIST_URI}?offset=$offset&limit=10');
  }

  Future<Response>  getOrderDetails(String orderID) async {
    return await apiClient.getData('${AppConstants.ORDER_DETAILS_URI}$orderID');
  }



  Future<Response> cancelOrder(String orderID) async {
    return await apiClient.postData(AppConstants.ORDER_CANCEL_URI, {'_method': 'put', 'order_id': orderID});
  }

  Future<Response> trackOrder(String orderID) async {
    return await apiClient.getData('${AppConstants.TRACK_URI}$orderID');
  }

  Future<Response> placeOrder(PlaceOrderBody orderBody) async {
    // print(orderBody.toJson().toString()+"ftfghh");
   return await apiClient.postData(AppConstants.PLACE_ORDER_URI, orderBody.toJson());
  }

  Future<Response> getDeliveryManData(String orderID) async {
    await _determinePosition();
    return await apiClient.getData('${AppConstants.LAST_LOCATION_URI}$orderID?latitude=${currentposition.latitude}&longitude=${currentposition.longitude}');
  }

  Future<Response> switchToCOD(String orderID) async {
    return await apiClient.postData(AppConstants.COD_SWITCH_URL, {'_method': 'put', 'order_id': orderID});
  }

  Future<Response> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    return await apiClient.getData('${AppConstants.DISTANCE_MATRIX_URI}'
        '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
        '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}');
  }

  Future<Response> getRefundReasons() async {
    return await apiClient.getData('${AppConstants.REFUND_REASONS_URI}');
  }

  Future<Response> submitRefundRequest(Map<String, String> body, XFile data) async {
    return apiClient.postMultipartData(AppConstants.REFUND_REQUEST_URI, body,  [MultipartBody('image[]', data)]);
  }

}