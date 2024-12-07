import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newtodo/bloc_observer.dart';

import 'package:newtodo/menu/Homepage.dart';

import 'package:newtodo/menu/bloc/menu_bloc.dart';
import 'package:newtodo/menu/repo/repositiry.dart';

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

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: '/signin',  
    routes: [
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
            create: (_) => MenuBloc(menuRepository: MenuRepository())
              ),
                      BlocProvider(
            create: (_) => TaskBloc(taskRepository: TaskRepository())
              ),
 
 


      ],
      child: MaterialApp.router(
        routerConfig: _router,
       
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,

      ),
      )
    );
    
  }
}
