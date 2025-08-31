import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/features/data/model/hive_task.dart';
import 'package:todo_app/features/data/repository/notify_repo/notification_repository.dart';
import 'package:todo_app/features/data/repository/task_repository.dart';
import 'package:todo_app/features/data/repository/theme_repository.dart';
import 'package:todo_app/features/notifications/cubit/notification_cubit.dart';
import 'package:todo_app/features/theme/app_theme.dart';
import 'package:todo_app/features/theme/bloc/theme_bloc.dart';
import 'package:todo_app/presentation/bloc/todo_bloc.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/presentation/screens/home_screen_changes/cubit/highlight_cubit.dart';
import 'package:todo_app/presentation/screens/home_screen_changes/cubit/visibility_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Hive
  await Hive.initFlutter();

  //Registering Hive
  if (!Hive.isAdapterRegistered(HiveTaskAdapter().typeId)) {
    Hive.registerAdapter(HiveTaskAdapter());
  }

  //open Hive box
  await Hive.openBox<HiveTask>('tasksBox');

  //open theme hive box
  await Hive.openBox('settingsBox');

  //Initialize time zones
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  //Repositories
  final repo = TaskRepository();
  final themeRepo = ThemeRepository();
  final notificationRepo = NotificationRepositoryImpl();

  //init notifications
  await notificationRepo.init();
  await notificationRepo.requestPermission();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TodoBloc(repo)..add(TodoLoadTasksEvent())),
        BlocProvider(create: (_) => ThemeBloc(themeRepo)),
        BlocProvider(
          create: (context) => NotificationCubit(notificationRepo)..init(),
        ),
        BlocProvider(create: (context) => BottomBarCubit()),
        BlocProvider(create: (context) => HighlightCubit()),
      ],
      child: const MyApp(),
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
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
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
            theme: CustomAppTheme.lightTheme,
            darkTheme: CustomAppTheme.darkTheme,
            themeMode: state.themeMode,
            themeAnimationStyle: AnimationStyle(
              curve: Curves.easeInOutQuart,
              reverseCurve: Curves.bounceInOut,
            ),
          ),
        );
      },
    );
  }
}
