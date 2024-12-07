import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newtodo/bloc_observer.dart';
import 'package:newtodo/signin/bloc/signin_bloc.dart';
import 'package:newtodo/signin/login_page.dart';
import 'package:newtodo/signin/logout_page.dart';
import 'package:newtodo/signin/repository/signin_repository.dart';
import 'package:newtodo/signin/signin_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: '/signin', // Define your initial route
    routes: [
      GoRoute(
        path: '/signin',
        builder: (context, state) =>const SigninPage(),
      ),
      
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/logout',
        builder: (context, state) => LogoutPage(),
      ),
    ],
  );
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
     MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SigninBloc(SigninRepository: SigninRepository()),
        ),
        // Add other BlocProviders here if needed
      ],
        child:MaterialApp.router(
            routerConfig: _router,

      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
     
    ),
    );
    
    
    
     
  }
}