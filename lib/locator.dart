import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:seagull_client/data/apis/files_api.dart';
import 'package:seagull_client/data/models/file_metadata.dart';
import 'package:hive/hive.dart';
import 'bloc/network_cubit/network_cubit.dart';
import 'data/apis/user_api.dart';
import 'data/dio_client.dart';
import 'data/repositories/dark_mode_repository.dart';
import 'data/repositories/files_repository.dart';
import 'data/repositories/token_repository.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<NetworkCubit>(NetworkCubit());
  await Hive.initFlutter();
  Hive.registerAdapter<FileMetadata>(FileMetadataAdapter());
  Box<String> tokenBox = await Hive.openBox<String>('access_token');
  Box<bool> darkModeBox = await Hive.openBox<bool>("dark_mode");
  Box<FileMetadata> fileMetadataBox =
      await Hive.openBox<FileMetadata>("file_metadata_box");

  // GetIt setup
  locator.registerLazySingleton<DioClient>(() => DioClient());

  locator.registerLazySingleton<FilesApi>(() => FilesApi(locator<DioClient>()));

  locator.registerLazySingleton<UserApi>(() => UserApi(locator<DioClient>()));

  locator.registerLazySingleton<FilesRepository>(
      () => FilesRepository(fileMetadataBox, locator<FilesApi>()));

  locator.registerLazySingleton<DarkModeRepository>(
      () => DarkModeRepository(darkModeBox));

  locator.registerLazySingleton<TokenRepository>(
      () => TokenRepository(tokenBox, locator<UserApi>()));
}
