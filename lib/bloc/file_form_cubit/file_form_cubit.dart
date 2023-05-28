import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/file_metadata.dart';
import '../../data/repositories/files_repository.dart';
import '../auth_cubit/auth_cubit.dart';

part 'file_form_state.dart';

class FileFormCubit extends Cubit<FileFormState> {
  final FilesRepository _filesRepository;
  final AuthCubit _authCubit;
  final RegExp folderRegex = RegExp(r"^/(\w+/)*$");

  FileFormCubit(this._authCubit, this._filesRepository)
      : super(const FileFormState(fileError: "Pick a file"));

  void updateFile(Future<FilePickerResult?> futureResult) async {
    FilePickerResult? result = await futureResult;
    if (result == null) {
      return;
    }
    PlatformFile file = result.files[0];
    emit(state.copyWith(file: file, fileError: ''));
  }

  void updateFolderPath(String text) {
    String error = '';
    if (text.isEmpty) {
      error = "Folder path is required";
    } else if (!folderRegex.hasMatch(text)) {
      error = "It's not a valid folder path";
    }
    emit(state.copyWith(folderPath: text, folderPathError: error));
  }

  Future<FileMetadata?> submit() async {
    try {
      return _filesRepository.uploadFile(state.folderPath!, state.file!);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        _authCubit.logoutBecause("Reauthorization is required");
      }
    }
    return null;
  }
}
