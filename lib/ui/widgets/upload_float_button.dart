import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seagull_client/bloc/auth_cubit/auth_cubit.dart';
import 'package:seagull_client/bloc/files_cubit/files_cubit.dart';

import '../../bloc/file_form_cubit/file_form_cubit.dart';
import '../../bloc/network_cubit/network_cubit.dart';
import '../../data/repositories/files_repository.dart';
import '../../locator.dart';
import 'file_modal_form.dart';

class UploadFloatButton extends StatelessWidget {
  final String folderPath;

  const UploadFloatButton({Key? key, required this.folderPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, state) {
        if (state is NoNetwork) {
          return const FloatingActionButton(
            onPressed: null,
            backgroundColor: Colors.red,
            child: Icon(Icons.wifi_off),
          );
        }
        return FloatingActionButton(
            child: const Icon(Icons.upload_file),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => BlocProvider<FileFormCubit>(
                        create: (context) => FileFormCubit(
                          BlocProvider.of<AuthCubit>(context),
                          locator<FilesRepository>(),
                        ),
                        child: FileModalForm(folderPath: folderPath),
                      )).then((fileMetadata) {
                if (fileMetadata != null) {
                  BlocProvider.of<FilesCubit>(context)
                      .showAllFilesInFolder(folderPath: folderPath);
                }
              });
            });
      },
    );
  }
}
