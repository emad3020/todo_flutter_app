import 'package:flutter/material.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType inputType,
  required FormFieldValidator<String> validator,
  required String hintText,
  bool isPassword = false,
  bool focusInTouchMode = false,
  Widget? prefixIcon,
  IconData? suffixIcon,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onTextChanged,
  Function()? onSuffixPressed,
  Function()? onTap,
}) =>
    TextFormField(
        validator: validator,
        controller: controller,
        readOnly: focusInTouchMode,
        decoration: InputDecoration(
          labelText: hintText,
          border: OutlineInputBorder(),
          prefixIcon: prefixIcon != null ? prefixIcon : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: onSuffixPressed,
                  icon: Icon(suffixIcon),
                )
              : null,
        ),
        keyboardType: inputType,
        obscureText: isPassword,
        onFieldSubmitted: onSubmit,
        onChanged: onTextChanged,
        onTap: onTap);

Widget buildTaskItem(Map model) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              '${model['time']}',
            ),
          ),
          SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ],
      ),
    );
