import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoApp/shared/components/component.dart';
import 'package:todoApp/shared/cubit/cubit.dart';
import 'package:todoApp/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isSheetOpened) {
                  if (formKey.currentState?.validate() == true) {
                    cubit.addNewTask(
                      taskTitle: titleController.text,
                      taskTime: timeController.text,
                      taskDate: dateController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          (context) => Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(20.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultTextFormField(
                                        controller: titleController,
                                        inputType: TextInputType.text,
                                        validator: (newValue) {
                                          if (newValue?.isEmpty == true) {
                                            return 'title must not be empty';
                                          }
                                          return null;
                                        },
                                        hintText: 'Task Name',
                                        prefixIcon: Icon(Icons.title),
                                      ),
                                      SizedBox(height: 15.0),
                                      defaultTextFormField(
                                        focusInTouchMode: true,
                                        controller: timeController,
                                        inputType: TextInputType.datetime,
                                        validator: (newValue) {
                                          if (newValue?.isEmpty == true) {
                                            return 'time must not be empty';
                                          }
                                          return null;
                                        },
                                        hintText: 'Task Time',
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                      ),
                                      SizedBox(height: 15.0),
                                      defaultTextFormField(
                                        focusInTouchMode: true,
                                        controller: dateController,
                                        inputType: TextInputType.datetime,
                                        validator: (newValue) {
                                          if (newValue?.isEmpty == true) {
                                            return 'date must not be empty';
                                          }
                                          return null;
                                        },
                                        hintText: 'Task Date',
                                        prefixIcon: Icon(Icons.calendar_today),
                                        onTap: () {
                                          print("date picker clicked");
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2201))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 15.0)
                      .closed
                      .then((value) => _closeSheet(cubit));
                  cubit.changeBottomSheetState(true, Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              elevation: 20.0,
              items: [
                BottomNavigationBarItem(
                  label: 'home',
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: 'Done',
                  icon: Icon(Icons.check_circle_outline),
                ),
                BottomNavigationBarItem(
                  label: 'Archived',
                  icon: Icon(Icons.archive),
                ),
              ],
              onTap: (index) {
                cubit.updateBottomBarIndex(index);
              },
            ),
            body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator())),
          );
        },
      ),
    );
  }

  void _closeSheet(AppCubit cubit) {
    cubit.changeBottomSheetState(false, Icons.edit);
  }
}
