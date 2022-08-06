import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoApp/shared/cubit/cubit.dart';

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

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['_id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteTask(
          id: model['_id'],
        );
      },
      child: Padding(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${model['title']}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 12.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateTaskStatus(
                      newStatus: 'done', taskId: model['_id']);
                },
                icon: Icon(
                  Icons.check_box_outlined,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateTaskStatus(
                      newStatus: 'archive', taskId: model['_id']);
                },
                icon: Icon(
                  Icons.archive_outlined,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );

Widget tasksBuilder({required List<Map> tasksList}) => ConditionalBuilder(
    condition: tasksList.length > 0,
    builder: (context) => ListView.separated(
        itemBuilder: (context, index) =>
            buildTaskItem(tasksList[index], context),
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
        itemCount: tasksList.length),
    fallback: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                size: 100.0,
                color: Colors.grey,
              ),
              Text(
                'No Tasks yet, please add some tasks',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ));
