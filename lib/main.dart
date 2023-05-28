import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:seagull_client/data/apis/files_api.dart';
import 'package:seagull_client/data/repositories/token_repository.dart';
import 'package:seagull_client/ui/app_theme.dart';
import 'package:seagull_client/ui/screens/home_screen.dart';
import 'package:seagull_client/ui/screens/login_screen.dart';

import 'bloc/auth_cubit/auth_cubit.dart';
import 'bloc/dark_mode_cubit/dark_mode_cubit.dart';
import 'bloc/files_cubit/files_cubit.dart';
import 'bloc/network_cubit/network_cubit.dart';
import 'data/repositories/dark_mode_repository.dart';
import 'locator.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  await setupLocator();
  final bool initDarkMode = await locator<DarkModeRepository>().getDarkMode();
  runApp(MyApp(initDarkMode));
}

class MyApp extends StatelessWidget {
  final bool initDarkMode;

  const MyApp(this.initDarkMode, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetworkCubit>.value(value: locator<NetworkCubit>()),
        BlocProvider<DarkModeCubit>(
          create: (context) =>
              DarkModeCubit(locator<DarkModeRepository>(), initDarkMode),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(locator<TokenRepository>()),
        ),
      ],
      child: BlocBuilder<DarkModeCubit, bool>(builder: buildAppWithTheme),
    );
  }

  MaterialApp buildAppWithTheme(BuildContext context, bool state) {
    return MaterialApp(
      // darkMode is built
      debugShowCheckedModeBanner: false,
      theme: appThemes[state],
      initialRoute: '/login', // named routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        // global named routes
      },
    );
  }
}
