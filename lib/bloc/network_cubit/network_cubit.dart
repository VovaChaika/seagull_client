import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity _connectivity = Connectivity();

  NetworkCubit() : super(NoNetwork()) {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final networkList = [
      ConnectivityResult.ethernet,
      ConnectivityResult.wifi,
      ConnectivityResult.vpn,
      ConnectivityResult.mobile
    ];
    if (networkList.contains(result)) {
      emit(NetworkExists());
      return;
    }
    emit(NoNetwork());
  }
}
