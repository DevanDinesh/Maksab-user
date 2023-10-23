
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wallet_controller.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:efood_multivendor/data/repository/wallet_repo.dart';
import 'package:efood_multivendor/util/app_constants.dart';


import '../../../../data/api/api_client.dart';
import '../../../../helper/route_helper.dart';
import '../charge_wallet_screen.dart';

class TransferMoneyWalletBottomSheet extends StatefulWidget {
  final bool fromWallet;


  const TransferMoneyWalletBottomSheet({Key key, @required this.fromWallet}) : super(key: key);

  @override
  State<TransferMoneyWalletBottomSheet> createState() => _TransferMoneyWalletBottomSheetState();
}

class _TransferMoneyWalletBottomSheetState extends State<TransferMoneyWalletBottomSheet> {

  TextEditingController _amountController = TextEditingController();
  bool isOfflineSelected = false;
  bool isOnlineSelected = false;

  FilePickerResult _receipt;
  String _receiptName;
  String orderId;
  double amount;
  int is_saved;

 

//   void _pickFile() async {
//   FilePickerResult result = await FilePicker.platform.pickFiles(
//   type: FileType.custom,
//     allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'], 
//   );

//   if (result != null) {
//     setState(() {
//       _receipt = result;
//       _receiptName = _receipt.files.single.name;

//       if (_receipt.files.single.size > 4 * 1024 * 1024) {
//         showCustomSnackBar('File size must be less than 4MB.');
//         _receipt = null;
//         _receiptName = null;
//       }
//     });
//   }
// }


// void _pickFile() async {
//   FilePickerResult result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//   );

//   if (result != null) {
//     setState(() {
//       _receipt = result;
//       _receiptName = _receipt.files.single.name;

//       if (_receipt.files.single.size > 4 * 1024 * 1024) {
//         showCustomSnackBar('File size must be less than 4MB.');
//         _receipt = null;
//         _receiptName = null;
//       }
//     });

//   // if (_receipt != null) {
//   //       uploadReceipt(_receiptName,_receipt);
//   //   }
//    if (_receipt != null) {
//         uploadFile();
//     }
//   }

// }




void _pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _receipt = result;
        _receiptName = _receipt.files.single.name;

        if (_receipt.files.single.size > 4 * 1024 * 1024) {
          showCustomSnackBar('File size must be less than 4MB.');
          _receipt = null;
          _receiptName = null;
          
        }
      });

      if (_receipt != null) {
      XFile xFile = XFile(_receipt.files.single.path);
      String credit = _amountController.text;
       WalletRepo().uploadFile(file: xFile, receiptName: _receiptName, credit: credit).then((response) {
        if (response.statusCode == 200) {
      print('File uploaded successfully');
      print('Response: ${response.body}');
    } else {
      print('Error uploading file. Status code: ${response.statusCode}, Body: ${response.body}');
    }
      });
      }
    }
  }

// Future<Response> uploadReceipt(String receiptName, FilePickerResult receipt) async {
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   String token = sharedPreferences.getString(AppConstants.TOKEN);
//   var headers = {
//      'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $token'

//   };

//   var request = http.MultipartRequest(
//     'POST',
//     Uri.parse('https://test.maksab.om/api/v1/customer/wallet/offline?credit=400&receipt='),
//   );
//   request.files.add(http.MultipartFile.fromBytes(
//     'receipt',
//     receipt.files.single.bytes,
//     filename: receiptName,
//   ));
//   request.headers.addAll(headers);
//   try {
//     http.StreamedResponse response = await request.send();
  
