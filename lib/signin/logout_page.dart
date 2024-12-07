import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newtodo/signin/bloc/signin_bloc.dart';
import 'package:newtodo/signin/bloc/signin_event.dart';

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Do you really want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<SigninBloc>(context).add(LogoutUser());

                Navigator.of(context).pop();
                context.go('/signin');
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _confirmLogout(context),
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
