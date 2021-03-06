import 'package:flutter/material.dart';
import 'package:uncommonflutter/app.dart';
import 'package:uncommonflutter/configs/app_config.dart';

void main() {
  AppConfig().setConfig(
    environment: Environment.Production,
    apiBaseUrl: 'https://example.com/api/v1',
    apiKey: 'abc123',
  );
  runApp(MyApp());
}
