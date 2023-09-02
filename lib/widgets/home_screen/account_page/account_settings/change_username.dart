import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/bloc/username/username_bloc.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/widgets/custom_text_field.dart';
import 'package:cityvista/injection_container.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeUsername extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final UsernameBloc bloc = sl<UsernameBloc>();
  final Widget initialChild = const Text("Ok");

  ChangeUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        bool enabled = true;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  Widget usernameButtonChild = BlocBuilder(
                    bloc: bloc,
                    builder: (BuildContext context, state) {
                      if (state is UsernameLoading) {
                        enabled = false;
                        return const CupertinoActivityIndicator(color: Colors.black);
                      } else if (state is UsernameSetError) {
                        Utils.alertPopup(
                          false,
                          "We couldn't change your username.\n${state.message}"
                        );
                        enabled = true;
                        return initialChild;
                      } else if (state is UsernameSetSuccess) {
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Utils.alertPopup(
                            true,
                            "Your username has been changed to ${controller.text}"
                          );
                        });

                        return initialChild;
                      }

                      return initialChild;
                    },
                  );

                  return AlertDialog(
                    title: const Text("Change Username"),
                    content: CustomTextField(
                      hintText: "Type in an username",
                      controller: controller,
                      keyboardType: TextInputType.text,
                      maxLength: 14,
                    ),
                    actions: [
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (enabled) {
                                  HapticFeedback.lightImpact();
                                  bloc.add(SetUsernameOfUser(username: controller.text));
                                }
                              },
                              child: usernameButtonChild,
                            ),
                          )
                        ],
                      )
                    ],
                  );
                }
              );
            },
            child: const Text("Change Username"),
          ),
        );
      }
    );
  }
}