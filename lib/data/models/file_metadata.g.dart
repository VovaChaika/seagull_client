// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_metadata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileMetadataAdapter extends TypeAdapter<FileMetadata> {
  @override
  final int typeId = 0;

  @override
  FileMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FileMetadata(
      objectId: fields[0] as String,
      fileSize: fields[1] as int,
      fileType: fields[2] as String,
      filename: fields[3] as String,
      folderPath: fields[4] as String,
      lastModified: fields[5] as String,
      owner: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FileMetadata obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.fileSize)
      ..writeByte(2)
      ..write(obj.fileType)
      ..writeByte(3)
      ..write(obj.filename)
      ..writeByte(4)
      ..write(obj.folderPath)
      ..writeByte(5)
      ..write(obj.lastModified)
      ..writeByte(6)
      ..write(obj.owner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
