import 'package:flutter/material.dart';
import 'package:jklist/core/api/clients/general_client.dart';
import 'package:jklist/core/controllers/session_controller.dart';
import 'package:jklist/core/logging/logger.dart';

class Api {
  final GeneralClient generalClient;

  Api({
    @required this.generalClient,
  });

  factory Api.create({
    @required String apiKey,
    @required String baseUrl,
    @required Logger logger,
    @required SessionController sessionController,
  }) {
    return Api(
      generalClient: GeneralClient(
          apiKey: apiKey,
          baseUrl: baseUrl,
          logger: logger,
          sessionController: sessionController
      ),
      // add more clients here
    );
  }
}