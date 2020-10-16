import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jklist/core/api/request/request_object.dart';

part 'register_device_request_object.g.dart';

@JsonSerializable(createFactory: false)
class RegisterDeviceRequestObject implements RequestObject {
  @JsonKey(name: 'registration_id')
  final String token;

  @JsonKey(name: 'type')
  final String type = "android";

  const RegisterDeviceRequestObject({
    @required this.token,
  });

  Map getJsonBody() {
    return _$RegisterDeviceRequestObjectToJson(this);
  }
}