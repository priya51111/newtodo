import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:newtodo/menu/home_page.dart';
import 'package:newtodo/signin/bloc/signin_bloc.dart';

import 'package:newtodo/signin/bloc/signin_state.dart';
import 'package:newtodo/signin/repository/signin_repository.dart';
import 'package:newtodo/signin/signin_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    // Providing SigninBloc at a higher level in the widget tree
    return BlocProvider(
      create: (context) => SigninBloc(SigninRepository: SigninRepository()),
      child: BlocListener<SigninBloc, SigninState>(
        listener: (context, state) {
          if (state.status == SigninStatus.error) {
            Fluttertoast.showToast(
              msg: 'Error in creating user',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          } else if (state.status == SigninStatus.loaded) {
            Fluttertoast.showToast(
              msg: 'User created successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            GoRouter.of(context).go('/home');
          } 
        },
        child: BlocBuilder<SigninBloc, SigninState>(
          builder: (context, state) {
            if (state.status == SigninStatus.loading) {
              return const Scaffold(
                backgroundColor: Color(0xFF0A345B),
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state.status == SigninStatus.loaded) {
              return const Homepage(); 
            }  else {
              return const SigninPage();
            }
          },
        ),
      ),
    );
  }
}
