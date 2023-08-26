import 'package:cityvista/pages/register/sms_code_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cityvista/other/constants.dart';
import 'package:cityvista/other/authentication.dart';
import 'package:cityvista/widgets/custom_text_field.dart';
import 'package:cityvista/bloc/register/register_bloc.dart';
import 'package:cityvista/other/region.dart';
import 'package:cityvista/other/utils.dart';
import 'package:flutter/services.dart';
import 'package:cityvista/injection_container.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:get/get.dart';

class PhoneNumberPage extends StatelessWidget {
  final Region region = Region();
  final RegisterBloc bloc = sl<RegisterBloc>();

  final TextEditingController controller = TextEditingController();

  PhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    String dialCode = region.getDialCode(context);
    controller.text = dialCode;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Phone Number",
                        style: TextStyle(
                          color: kTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 25
                        )
                      ),
                      CustomTextField(
                        controller: controller,
                        hintText: dialCode,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          PhoneInputFormatter(allowEndlessPhone: false)
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      bloc.add(RegisterValidateNumber(value: controller.text));
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(kTextColor),
                    ),
                    child: BlocBuilder(
                      bloc: bloc,
                      builder: (BuildContext context, state) {
                        if (state is RegisterCheckingPhone) {
                          return const Center(child: CupertinoActivityIndicator());
                        } else if (state is RegisterPhoneEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Utils.alertPopup(false, "Please enter a phone number!");
                          });
                        } else if (state is RegisterPhoneInvalid) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Utils.alertPopup(false, "Please enter a valid phone number!");
                          });
                        } else if (state is RegisterPhoneValid) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            try {
                              Authentication.instance.sendSMS(controller.text);
                              Get.to(() => const SmsCodePage());
                            } on Exception catch (e) {
                              Utils.alertPopup(
                                false,
                                "Unknown error! Please contact the developers\n${e.toString()}"
                              );
                            }
                          });
                        }

                        return const Text(
                          "Register / Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700
                          )
                        );
                      }
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}