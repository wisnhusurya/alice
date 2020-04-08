import 'dart:io';
import 'package:alice/core/alice_chopper_response_interceptor.dart';
import 'package:alice/core/alice_http_adapter.dart';
import 'package:http/http.dart' as http;
import 'package:alice/core/alice_core.dart';
import 'package:alice/core/alice_dio_interceptor.dart';
import 'package:alice/core/alice_http_client_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Alice {
  GlobalKey<NavigatorState> _navigatorKey;
  AliceCore _core;
  AliceHttpClientAdapter _httpClientAdapter;
  AliceHttpAdapter _httpAdapter;
  bool showNotification;
  bool showInspectorOnShake;
  bool darkTheme;

  Alice(
      {this.showNotification = true,
      GlobalKey<NavigatorState> navigatorKey,
      this.showInspectorOnShake = false,
      this.darkTheme = false}) {
    _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
    _core = AliceCore(
        _navigatorKey, showNotification, showInspectorOnShake, darkTheme);
    _httpClientAdapter = AliceHttpClientAdapter(_core);
    _httpAdapter = AliceHttpAdapter(_core);
  }

  GlobalKey<NavigatorState> getNavigatorKey() {
    return _navigatorKey;
  }

  AliceDioInterceptor getDioInterceptor() {
    return AliceDioInterceptor(_core);
  }

  void onHttpClientRequest(HttpClientRequest request, {dynamic body}) {
    assert(request != null, "HttpClientRequest can't be null");
    _httpClientAdapter.onRequest(request, body: body);
  }

  void onHttpClientResponse(
      HttpClientResponse response, HttpClientRequest request,
      {dynamic body}) {
    assert(response != null, "HttpClientResponse can't be null");
    assert(request != null, "HttpClientRequest can't be null");
    _httpClientAdapter.onResponse(response, request, body: body);
  }

  void onHttpResponse(http.Response response, {dynamic body}) {
    assert(response != null, "Response can't be null");
    _httpAdapter.onResponse(response, body: body);
  }

  void showInspector() {
    _core.navigateToCallListScreen();
  }

  List getChopperInterceptor() {
    return new List()..add(AliceChopperInterceptor(_core));
  }

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey){
    _core.setNavigatorKey(navigatorKey);
  }
}
