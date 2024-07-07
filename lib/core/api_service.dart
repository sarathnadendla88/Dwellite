import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dwellite/utils/constants.dart';
import 'package:dwellite/utils/utility.dart';

enum DioMethod { post, get, put, delete }

class APIService {
  APIService._singleton();
  static final APIService instance = APIService._singleton();
  //final Dio _dio = Dio();

  String get baseUrl {
    //if (kDebugMode) {
    return 'http://118.139.164.158:8080';
    // }

    return 'production url';
  }

  Future<Response> request(
    String endpoint,
    DioMethod method, {
    Map<String, dynamic>? param,
    String? contentType,
    formData,
  }) async {
    var atoken = await SharedPreferencesHelper().readData('useraccesstoken');

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          contentType: contentType ?? Headers.formUrlEncodedContentType,
          headers: {
            "Content-Type": "application/json",
            "access-token": atoken,
          },
        ),
      );
      switch (method) {
        case DioMethod.post:
          return dio.post(
            endpoint,
            data: param ?? formData,
          );
        case DioMethod.get:
          return dio.get(
            endpoint,
            queryParameters: param,
          );
        case DioMethod.put:
          return dio.put(
            endpoint,
            data: param ?? formData,
          );
        case DioMethod.delete:
          return dio.delete(
            endpoint,
            data: param ?? formData,
          );
        default:
          return dio.post(
            endpoint,
            data: param ?? formData,
          );
      }
    } catch (e) {
      throw Exception('Network error');
    }
  }

  Future<Response<dynamic>> login(String phoneNumber, String deviceId) async {
    try {
      // Example of calling the request method with parameters
      final response = await APIService.instance.request(
        '/login', // enter the endpoint for required API call
        DioMethod.post,
        param: {
          'phone_code': "+91",
          'phone_number': phoneNumber,
          'device_id': deviceId
        },
        contentType: 'application/json',
      );
// Handle the response
      if (response.statusCode == 200) {
        // Success: Process the response data
        print('API call successful: ${response.data}');
        return response;
      } else {
        // Error: Handle the error response
        print('API call failed: ${response.statusMessage}');
        return response;
      }
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        // DioErrorType.RESPONSE occurs when received non-2xx status codes
        print('Dio error response data: ${e.response?.data}');
        return e.response!; // Return the response with error data
      } else {
        // DioErrorType.DEFAULT occurs when a more general error happens
        print('Dio error: $e');
        rethrow; // Rethrow the error to be handled elsewhere
      }
    }
  }

  // Future<Response> login(
  //     String phoneNumber, String deviceId, int userType) async {
  //   try {
  //     Response response = await _dio.post(
  //       "/login",
  //       data: {
  //         'phone_code': "+91",
  //         'phone_number': phoneNumber,
  //         'user_type': userType,
  //         'device_id': deviceId
  //       },
  //     );

  //     //returns the successful user data json object
  //     return response;
  //   } on DioException catch (e) {
  //     //returns the error object if any

  //     return e.response!.data;
  //   }
  // }

  Future<Response<dynamic>> verifyOtp(
      int userId, String otp, String deviceId) async {
    try {
      Response response = await Dio().post(
        "http://118.139.164.158:8080/user/verify",
        data: {"user_id": userId, "otp": otp, "device_id": deviceId},
      );

      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        // DioErrorType.RESPONSE occurs when received non-2xx status codes
        print('Dio error response data: ${e.response?.data}');
        return e.response!; // Return the response with error data
      } else {
        // DioErrorType.DEFAULT occurs when a more general error happens
        print('Dio error: $e');
        rethrow; // Rethrow the error to be handled elsewhere
      }
    }
  }

  Future<String> getVisitorsList() async {
    // to get token from local storage
    var atoken = await SharedPreferencesHelper().readData('useraccesstoken');
    print(atoken);
    try {
      Response response = await Dio().get("http://localhost:8080/user/visitors",
          options: Options(headers: {
            "Content-Type": "application/json",
            "access-token": atoken,
          }));

      //returns the successful user data json object
      return response.toString();
    } on DioException catch (e) {
      //returns the error object if any

      return e.response!.data;
    }
  }

  Future<Response<dynamic>> addVisitor(
      VisitorType userType, String date, String userName, String mobile) async {
    // to get token from local storage
    var atoken = await SharedPreferencesHelper().readData('useraccesstoken');
    try {
      Response response =
          await Dio().post("http://118.139.164.158:8080/user/visitors",
              data: {
                "visitor_type": userType.value,
                "entry_date": date,
                "visitor_details": {"name": userName, "phone_number": mobile}
              },
              options: Options(headers: {
                "Content-Type": "application/json",
                "access-token": atoken,
              }));
      print("Tammini");
      print(response);
      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        // DioErrorType.RESPONSE occurs when received non-2xx status codes
        print('Dio error response data: ${e.response?.data}');
        return e.response!; // Return the response with error data
      } else {
        // DioErrorType.DEFAULT occurs when a more general error happens
        print('Dio error: $e');
        rethrow; // Rethrow the error to be handled elsewhere
      }
    }
  }

  Future<Response<dynamic>> addVisitorEntryFromGuard(String jsonString) async {
    // to get token from local storage
    var atoken = await SharedPreferencesHelper().readData('useraccesstoken');
    Map<String, dynamic> parsedJson = jsonDecode(jsonString);
    try {
      Response response =
          await Dio().post("http://118.139.164.158:8080/user/visitors",
              data: parsedJson,
              options: Options(headers: {
                "Content-Type": "application/json",
                "access-token": atoken,
              }));
      print(response);
      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        // DioErrorType.RESPONSE occurs when received non-2xx status codes
        print('Dio error response data: ${e.response?.data}');
        return e.response!; // Return the response with error data
      } else {
        // DioErrorType.DEFAULT occurs when a more general error happens
        print('Dio error: $e');
        rethrow; // Rethrow the error to be handled elsewhere
      }
    }
  }

  Future<Response<dynamic>> deleteVisitor(String userId) async {
    print(userId);
    // to get token from local storage
    var atoken = await SharedPreferencesHelper().readData('useraccesstoken');
    print('http://localhost:8080/user/visitor/' + userId);
    try {
      Response response = await Dio()
          .delete("http://118.139.164.158:8080/user/visitor/" + userId,
              options: Options(headers: {
                "Content-Type": "application/json",
                "access-token": atoken,
              }));
      print("Tammini deleted");
      print(response);
      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        // DioErrorType.RESPONSE occurs when received non-2xx status codes
        print('Dio error response data: ${e.response?.data}');
        return e.response!; // Return the response with error data
      } else {
        // DioErrorType.DEFAULT occurs when a more general error happens
        print('Dio error: $e');
        rethrow; // Rethrow the error to be handled elsewhere
      }
    }
  }

  Future<Response<dynamic>> getActiveVisitorsList() async {
    // to get token from local storage
    String atoken = await SharedPreferencesHelper().readData('useraccesstoken');
    print("Sarath Token");
    print(atoken);
    try {
      Response response = await Dio()
          .get("http://118.139.164.158:8080/security/active/visitors",
              options: Options(headers: {
                "Content-Type": "application/json",
                "access-token": atoken,
              }));

      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        // DioErrorType.RESPONSE occurs when received non-2xx status codes
        print('Dio error response data: ${e.response?.data}');
        return e.response!; // Return the response with error data
      } else {
        // DioErrorType.DEFAULT occurs when a more general error happens
        print('Dio error: $e');
        rethrow; // Rethrow the error to be handled elsewhere
      }
    }
  }

  Future<Response> visitorEntryPost(String code) async {
    String atoken = await SharedPreferencesHelper().readData('useraccesstoken');

    print('Get entry');
    print(atoken);
    try {
      Response response = await Dio()
          .post("http://118.139.164.158:8080/security/verify/visitors",
              data: {"security_code": code},
              options: Options(headers: {
                "Content-Type": "application/json",
                "access-token": atoken,
              }));
      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      //returns the error object if any
      return e.response?.data;
    }
  }

  Future<Response> visitorStatusChangePost(
      int userId, int visitorId, int visitorStatus) async {
    String atoken = await SharedPreferencesHelper().readData('useraccesstoken');

    try {
      Response response = await Dio().post(
          "http://118.139.164.158:8080/security/visitor/status",
          data: {
            "user_id": userId,
            "visitor_id": visitorId,
            "visitor_status": visitorStatus
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "access-token": atoken,
          }));
      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      //returns the error object if any
      return e.response?.data;
    }
  }
}