//     if (response.statusCode == 200) {
//       print(await response.stream.bytesToString());
//     } else {
//       print('Error: ${response.reasonPhrase}');
//     }
//   } catch (error) {
//     print('Error: $error');
//   }
// }

  @override
  Widget build(BuildContext context) {
    print(widget.fromWallet);


return Container(
      width: 550,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_LARGE)),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [

SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: CustomButton(
              buttonText: 'Online'.tr,
              onPressed: () {
                setState(() {
                  isOnlineSelected = true;
                  isOfflineSelected = false;
                });
              },
              width:60,
              height:50,
            ),
          ),
        ),
      ),
 
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Align(
          alignment: Alignment.bottomRight,
          child: CustomButton(
            buttonText: 'offline'.tr,
            onPressed: () {
              setState(() {
                isOfflineSelected = true;
                isOnlineSelected = false;
              });
            },
            width:60,
            height:50,
          ),
        ),
      ),
    ],
  ),
),

          Text('transfer_currency_to_your_wallet'.tr,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
          // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          
  Visibility(
  visible: isOfflineSelected,
  child: Column(
    children: [
        Text('Account number : 01045772594001'.tr,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red),
        maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
        Text('Home Branch : MABELLAH'.tr,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red),
        maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
       Text('Swift Code : BDOFOMRUXXX'.tr,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red),
        maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
        Text('Account Name: Maksab Platform E Marketing and Investment L.L.C'.tr,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red),
        maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          ],
        ),
      ),
      
          Text('The Amount'.tr,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),
               Text('OMR'.tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), border: Border.all(color: Theme.of(context).primaryColor,width: 0.3)),
            child: CustomTextField(
              hintText: '0',
              controller: _amountController,
              inputType: TextInputType.phone,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

  if (isOfflineSelected && !isOnlineSelected)
  Row(
    children: [
      Container(
        width: 240,
        height: 30,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Center(
          child: _receipt != null
                ? Text(_receiptName ?? 'Upload The File', style: TextStyle(fontSize: 6, color: Colors.black))
                : Text('Upload The File', style: TextStyle(fontSize: 6, color: Colors.black)),
          ),
        ),
      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
      ElevatedButton(
        onPressed: () {
            _pickFile();
          },
        child: Text('Choose File'),
      ),
    ],
  ),

GetBuilder<WalletController>(
  builder: (walletController) {
    if (!walletController.isLoading) {
      if (isOnlineSelected) {
        return CustomButton(
          buttonText: 'Transfer'.tr,
          onPressed: () {  
            if (_amountController.text.isEmpty) {
              showCustomSnackBar('input_field_is_empty'.tr);
            } else {
              int _amount = int.parse(_amountController.text.trim());
              final SharedPreferences sharedPreferences = Get.find();
              String userId = sharedPreferences.get(AppConstants.USER_Id) ?? "";
              if (userId.isNotEmpty) {
              // walletController.getUserDetails();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChargeWalletScreen(
                      amount: _amount.toString(),
                      customerId: userId,
                    ),
                  ),
                );
              }
            }
          },
        );
      } 
      else if (isOfflineSelected) {
        return CustomButton(
          buttonText: 'Submit'.tr,
          onPressed: () {
            if (_amountController.text.isEmpty) {
              showCustomSnackBar('input_field_is_empty'.tr);
            } else {
              int _amount = int.parse(_amountController.text.trim());
              final SharedPreferences sharedPreferences = Get.find();
              String userId = sharedPreferences.get(AppConstants.USER_Id) ?? "";
              if (userId.isNotEmpty) {
                 walletController.getUserDetails();
               
               if (isOfflineSelected) {
                  Get.offNamed(RouteHelper.getOrderSuccessRoute(orderId, 'success', amount, is_saved));

            } 
              }
            }
          },
        );
      } 
    else {
        return Container(); 
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }
  },
),
//  GetBuilder<WalletController>(
//             builder: (walletController) {
//               return !walletController.isLoading ? 
            
//               CustomButton(
//                   buttonText: 'Transfer'.tr,
//                   onPressed: () {
//                     if(_amountController.text.isEmpty) {
//                       showCustomSnackBar('input_field_is_empty'.tr);
//                     }else{
//                       int _amount = int.parse(_amountController.text.trim());
//                       final SharedPreferences sharedPreferences=Get.find();
//                       String userId=sharedPreferences.get(AppConstants.USER_Id)??"";
//                       if(userId.isNotEmpty)
//                         {
//                           //walletController.getUserDetails();

//                           Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                               ChargeWalletScreen(
//                                 amount:_amount.toString() ,
//                                 customerId: userId,
//                               ),
//                           ));
//                         }
//                       else{
//                         print(userId);
//                         walletController.getUserDetails();
//                         Future.delayed(Duration(seconds: 2)).then((value)  {
//                         String userId=sharedPreferences.get(AppConstants.USER_Id)??"";
//                             print(userId);
//                             if(userId.isNotEmpty)
//                               {
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                                     ChargeWalletScreen(
//                                       amount:_amount.toString() ,
//                                       customerId: userId,
//                                     ),
//                                 ));
//                               }
//                         });

//                       }


//                     }
//                 },
//               ) : Center(child: CircularProgressIndicator());
//             }
//           ),
        ]),
      ),
    );
  }
}
