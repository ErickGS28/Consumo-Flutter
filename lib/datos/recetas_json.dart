import '../dominio/receta.dart';

Dificultad dificultadDesdeTexto(Object? valor) {
  switch (valor) {
    case 'Easy':
      return Dificultad.facil;
    case 'Medium':
      return Dificultad.media;
    case 'Hard':
      return Dificultad.dificil;
    default:
      return Dificultad.desconocida;
  }
}

List<String> _listaDeTextosOpcional(Object? valor) {
  if (valor == null) return const [];
  if (valor is! List) {
    throw const FormatException('Se esperaba una lista de textos.');
  }
  final resultado = <String>[];
  for (final elemento in valor) {
    if (elemento is! String) {
      throw const FormatException('Cada elemento debe ser texto.');
    }
    resultado.add(elemento);
  }
  return resultado;
}

Receta recetaDesdeJson(Map<String, dynamic> json) {
  switch (json) {
    case {
        'id': final int id,
        'name': final String name,
        'cuisine': final String cuisine,
        'prepTimeMinutes': final int prepTimeMinutes,
        'cookTimeMinutes': final int cookTimeMinutes,
        'servings': final int servings,
        'rating': final num rating,
      }:
      return Receta(
        id: id,
        nombre: name,
        cocina: cuisine,
        dificultad: dificultadDesdeTexto(json['difficulty']),
        minutosPreparacion: prepTimeMinutes,
        minutosCoccion: cookTimeMinutes,
        porciones: servings,
        calificacion: rating.toDouble(),
        etiquetas: _listaDeTextosOpcional(json['tags']),
        ingredientes: _listaDeTextosOpcional(json['ingredients']),
      );
    default:
      throw const FormatException('Receta con formato inesperado.');
  }
}

PaginaRecetas paginaDesdeJson(Map<String, dynamic> json) {
  switch (json) {
    case {'recipes': final List recipes, 'total': final int total}:
      final recetas = <Receta>[];
      for (final elemento in recipes) {
        if (elemento is! Map<String, dynamic>) {
          throw const FormatException('Cada receta debe ser un objeto.');
        }
        recetas.add(recetaDesdeJson(elemento));
      }
      return PaginaRecetas(recetas: recetas, total: total);
    default:
      throw const FormatException('Página con formato inesperado.');
  }
}
