import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:hive/hive.dart';
import 'package:seagull_client/data/models/file_metadata.dart';

import '../apis/files_api.dart';

class FilesRepository {
  final FilesApi _filesApi;
  final Box<FileMetadata> fileMetaDataBox;

  FilesRepository(this.fileMetaDataBox, this._filesApi);

  Future<Iterable<FileMetadata>> showAllFiles(bool isNetwork) async {
    if (isNetwork) {
      await fileMetaDataBox.clear();
      for (FileMetadata fileMetadata in (await _filesApi.showFiles())) {
        fileMetaDataBox.put(fileMetadata.objectId, fileMetadata);
      }
    }
    return fileMetaDataBox.values;
  }

  Future<int> deleteFile(String objectId) async {
    final Future<int> deletedCount = _filesApi.deleteFile(objectId);
    fileMetaDataBox.delete(objectId);
    return await deletedCount;
  }

  Future<FileMetadata> uploadFile(String folderPath, PlatformFile file) async {
    FileMetadata fileMetadata = await _filesApi.uploadFile(folderPath, file);
    fileMetaDataBox.add(fileMetadata);
    return fileMetadata;
  }

  Future<bool> downloadFile(
      FileMetadata fileMetadata, String saveDirectory) async {
    return _filesApi.downloadFile(fileMetadata, saveDirectory);
  }
}
