import 'dart:developer';

import 'package:cash_for_trash/core/models/refresh_token_response_model.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/routing/router_generator.dart';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.path.contains('/auth/login') &&
        !options.path.contains('/auth/register')) {
      final token = await CacheHelper.getSecretData(key: ApiKey.accessToken);
      if (token != null) {
        log('Token: $token');
        options.headers[ApiKey.authorization] = 'Bearer $token';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;

      if (!path.contains('/auth/login') &&
          !path.contains(EndPoint.refreshToken)) {
        final refreshToken = await CacheHelper.getSecretData(key: ApiKey.refreshToken);

        if (refreshToken != null) {
          try {
            final refreshDio = Dio(BaseOptions(baseUrl: EndPoint.baseUrl));
            final response = await refreshDio.post(
              EndPoint.refreshToken,
              data: {'refreshToken': refreshToken},
            );

            if (response.statusCode == 200 || response.statusCode == 201) {
              final responseData = response.data;
              if (responseData != null) {
                final refreshResponse = RefreshTokenResponseModel.fromJson(responseData);
                
                final newAccessToken = refreshResponse.data.accessToken;
                final newRefreshToken = refreshResponse.data.refreshToken;

                await CacheHelper.saveSecretData(
                  key: ApiKey.accessToken,
                  value: newAccessToken,
                );
                await CacheHelper.saveSecretData(
                  key: ApiKey.refreshToken,
                  value: newRefreshToken,
                );

                err.requestOptions.headers[ApiKey.authorization] =
                    'Bearer $newAccessToken';

                final retryDio = Dio();
                final retryResponse = await retryDio.fetch(err.requestOptions);
                return handler.resolve(retryResponse);
              }
            }
          } catch (e) {
            log('Token refresh failed: $e. Forcing logout.');
            await CacheHelper.removeAllSecretData();
            await CacheHelper().clearUserData();
            RouterGenerator.goRouter.go(AppRoutes.loginScreen);
            return handler.next(err);
          }
        }
      }
    }
    super.onError(err, handler);
  }
}
