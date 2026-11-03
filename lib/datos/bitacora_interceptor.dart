import 'dart:developer' as developer;

import 'package:dio/dio.dart';

const _claveCronometro = 'bitacora_cronometro';

class BitacoraInterceptor extends Interceptor {
  BitacoraInterceptor({void Function(String linea)? escribir})
      : _escribir = escribir ?? ((linea) => developer.log(linea));

  final void Function(String linea) _escribir;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_claveCronometro] = Stopwatch()..start();
    _escribir('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final ms = _detener(response.requestOptions);
    _escribir(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.path} ($ms ms)',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final ms = _detener(err.requestOptions);
    final codigo = err.response?.statusCode;
    final parteCodigo = codigo != null ? ' $codigo' : '';
    _escribir(
      '✗ ${err.type.name}$parteCodigo ${err.requestOptions.method} '
      '${err.requestOptions.path} ($ms ms)',
    );
    handler.next(err);
  }

  int _detener(RequestOptions options) {
    final cronometro = options.extra[_claveCronometro];
    if (cronometro is Stopwatch) {
      cronometro.stop();
      return cronometro.elapsedMilliseconds;
    }
    return 0;
  }
}
