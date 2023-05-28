import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_cubit/auth_cubit.dart';
import '../../bloc/files_cubit/files_cubit.dart';
import '../../bloc/network_cubit/network_cubit.dart';
import '../../data/repositories/files_repository.dart';
import '../../locator.dart';
import '../widgets/directory_content.dart';

class DirectoryTab extends StatelessWidget {
  const DirectoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FilesCubit>(
        create: (context) => FilesCubit(BlocProvider.of<AuthCubit>(context),
            locator<FilesRepository>(), locator<NetworkCubit>()),
        child: Builder(
          builder: (BuildContext context) => const DirectoryContent(),
        ));
  }
}
