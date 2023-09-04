import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cityvista/widgets/custom_text_field.dart';
import 'package:cityvista/other/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeTopbar extends StatefulWidget {
  const HomeTopbar({super.key});

  @override
  State<HomeTopbar> createState() => _HomeTopbarState();
}

class _HomeTopbarState extends State<HomeTopbar> {
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool focused = false;

  @override
  void initState() {
    focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    HapticFeedback.lightImpact();
    setState(() {
      focused = !focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        width: MediaQuery.of(context).size.width - 55,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              offset: const Offset(0, 1),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              offset: const Offset(1, 0),
              blurRadius: 8,
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  maxLines: 1,
                  focusNode: focusNode,
                  controller: searchTextController,
                  hintText: " Search something...",
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  contentPadding: 10,
                ),
              ),
              Visibility(
                visible: focused,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: GestureDetector(
                    onTap: () => focusNode.unfocus(),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? Colors.black.withOpacity(.9)
                          : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kTextColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            offset: const Offset(0, 1),
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            offset: const Offset(1, 0),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        CupertinoIcons.xmark,
                        size: 25,
                      ),
                    ),
                  ),
                ).animate().moveX(begin: 40, duration: const Duration(milliseconds: 200))
              )
            ],
          ),
        ),
      ),
    );
  }
}