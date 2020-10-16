import 'package:flutter/material.dart';
import 'package:jklist/core/logging/logger.dart';
import 'package:jklist/core/api/clients/general_client.dart';
import 'package:jklist/core/api/response/auth/session_response.dart';

class GeneralController {
  final GeneralClient generalClient;
  final Logger logger;

  GeneralController({
    @required this.generalClient,
    @required this.logger,
  });

  Future<SessionResponse> fetchDummy() {
    return generalClient.fetchDummy();
  }

}