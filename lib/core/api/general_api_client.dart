import 'package:dio/dio.dart';
import 'package:jklist/core/api/api_client.dart';
import 'package:jklist/core/controllers/session_controller.dart';
import 'package:jklist/core/logging/logger.dart';
import 'package:jklist/core/exceptions/token_expired_exception.dart';

abstract class GeneralApiClient extends ApiClient {

  final SessionController sessionController;

  GeneralApiClient(
      String apiKey,
      String baseUrl,
      Logger logger,
      this.sessionController
      ) : super(apiKey, baseUrl, logger);


  tryToRefreshToken() async {
    try {
      if (sessionController.getToken() != null) {
        await sessionController.refreshSession();
      }
    } catch (ex) {
      throw TokenExpiredException();
    }
  }

  @override
  void handleError(Response response) {
    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 401)
      tryToRefreshToken();
  }

}