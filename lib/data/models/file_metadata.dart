import 'package:hive/hive.dart';

part 'file_metadata.g.dart';

@HiveType(typeId: 0)
class FileMetadata {

  @HiveField(0)
  late String objectId;
  @HiveField(1)
  late int fileSize;
  @HiveField(2)
  late String fileType;
  @HiveField(3)
  late String filename;
  @HiveField(4)
  late String folderPath;
  @HiveField(5)
  late String lastModified;
  @HiveField(6)
  late String owner;

  FileMetadata(
      {required this.objectId,
      required this.fileSize,
      required this.fileType,
      required this.filename,
      required this.folderPath,
      required this.lastModified,
      required this.owner});

  FileMetadata.fromJson(Map<String, dynamic> json) {
    objectId = json['_id'];
    fileSize = json['file_size'];
    fileType = json['file_type'];
    filename = json['filename'];
    folderPath = json['folder_path'];
    lastModified = json['last_modified'];
    owner = json['owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = objectId;
    data['file_size'] = fileSize;
    data['file_type'] = fileType;
    data['filename'] = filename;
    data['folder_path'] = folderPath;
    data['last_modified'] = lastModified;
    data['owner'] = owner;
    return data;
  }
}
