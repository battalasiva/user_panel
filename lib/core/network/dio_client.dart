import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:user_panel/core/constants/api_urls.dart';

enum Method { post, get, put, delete, patch }

class DioClient {
  late Dio dio;

  DioClient() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    initInterceptors();
  }

  void initInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        log('REQUEST[${options.method}] => PATH: ${options.path} => HEADERS: ${options.headers} => DATA: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (err, handler) {
        log('ERROR[${err.response?.statusCode}] => MESSAGE: ${err.message}');
        return handler.next(err);
      },
    ));
  }

  Future<Either<Response, Exception>> request(String url, Method method, {dynamic params}) async {
    try {
      Response response;

      switch (method) {
        case Method.post:
          response = await dio.post(url, data: params);
          break;
        case Method.put:
          response = await dio.put(url, data: params);
          break;
        case Method.patch:
          response = await dio.patch(url, data: params);
          break;
        case Method.delete:
          response = await dio.delete(url);
          break;
        case Method.get:
        default:
          response = await dio.get(url, queryParameters: params);
      }

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        return Left(response);
      } else {
        return Right(Exception("Request failed with status: ${response.statusCode}"));
      }
    } on SocketException {
      return Right(Exception("No Internet Connection"));
    } on FormatException {
      return Right(Exception("Bad Response Format"));
    } on DioException catch (e) {
      return Right(Exception(e.message));
    } catch (e) {
      return Right(Exception("Unexpected Error"));
    }
  }
}
