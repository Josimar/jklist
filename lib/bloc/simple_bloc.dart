import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SimpleBloc<T> extends ChangeNotifier{
  final _controller = StreamController<T>();

  Stream<T> get stream => _controller.stream;

  void addStream(T object){
    _controller.add(object);
  }

  void addError(Object error){
    if (! _controller.isClosed){
      _controller.addError(error);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

}