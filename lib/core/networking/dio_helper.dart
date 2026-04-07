import 'package:ai_therapist_app/core/networking/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  Dio? dio;

  DioHelper() {
    dio ??= Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );

    dio!.interceptors.add(PrettyDioLogger());
  }

  Future<Response<dynamic>> getRequest({
    required String endPoint,
    Map<String, dynamic>? query,
  }) async {
    try {
      final Response<dynamic> response =
          await dio!.get(endPoint, queryParameters: query);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> postRequest({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final Response<dynamic> response =
          await dio!.post(endPoint, data: data);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> putRequest({
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final Response<dynamic> response = await dio!.put(endPoint, data: data);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
