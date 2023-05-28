import 'package:bloc/bloc.dart';
import '../../data/repositories/dark_mode_repository.dart';

class DarkModeCubit extends Cubit<bool> {
  late final DarkModeRepository _darkModeRepository;

  DarkModeCubit(this._darkModeRepository, bool initDarkMode)
      : super(initDarkMode);

  void toggleDarkMode(bool value) {
    emit(value);
    _darkModeRepository.saveDarkMode(value);
  }
}
