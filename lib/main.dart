import 'package:chair_inspector/business%20logic/cubit/sqflite_cubit.dart';
import 'package:chair_inspector/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'presentation/screens/home_screen.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SqfliteCubit()..createDataBase(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[100],
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
              ),
              centerTitle: true),
          
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.blue[400]),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
