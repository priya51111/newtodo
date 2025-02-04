import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newtodo/bloc_observer.dart';
import 'package:newtodo/landing_page.dart';

import 'package:newtodo/menu/home_page.dart';

import 'package:newtodo/menu/bloc/menu_bloc.dart';
import 'package:newtodo/menu/bloc/menu_event.dart';
import 'package:newtodo/menu/repo/repositiry.dart';
import 'package:newtodo/settings.dart';
import 'package:newtodo/tasklist_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:newtodo/signin/bloc/signin_bloc.dart';
import 'package:newtodo/signin/login_page.dart';
import 'package:newtodo/signin/logout_page.dart';
import 'package:newtodo/signin/repository/signin_repository.dart';
import 'package:newtodo/signin/signin_page.dart';
import 'package:go_router/go_router.dart';
import 'package:newtodo/task/repo/repository.dart';
import 'package:newtodo/task/task_page.dart';
import 'task/bloc/task_bloc.dart';
import 'task/bloc/task_event.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  Bloc.observer = const AppBlocObserver();
  void _initializeNotificationHandler(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    BuildContext context,
  ) {
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        navigatorKey.currentState?.pushNamed('/home');
      },
    );
  }

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = GetStorage();
  final GoRouter _router = GoRouter(
    initialLocation: '/signin',  
    routes: [
       GoRoute(
      path: '/LandingPage',
      builder: (context, state) => LandingPage(),
    ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => SigninPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const  Homepage(),

      

      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/logout',
        builder: (context, state) => LogoutPage(),
      ),
      GoRoute(
        path: '/taskpage',
        builder: (context, state) => TaskPage(),
      ),
      GoRoute(
        path: '/setting',
        builder: (context, state) => settings(),
      ),
      GoRoute(path: '/tasklist', builder: (context, state) => TaskList())
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
 
    return MultiBlocProvider(
      providers:[     
        BlocProvider(
          create: (context) => SigninBloc(SigninRepository: SigninRepository()),
        ),
        BlocProvider(
            create: (_) => MenuBloc(menuRepository: MenuRepository())..add(FetchMenu( userId: box.read('userId') ,
      date: box.read('menuDate') ,))
              ),
                      BlocProvider(
            create: (_) => TaskBloc(taskRepository: TaskRepository())..add(FetchTask(
      userId: box.read('userId') ,
      date: box.read('taskDate') ,
    )),
              ),
 
 


      ],
      child: MaterialApp.router(
        routerConfig: _router,
       
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,

      ),
    );
  }
}
