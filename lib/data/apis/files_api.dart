import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../dio_client.dart';
import '../models/file_metadata.dart';

class FilesApi {
  final DioClient _dioClient;
  final String _filesUrl = "/files";

  FilesApi(this._dioClient);

  Future<List<FileMetadata>> showFiles() async {
    try {
      final Response response = await _dioClient.dio.get("$_filesUrl/view");
      return (response.data as List)
          .map((json) => FileMetadata.fromJson(json))
          .toList();
    } on DioError catch (e, s) {
      rethrow;
    }
  }

  Future<int> deleteFile(String objectId) async {
    try {
      FormData formData = FormData.fromMap({"object_id": objectId});
      final Response response =
          await _dioClient.dio.delete(_filesUrl, data: formData);
      return response.data["deleted_count"];
    } catch (e) {
      rethrow;
    }
  }

  Future<FileMetadata> uploadFile(String folderPath, PlatformFile file) async {
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromFileSync(
        file.path!,
        filename: file.name,
      ),
      'folder_path': folderPath
    });
    try {
      final Response response =
          await _dioClient.dio.post(_filesUrl, data: formData);
      return FileMetadata.fromJson(response.data);
    } on DioError catch (e, s) {
      rethrow;
    }
  }

  Future<bool> downloadFile(
      FileMetadata fileMetadata, String saveDirectory) async {
    try {
      FormData formData =
          FormData.fromMap({"object_id": fileMetadata.objectId});
      final Response response = await _dioClient.dio.download(
          _filesUrl, "$saveDirectory/${fileMetadata.filename}",
          data: formData);
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
