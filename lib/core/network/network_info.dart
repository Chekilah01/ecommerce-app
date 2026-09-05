import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo({
    Connectivity? connectivity,
  }) : _connectivity = connectivity ?? Connectivity();

  Future<bool> get isConnected async {
    final connectivityResults =
        await _connectivity.checkConnectivity();

    if (connectivityResults.contains(ConnectivityResult.none)) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(
        const Duration(seconds: 3),
      );

      return result.isNotEmpty &&
          result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}