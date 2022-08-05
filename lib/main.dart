import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoApp/layout/home_layout.dart';
import 'package:todoApp/shared/components/bloc_observer.dart';

void main() {
  runApp(
    MyApp(),
  );
  BlocOverrides.runZoned(
    () {},
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      home: HomeLayout(),
    );
  }
}
