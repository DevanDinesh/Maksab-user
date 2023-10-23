import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;





import '../model/response/conversation_model.dart';

class WalletRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  WalletRepo({@required this.apiClient,@required this.sharedPreferences});

  Future<Response> getWalletTransactionList(String offset) async {
    return await apiClient.getData('${AppConstants.WALLET_TRANSACTION_URL}?offset=$offset&limit=10');
  }

  Future<Response> getLoyaltyTransactionList(String offset) async {
    return await apiClient.getData('${AppConstants.LOYALTY_TRANSACTION_URL}?offset=$offset&limit=10');
  }

  Future<Response> pointToWallet({int point}) async {
    return await apiClient.postData(AppConstants.LOYALTY_POINT_TRANSFER_URL, {"point": point});
  }

  Future<Response> userDetails() async {

    return await apiClient.getData(AppConstants.GET_USER_INFO,
        query: {
      "token": sharedPreferences.get(AppConstants.TOKEN)

    });
  }

Future<Response> uploadFile({XFile file, String receipt, String receiptName,String credit}) async {
  try {
    var multipartBody = MultipartBody(receiptName, file);
    var response = await apiClient.postMultipartData(
      AppConstants.OFFLINE_WALLET_URL,
      {'credit': credit},
      [multipartBody],
      headers: {
        'Authorization': 'Bearer ${apiClient.sharedPreferences.get(AppConstants.TOKEN)}',
      },
    );
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('Error uploading file. Status code: ${response.statusCode}, Body: ${response.body}');
    }

    return response;
  } catch (error) {
    print('Failed to upload file: $error');
    throw Exception('Failed to upload file: $error');
  }
}


}



  

