import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:user_panel/widgets/custom_snac_bars.dart';

mixin NetworkCheckService {
  Future<bool> checkInternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (!result) {
      CustomSnacBars()
          .showErrorSnack(title: "Network", message: 'No Network found');
    }
    return result;
  }
}
