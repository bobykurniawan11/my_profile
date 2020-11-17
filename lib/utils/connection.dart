import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';

class Connection {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      await Firebase.initializeApp();

      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      await Firebase.initializeApp();

      return true;
    }
    return false;
  }
}
