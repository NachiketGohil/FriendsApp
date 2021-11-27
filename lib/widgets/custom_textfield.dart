import 'package:flutter/material.dart';
import 'package:friends_app/constant.dart';

class CustomTextfield extends StatelessWidget {
  final String? cuLabelText;
  //final ValueChanged<String> cuOnChanged;
  final TextEditingController? textController;
  final TextCapitalization cuTextCapitalization;
  final TextInputType? cuKeyboardType;
  final TextInputAction? cuTextInputAction;

  CustomTextfield({
    Key? key,
    required this.cuLabelText,
    required this.textController,
    required this.cuTextCapitalization,
    this.cuKeyboardType,
    this.cuTextInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        autofocus: true,
        autocorrect: true,
        keyboardType: cuKeyboardType,
        textCapitalization: cuTextCapitalization,
        textInputAction: cuTextInputAction,
        //onChanged: cuOnChanged,
        controller: textController,
        decoration: InputDecoration(
          labelText: cuLabelText,
          isDense: true,
          contentPadding: const EdgeInsets.all(13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }
}
