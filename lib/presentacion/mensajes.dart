import '../dominio/falla_red.dart';

const mensajeInesperado = 'Algo salió mal. Intenta de nuevo.';

String mensajePara(FallaRed falla) {
  switch (falla) {
    case SinConexion():
      return 'Sin conexión. Revisa tu red e intenta de nuevo.';
    case TiempoAgotado():
      return 'El recetario tardó demasiado en responder. Intenta de nuevo.';
    case ErrorDelServidor(:final codigo):
      return 'El recetario no está disponible ($codigo). Intenta más tarde.';
    case PeticionRechazada():
      return 'No pudimos hacer esa búsqueda. Avisa al equipo de desarrollo.';
    case RespuestaInvalida():
      return 'Las recetas llegaron con un formato inesperado.';
  }
}
