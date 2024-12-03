import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:newtodo/signin/bloc/signin_bloc.dart';
import 'package:newtodo/signin/bloc/signin_event.dart';
import 'package:newtodo/signin/bloc/signin_state.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController mailIdController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF0A345B),
      body: BlocListener<SigninBloc, SigninState>(
        listener: (context, state) {
          if (state.status == SigninStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'An error occurred')),
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

          } else if (state.status == SigninStatus.loading) {
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 580),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/snows.png"),
                )),
              ),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 110, top: 40),
                  child: Text(
                    'Todo',
                    style: TextStyle(
                        color: Color(0xFFC2C8D4),
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 190, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: Text(
                      'Enter Mail',
                      style: TextStyle(color: Color(0xFFFFF8F8), fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: mailIdController,
                        decoration: InputDecoration(
                            focusColor: const Color.fromARGB(135, 33, 149, 243),
                            fillColor: const Color.fromARGB(135, 33, 149, 243),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(135, 33, 149, 243)),
                            )),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 7),
                    child: Text(
                      'Enter password',
                      style: TextStyle(color: Color(0xFFFFF8F8), fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 58,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            focusColor: const Color.fromARGB(135, 33, 149, 243),
                            fillColor: const Color.fromARGB(135, 33, 149, 243),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(135, 33, 149, 243)),
                            )),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                        height: 50,
                        width: 110,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(135, 33, 149, 243),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {
                              final email = mailIdController.text;

                              final password = passwordController.text;
                              context.read<SigninBloc>().add(LoginUser(
                                  email: email,
                                  password: password ));
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Color(0xFFFFF8F8)),
                            ))),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
