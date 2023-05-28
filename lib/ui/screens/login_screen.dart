import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_cubit/auth_cubit.dart';
import '../../data/models/user.dart';
import '../widgets/animated_linear_gradient.dart';
import '../widgets/loader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<AuthCubit>(context).tryAutoLogin();
    super.initState();
    usernameController.addListener(() {});
    passwordController.addListener(() {});
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedLinearGradient(
            child: Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            // Consumer
            listener: (context, state) {
              // Listens
              if (state is AuthErrorState) {
                buildAuthErrorMessage(context, state.message!); // SnackBar
                passwordController.clear();
                return;
              }
              if (state is AuthSuccessState) {
                Navigator.of(context).pushReplacementNamed('/home');
                return;
              }
            },
            builder: (context, state) {
              // Builds
              if (state is AuthLoadingState || state is AuthSuccessState) {
                return const Loader(color: Colors.white);
              }
              return buildInitialLogin(context);
            },
          ),
        )),
      ),
    );
  }

  Widget buildInitialLogin(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock,
            size: 100, color: Theme.of(context).scaffoldBackgroundColor),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child:

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300
            ),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                border: InputBorder.none,
                labelText: 'Username',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300
            ),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                border: InputBorder.none,
                labelText: 'Password',
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
          onPressed: () {
            // Sends LoginEvent
            BlocProvider.of<AuthCubit>(context)
                .login(User(usernameController.text, passwordController.text));
          },
          child: Text("Log In",
              style:
                  TextStyle(fontSize: 18, color: Theme.of(context).focusColor)),
        )
      ],
    );
  }

  ScaffoldFeatureController buildAuthErrorMessage(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
