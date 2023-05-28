import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_cubit/auth_cubit.dart';
import '../../bloc/dark_mode_cubit/dark_mode_cubit.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  void navigate(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute( // NestedScreen
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text("Nested"),
              ),
              body: const Center(child: Text("Nested")))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_box_rounded),
                    title: const Text("Edit profile"),
                    onTap: () => navigate(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text("Notifications and sounds"),
                    onTap: () => navigate(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("Privacy and security"),
                    onTap: () => navigate(context),
                  ),
                ],
              ),
            ),
            Container(
              height: 25,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.chat_bubble),
                    title: const Text("File settings"),
                    onTap: () => navigate(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.folder),
                    title: const Text("Folders settings"),
                    onTap: () => navigate(context),
                  ),
                ],
              ),
            ),
            Container(
              height: 25,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.question_mark),
                    title: const Text("Ask question"),
                    onTap: () => navigate(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.newspaper),
                    title: const Text("Features"),
                    onTap: () => navigate(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat),
                    title: const Text("Seagull FAQ"),
                    onTap: () => navigate(context),
                  ),
                ],
              ),
            ),
            Container(
              height: 25,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      BlocProvider.of<AuthCubit>(context).logout(); // Logout
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text("Log out"),
                  ),
                  BlocBuilder<DarkModeCubit, bool>(
                      builder: (context, state) => SwitchListTile(
                          title: const Text('Dark Mode'), // Builds the tile
                          value: state,
                          onChanged: (value) =>
                  BlocProvider.of<DarkModeCubit>(context)
                      .toggleDarkMode(value))),

                ],
              ),
            )
          ],
        ));
  }
}
