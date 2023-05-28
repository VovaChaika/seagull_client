part of 'files_cubit.dart';

@immutable
abstract class FilesState extends Equatable {
  final List<FileMetadata> fileList;
  final Set<String> folderSet;

  const FilesState({
    required this.fileList,
    required this.folderSet,
  });

  FilesState copyWith({
    List<FileMetadata>? fileList,
    Set<String>? folderSet,
  });

  @override
  List<Object> get props => [ fileList, folderSet];
}

class FilesLoadingState extends FilesState {
  FilesLoadingState() : super( fileList: [], folderSet: {});

  @override
  FilesState copyWith({
    List<FileMetadata>? fileList,
    Set<String>? folderSet,
  }) {
    return FilesLoadingState();
  }
}

class FilesLoaded extends FilesState {
  const FilesLoaded({
    required super.fileList,
    required super.folderSet,
  });

  @override
  FilesState copyWith({
    List<FileMetadata>? fileList,
    Set<String>? folderSet,
  }) {
    return FilesLoaded(
      fileList: fileList ?? this.fileList,
      folderSet: folderSet ?? this.folderSet,
    );
  }
}
