import 'package:flutter/material.dart';
import 'package:uncommonflutter/app.dart';
import 'package:uncommonflutter/configs/app_config.dart';

void main() {
  AppConfig().setConfig(
    environment: Environment.Development,
    apiBaseUrl: 'https://dev.example.com/api/v1',
    apiKey: 'dev:abc123',
  );
  runApp(MyApp());
}
