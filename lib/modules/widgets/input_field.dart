import 'package:flutter/material.dart';

class AInputField extends StatelessWidget {
  const AInputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
    this.onTap,
    this.type,
    this.validate,
    this.isClickable = true,
  }) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final Function()? onTap;
  final String? Function(String?)? validate;
  final TextInputType? type;
  final bool isClickable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
              child: Row(
                children: [
                  widget ?? Container(),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: isClickable,
                      validator: validate,
                      keyboardType: type,
                      onTap: onTap,
                      autofocus: false,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w400),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
