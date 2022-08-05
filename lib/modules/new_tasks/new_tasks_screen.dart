import 'package:flutter/material.dart';
import 'package:todoApp/shared/components/component.dart';
import 'package:todoApp/shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasksList[index]),
        separatorBuilder: (contesxt, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
        itemCount: tasksList.length);
  }
}
