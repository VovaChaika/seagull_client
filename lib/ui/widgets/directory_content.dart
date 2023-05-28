import 'package:filesize/filesize.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seagull_client/bloc/files_cubit/files_cubit.dart';
import 'package:seagull_client/ui/widgets/loader.dart';
import 'package:seagull_client/ui/widgets/upload_float_button.dart';

import '../../bloc/network_cubit/network_cubit.dart';
import '../../data/models/file_metadata.dart';

class DirectoryContent extends StatelessWidget {
  final String folderPath;

  const DirectoryContent({Key? key, this.folderPath = '/'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilesCubit, FilesState>(
      builder: (context, state) {
        if (state is FilesLoadingState) {
          return Center(child: Loader(color: Theme.of(context).primaryColor));
        }
        return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: UploadFloatButton(folderPath: folderPath),
            appBar: AppBar(
              title: Text((folderPath == '/') ? "Home" : folderPath),
            ),
            body: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                children: state.folderSet
                        .map((String folderName) =>
                            buildFolderTile(context, folderName))
                        .toList() +
                    state.fileList
                        .map((FileMetadata fileMetadata) =>
                            buildFileTile(context, fileMetadata))
                        .toList()));
      },
    );
  }

  Widget buildFileTile(BuildContext context, FileMetadata fileMetadata) {
    return Dismissible(
        confirmDismiss: (_) async {
          return BlocProvider.of<NetworkCubit>(context).state is NetworkExists;
        },
        background: Container(
            color: Colors.red,
            child: Row(
              children: const [
                SizedBox(width: 25),
                Icon(Icons.delete_forever),
              ],
            )),
        direction: DismissDirection.startToEnd,
        key: UniqueKey(),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade500,
            ),
          )),
          child: ListTile(
              leading: const Icon(Icons.file_copy),
              subtitle: Text(filesize(fileMetadata.fileSize)),
              title: Text(fileMetadata.filename),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(fileMetadata.lastModified),
                  const SizedBox(width: 25),
                  BlocBuilder<NetworkCubit, NetworkState>(
                    builder: (context, state) {
                      if (state is NoNetwork) {
                        return const Icon(Icons.wifi_off);
                      }
                      return IconButton(
                          onPressed: () {
                            Future<String?> pickedFolderPath =
                                FilePicker.platform.getDirectoryPath();
                            BlocProvider.of<FilesCubit>(context)
                                .downloadFile(fileMetadata, pickedFolderPath);
                          },
                          icon: const Icon(Icons.download));
                    },
                  ),
                ],
              )),
        ),
        onDismissed: (direction) =>
            BlocProvider.of<FilesCubit>(context).removeFile(fileMetadata));
  }

  Widget buildFolderTile(BuildContext context, String folderName) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade500,
        ),
      )),
      child: ListTile(
        onTap: () {
          Navigator.push(
              // Navigate to a nested screen with params
              context, MaterialPageRoute(builder: (_) {
            BlocProvider.of<FilesCubit>(context)
                .showAllFilesInFolder(folderPath: '$folderPath$folderName');
            return BlocProvider<FilesCubit>.value(
              value: BlocProvider.of<FilesCubit>(context),
              child: DirectoryContent(folderPath: '$folderPath$folderName'),
            );
          })).then((_) => BlocProvider.of<FilesCubit>(context)
              .showAllFilesInFolder(folderPath: folderPath));
        },
        leading: const Icon(Icons.folder),
        title: Text(folderName),
      ),
    );
  }
}
