import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seagull_client/ui/tabs/settings_tab.dart';

import '../../bloc/auth_cubit/auth_cubit.dart';
import '../tabs/directory_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [];

  late final List<Widget> innerRoutes;

  @override
  void initState() {
    innerRoutes = [
      // Nested routes
      InnerRoute(widget: const DirectoryTab(), _navigatorKeys),
      InnerRoute(widget: const SettingsTab(), _navigatorKeys),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigatorKeys[_selectedIndex]
            .currentState!
            .maybePop(); // Pop of nested
        return false;
      },
      child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthInitialState) {
              Navigator.pushReplacementNamed(
                  context, "/login"); //return to login
            }
          },
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.folder), label: "Directories"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings"),
                ],
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
            body: IndexedStack(
                //a good idea
                index: _selectedIndex,
                children: innerRoutes),
          )),
    );
  }
}

class InnerRoute extends StatelessWidget {
  // Creates nested routing
  final Widget widget;

  final GlobalKey<NavigatorState> globalKey = GlobalKey(); // Unique Global Keys

  InnerRoute(List<GlobalKey> navigatorKeys, {super.key, required this.widget}) {
    navigatorKeys.add(globalKey);
  }

  @override
  Widget build(BuildContext context) => Navigator(
      //Nested Navigator
      key: globalKey,
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
          settings: settings, builder: (BuildContext context) => widget));
}
