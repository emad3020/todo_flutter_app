import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoApp/shared/cubit/cubit.dart';
import 'package:todoApp/shared/cubit/states.dart';

import '../../shared/components/component.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasksList = AppCubit.get(context).tasksList;
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
      },
    );
  }
}
