import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/file_form_cubit/file_form_cubit.dart';

class FileModalForm extends StatefulWidget {
  final String folderPath;

  const FileModalForm({Key? key, required this.folderPath}) : super(key: key);

  @override
  State<FileModalForm> createState() => _FileModalFormState();
}

class _FileModalFormState extends State<FileModalForm> {
  late final TextEditingController _folderPathController;

  @override
  void initState() {
    _folderPathController = TextEditingController();
    _folderPathController.addListener(() => setState(() =>
        BlocProvider.of<FileFormCubit>(context)
            .updateFolderPath(_folderPathController.text)));
    _folderPathController.text = widget.folderPath;

    super.initState();
  }

  @override
  void dispose() {
    _folderPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileFormCubit, FileFormState>(
      builder: (context, state) {
        return AlertDialog(
          title: const Text('Upload a file'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                      child: const Text("Choose a file"),
                      onPressed: () {
                        Future<FilePickerResult?> result = FilePicker.platform
                            .pickFiles(dialogTitle: "Pick a file");
                        BlocProvider.of<FileFormCubit>(context)
                            .updateFile(result);
                      }),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 150,
                    child: Text(
                      state.fileError.isNotEmpty
                          ? state.fileError
                          : state.file!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: state.fileError.isEmpty
                              ? Theme.of(context).focusColor
                              : Colors.redAccent),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _folderPathController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Folder path",
                    errorText: state.folderPathError.isEmpty
                        ? null
                        : state.folderPathError),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: state.isValid()
                  ? () => Navigator.pop(
                        context,
                        BlocProvider.of<FileFormCubit>(context).submit(), //FileMetadata result
                      )
                  : null,
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }
}
