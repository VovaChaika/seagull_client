import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/file_metadata.dart';
import '../../data/repositories/files_repository.dart';
import '../auth_cubit/auth_cubit.dart';
import '../network_cubit/network_cubit.dart';

part 'files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  final FilesRepository _filesRepository;
  final AuthCubit _authCubit;
  final NetworkCubit _networkCubit;

  FilesCubit(this._authCubit, this._filesRepository, this._networkCubit)
      : super(FilesLoadingState()) {
    showAllFilesInFolder();
  }

  void showAllFilesInFolder({
    String folderPath = "/",
  }) async {
    final RegExp folderRegex = RegExp('$folderPath(\\w+/)');

    Iterable<FileMetadata>? fileMetadataList;
    try {
      fileMetadataList = await _filesRepository.showAllFiles(_networkCubit.state is NetworkExists);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        _authCubit.logoutBecause("Reauthorization is required");
        return;
      }
    }

    final List<FileMetadata> fileList = [];
    final Set<String> folderSet = {};

    for (int i = 0; i < fileMetadataList!.length; i++) {
      FileMetadata file = fileMetadataList.elementAt(i);
      if (file.folderPath == folderPath) {
        fileList.add(file);
        continue;
      }
      if (folderRegex.firstMatch(file.folderPath) != null) {
        folderSet.add(folderRegex.firstMatch(file.folderPath)!.group(1)!);
      }
    }

    emit(FilesLoaded(folderSet: folderSet, fileList: fileList));
  }

  void removeFile(FileMetadata fileMetadata) async {
    await _filesRepository.deleteFile(fileMetadata.objectId);
    // Dismissible
  }

  void downloadFile(
      FileMetadata fileMetadata, Future<String?> saveDirectory) async {
    final String? directory = await saveDirectory;
    if (directory == null) {
      return;
    }
    await _filesRepository.downloadFile(fileMetadata, directory);
  }
}
