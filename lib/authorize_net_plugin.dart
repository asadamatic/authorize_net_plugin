import 'dart:async';

import 'package:flutter/services.dart';

class AuthorizeNetPlugin {
  static const MethodChannel _channel =
      const MethodChannel('authorize_net_plugin');

  static Future<String> authorizeNetToken(
      {required String env,
      required String cardNumber,
      required String expirationMonth,
      required String expirationYear,
      required String cardCvv,
      String? zipCode,
      required String cardHolderName,
      required String apiLoginId,
      required String clientId}) async {
    final String version =
        await _channel.invokeMethod('authorizeNetToken', <String, String?>{
      'env': env,
      'card_number': cardNumber,
      'expiration_month': expirationMonth,
      'expiration_year': expirationYear,
      'card_cvv': cardCvv,
      'zip_code': zipCode,
      'card_holder_name': cardHolderName,
      'api_login_id': apiLoginId,
      'client_id': clientId,
    });
    return version;
  }
}
