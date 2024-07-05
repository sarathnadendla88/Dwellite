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

  Future<Response> login(
      String phoneNumber, String deviceId) async {
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
      // Error: Handle network errors
      print('Network error occurred: $e');
      return e.response!.data;
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

  Future<Response> verifyOtp(int userId, String otp, String deviceId) async {
    try {
      Response response = await Dio().post(
        "http://118.139.164.158:8080/user/verify",
        data: {"user_id": userId, "otp": otp, "device_id": deviceId},
      );

      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      //returns the error object if any

      return e.response!.data;
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

  Future<Response> addVisitor(
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
      //returns the error object if any
      return e.response?.data;
    }
  }

  Future<Response> addVisitorEntryFromGuard(String jsonString) async {
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
      print("Tammini");
      print(response);
      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      //returns the error object if any
      return e.response?.data;
    }
  }

  Future<Response> deleteVisitor(String userId) async {
    print(userId);
    // to get token from local storage
    var atoken = await SharedPreferencesHelper().readData('useraccesstoken');
    print('http://localhost:8080/user/visitor/' + userId);
    try {
      Response response =
          await Dio().delete("http://118.139.164.158:8080/user/visitor/" + userId,
              options: Options(headers: {
                "Content-Type": "application/json",
                "access-token": atoken,
              }));
      print("Tammini deleted");
      print(response);
      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      //returns the error object if any
      print("Tammini delete error");
      print(e.response!.data);
      return e.response!.data;
    }
  }

  Future<Response> getActiveVisitorsList() async {
    // to get token from local storage
    String atoken = await SharedPreferencesHelper().readData('useraccesstoken');
    print("Sarath Token");
    print(atoken);
    try {
      Response response =
          await Dio().get("http://118.139.164.158:8080/security/active/visitors",
              options: Options(headers: {
                "Content-Type": "application/json",
                "access-token": atoken,
              }));

      //returns the successful user data json object
      return response;
    } on DioException catch (e) {
      // Handle DioError, which includes both network errors and HTTP errors
      print("Dio Error: $e");

      // Depending on your application's logic, you might want to handle specific types of errors differently.
      // For example, returning e.response.data might be problematic if it's not of type Response.
      // If you want to return the entire DioError, you can throw it again.
      throw e;
    } catch (e) {
      // Handle other types of errors
      print("Error: $e");
      // You can throw the error or return an appropriate response here.
      throw e;
    }
  }

  Future<Response> visitorEntryPost(String code) async {
    String atoken = await SharedPreferencesHelper().readData('useraccesstoken');

    print('Get entry');
    print(atoken);
    try {
      Response response =
          await Dio().post("http://118.139.164.158:8080/security/verify/visitors",
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