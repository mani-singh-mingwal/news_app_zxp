import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_zxp/bloc/internet_cubit/internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  late StreamSubscription connectionStreamSubscription;
  final Connectivity connectivity;

  InternetCubit(InternetState initialState, {required this.connectivity})
      : super(InternetLoading()) {
    connectionStreamSubscription = monitorInternetConnection();
  }

  void emitInternetConnected() => emit(InternetConnected());

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectionStreamSubscription.cancel();
    return super.close();
  }

  StreamSubscription<ConnectivityResult> monitorInternetConnection() {
    return connectivity.onConnectivityChanged.listen((internetState) {
      if (internetState == ConnectivityResult.mobile ||
          internetState == ConnectivityResult.wifi) {
        emitInternetConnected();
      } else if (internetState == ConnectivityResult.none) {
        emitInternetDisconnected();
      }
    });
  }
}
