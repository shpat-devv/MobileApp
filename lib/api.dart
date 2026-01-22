import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final String? _baseUrl = "http://127.0.0.1:8000/";
  static Uri _uri(String path) {
    return Uri.parse("$_baseUrl$path");
  }

  static Map<String, String> _headers({String? token}) {
    return {
      "Content-Type": "application/json",
      "Referer": "$_baseUrl",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> get(
    String path, {
    String? token,
  }) async {
    return http.get(
      _uri(path),
      headers: _headers(token: token),
    );
  }
  
  static Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    return http.post(
      _uri(path),
      headers: _headers(token: token),
      body: jsonEncode(body ?? {}),
    );
  }

  static Future<http.Response> patch(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    return http.patch(
      _uri(path),
      headers: _headers(token: token),
      body: jsonEncode(body ?? {}),
    );
  }

  static Future<http.Response> delete(
    String path, {
    String? token,
  }) async {
    return http.delete(
      _uri(path),
      headers: _headers(token: token),
    );
  }
}