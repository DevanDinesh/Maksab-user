import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/screens/auth/widget/registration_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SuccessWidget extends StatelessWidget {
  const SuccessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return Center(
          child: Container(
            width: Dimensions.WEB_MAX_WIDTH,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

              authController.businessIndex == 1 ? RegistrationStepperWidget(status: authController.businessPlanStatus) : SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              SizedBox(height: context.height * 0.2),

              Image.asset(Images.checked, height: 90,width: 90),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Text('congratulations'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              Text(
                'your_registration_has_been_completed_successfully'.tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center, softWrap: true,
              ),

            ]),
          ),
        );
      }
    );
  }
}
