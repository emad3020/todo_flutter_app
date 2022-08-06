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
        return tasksBuilder(tasksList: AppCubit.get(context).newTasksList);
      },
    );
  }
}
