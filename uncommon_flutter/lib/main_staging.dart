import 'package:flutter/material.dart';
import 'package:uncommonflutter/app.dart';
import 'package:uncommonflutter/configs/app_config.dart';

void main() {
  AppConfig().setConfig(
    environment: Environment.Staging,
    apiBaseUrl: 'https://staging.example.com/api/v1',
    apiKey: 'staging:abc123',
  );
  runApp(MyApp());
}
