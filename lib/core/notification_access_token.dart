import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async =>
      _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          {
            "type": "service_account",
            "project_id": "dwellite-433d3",
            "private_key_id": "35368d6f9973902a21d72fee6b834d51029c8b12",
            "private_key":
                "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDxxunkwz+SMHlH\nxdOOSw7WyotqDEiEzvwyfhm1EZvh7q8avsArUlUUkhYAVmh0Y8nGu1AhkSg9dMW/\nws+r7/Tn8iAxOTNEJEWWzWhsykhiH9i5MGgaHQsjGV0dIR7b2R9nUdFG6hghZF0u\nd0WtidF7GT4UQfn2rgdP/0J//iT3TQAGX3dW4+mgnmIap6KdPQmEts6M9mRsqVWC\nLzHmzwcxvPx9fEAbBUbhMHcXo2mR8PdnZtODm+omzwcEQVmkcKn6vqvI2Ee5qUeW\n8q+GXCfnfPCl/XkdqMiTgJGGNLiP544w3Ca7cqx7ghRbW7l7XxSIdVpk1KIRUtOs\nyBTMWNmxAgMBAAECggEAFUYJ1YGiidPvD/QlqbsL+rVGsBWVme32feDflTGP9EDC\nsok/MnCjoNQ70FrKBRe0rOJVaiayEjpAnh9fk4LhGzmQQJSGYMQKRXscaZog5VVl\nBeJu/oE4tiVoroP4CaMgosAtuF4nsmR42HpRLLRYNMsjTbgCbQSiCxVsPgPYL9Qw\nWETqF/y46RcUT383uQYuArL62vA3rK3fKrZKsKTHBlkVTFzamrVkCZnjIm68lJLx\nL38raD4jGsnJ31ib1bIx3p4RxPt8SCIsYvafkOcrEgKv/LME/imGQCXVxjWRedNC\nKYHwHZNBSE3tnhH4HzZDjA78fy0DGAka900uBs9xcwKBgQD7SNmIjuO6cY5Ll1kD\nmtRX62CJxYDy8X7ghDDbQ12qc0+hyFd5q5ka50ay/xz2r62a1CKM514UwzxXbYwM\n8OWSkSm5Ln1DYsFJdMniQ0lNVeDK+2ibjDfDYJfmmePz3C8G9PPabBrWtQvkWFj/\nxFobkJ0+IApnPEJKjzG2f0CiWwKBgQD2UGPuyR5mMl7kbsYCjZE/FtFqike2TARZ\n7hon5OGsKOb3VU/LcvO9vtPefwmWzql6sxTpTBuXEAcO/HX8ORo3RhGtuQr8AqAj\nurhZgKkQMHEEpFgDt42i5vJCo4m31RhPQ1x4/gS2hNwTd11ICP+n6XV8ZcCbQTNL\n2wL27eoZ4wKBgQCz+bJsP0NV9x0egPDtRwiNS/Vh18aKunLQJX3EnVRJz7saOZ6F\nc2T+QuV9MIEzIhJqUUPJvbDBmC/wwnJLloIm3reOfYCUMfgUP4SU/PJUZIzTdQuw\nVNZfpiBFtrTwpSQ9jFXXfBQg8Zzp2GkuDxkmowYsR9CLrjogorzNZAkL/wKBgA6r\nRPhQk/XkJBCYpEQ8qBzIwBoHODQcHNo6OuaLVAFLwk2SkBj+tJNlTPrgN/L6Rc+f\n4KvwM2hwtOrokCJASFZoXt8ouQW/Jkhac2YpKmhjaierne5CvTWpaV4cnTQMhdEa\nouQ1xJQWH4EtR6nll0wptCx/ZtQYMvTeizOngZyfAoGAcssC/cOb84kn0aUvTm1t\nPd8787QSv0fjH1rQixetUJGCZi024L5AkKyMG0cUms0Y6CVvBlrdPhuxbPJczIJQ\nAzRDaazFYoWbDzZzUNtH2V4SCs2WjULv3FtmlTKIy67AHcv74YNMoVfVbbbs3RvV\n8FvPM7wraGWNlstz9J67rcY=\n-----END PRIVATE KEY-----\n",
            "client_email":
                "firebase-adminsdk-myccs@dwellite-433d3.iam.gserviceaccount.com",
            "client_id": "101041676927061099333",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url":
                "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url":
                "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-myccs%40dwellite-433d3.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
          }
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
