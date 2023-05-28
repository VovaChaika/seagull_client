part of 'file_form_cubit.dart';

class FileFormState extends Equatable {
  final String folderPathError;
  final String fileError;

  final String? folderPath;
  final PlatformFile? file;

  bool isValid() => folderPathError.isEmpty && fileError.isEmpty;

  const FileFormState(
      {this.fileError = '',
      this.folderPathError = '',
      this.folderPath,
      this.file});

  FileFormState copyWith({
    String? folderPathError,
    String? fileError,
    String? folderPath,
    PlatformFile? file,
  }) {
    return FileFormState(
      folderPathError: folderPathError ?? this.folderPathError,
      fileError: fileError ?? this.fileError,
      folderPath: folderPath ?? this.folderPath,
      file: file ?? this.file,
    );
  }

  @override
  List<Object?> get props => [folderPathError, fileError, folderPath, file];
}
