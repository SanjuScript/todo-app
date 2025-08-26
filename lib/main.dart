import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/features/data/model/hive_task.dart';
import 'package:todo_app/features/data/repository/task_repository.dart';
import 'package:todo_app/features/data/repository/theme_repository.dart';
import 'package:todo_app/features/theme/app_theme.dart';
import 'package:todo_app/features/theme/bloc/theme_bloc.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Hive
  await Hive.initFlutter();

  //Registering Hive
  Hive.registerAdapter(HiveTaskAdapter());

  //open Hive box
  await Hive.openBox<HiveTask>('tasksBox');

  //open theme hive box
  await Hive.openBox('settingsBox');

  //Repositories
  final repo = TaskRepository();
  final themeRepo = ThemeRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TodoBloc(repo)..add(TodoLoadTasksEvent())),
        BlocProvider(create: (_) => ThemeBloc(themeRepo)),
      ],
      child:const MyApp(),
    ),
  );


  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        
        return AnimatedTheme(
          data: ThemeData(
            brightness: state.themeMode == ThemeMode.dark
                ? Brightness.dark
                : state.themeMode == ThemeMode.light
                ? Brightness.light
                : MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Brightness.dark
                : Brightness.light,
            useMaterial3: true,
            colorSchemeSeed: Colors.deepPurple,
          ),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,

            home: HomeScreen(),
            theme: CustomAppTheme.lightTheme,
            darkTheme: CustomAppTheme.darkTheme,
            themeMode: state.themeMode,
          ),
        );
      },
    );
  }
}
