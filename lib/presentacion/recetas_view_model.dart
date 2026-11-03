import 'package:flutter/foundation.dart';

import '../dominio/falla_red.dart';
import '../dominio/receta.dart';
import '../datos/recetas_repositorio.dart';
import 'mensajes.dart';

sealed class EstadoRecetas {
  const EstadoRecetas();
}

final class RecetasInicial extends EstadoRecetas {
  const RecetasInicial();
}

final class RecetasCargando extends EstadoRecetas {
  const RecetasCargando();
}

final class RecetasListas extends EstadoRecetas {
  const RecetasListas(this.recetas, this.total);
  final List<Receta> recetas;
  final int total;
}

final class RecetasVacias extends EstadoRecetas {
  const RecetasVacias(this.busqueda);
  final String busqueda;
}

final class RecetasFallidas extends EstadoRecetas {
  const RecetasFallidas(this.mensaje);
  final String mensaje;
}

class RecetasViewModel extends ChangeNotifier {
  RecetasViewModel(this._repositorio);

  final RecetasRepositorio _repositorio;

  EstadoRecetas _estado = const RecetasInicial();
  String _ultimaBusqueda = '';
  bool _dispuesto = false;

  EstadoRecetas get estado => _estado;

  bool get cargando => _estado is RecetasCargando;

  String get ultimaBusqueda => _ultimaBusqueda;

  int get rapidas {
    final estadoActual = _estado;
    switch (estadoActual) {
      case RecetasListas(:final recetas):
        return recetas.where((r) => r.esRapida).length;
      case RecetasInicial():
      case RecetasCargando():
      case RecetasVacias():
      case RecetasFallidas():
        return 0;
    }
  }

  Future<void> buscar(String texto) async {
    if (cargando) return;
    _ultimaBusqueda = texto.trim();
    _estado = const RecetasCargando();
    _avisar();
    try {
      final pagina = await _repositorio.buscar(texto: _ultimaBusqueda);
      if (pagina.recetas.isEmpty) {
        _estado = RecetasVacias(_ultimaBusqueda);
      } else {
        _estado = RecetasListas(pagina.recetas, pagina.total);
      }
    } on FallaRed catch (falla) {
      _estado = RecetasFallidas(mensajePara(falla));
    } catch (_) {
      _estado = const RecetasFallidas(mensajeInesperado);
    }
    _avisar();
  }

  Future<void> reintentar() => buscar(_ultimaBusqueda);

  void _avisar() {
    if (_dispuesto) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _dispuesto = true;
    super.dispose();
  }
}
