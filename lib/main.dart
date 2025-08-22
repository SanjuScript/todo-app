import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/features/data/model/hive_task.dart';
import 'package:todo_app/features/data/repository/task_repository.dart';
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

  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = TaskRepository();
    return MultiBlocProvider(
      providers: [
        
        BlocProvider(create: (_) => TodoBloc(repo)..add(TodoLoadTasksEvent())),
      ],
      child: MaterialApp(home: HomeScreen()),
    );
  }
}
