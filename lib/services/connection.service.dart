import 'dart:async'; //For StreamController/Stream
import 'dart:io';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/dialog/dialog_helpers.widget.dart';

class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton =
      new ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController =
      new StreamController.broadcast();

  //flutter_connectivity
  // final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  Future<void> initialize() async {
    // _connectivity.onConnectivityChanged.listen();
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  // //flutter_connectivity's listener
  // void _connectionChange(ConnectivityResult result) {
  //   checkConnection();
  // }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    if (!hasConnection) {
      if (Get.overlayContext == null) {
        Future.delayed(Duration(seconds: 3), () {
          if (!hasConnection) {
            showError(
              'Internet connection unavailable. Please reconnect and try again',
            );
          }
        });
      } else {
        showError(
          'Internet connection unavailable. Please reconnect and try again',
        );
      }
    }
    return hasConnection;
  }
}
