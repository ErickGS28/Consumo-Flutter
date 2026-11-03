import 'package:flutter/material.dart';

import '../dominio/receta.dart';
import 'recetas_view_model.dart';
import 'tarjeta_receta.dart';

class RecetasPagina extends StatefulWidget {
  const RecetasPagina({super.key, required this.vm});

  final RecetasViewModel vm;

  @override
  State<RecetasPagina> createState() => _RecetasPaginaState();
}

class _RecetasPaginaState extends State<RecetasPagina> {
  final TextEditingController _controlador = TextEditingController();

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _buscar() {
    widget.vm.buscar(_controlador.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetario UTEZ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('busqueda'),
              controller: _controlador,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscar(),
              decoration: const InputDecoration(
                labelText: '¿Qué quieres cocinar?',
                hintText: 'Ej. pizza, pasta, chicken…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ListenableBuilder(
              listenable: widget.vm,
              builder: (context, _) {
                return FilledButton(
                  key: const Key('buscar'),
                  onPressed: widget.vm.cargando ? null : _buscar,
                  child: const Text('Buscar recetas'),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.vm,
                builder: (context, _) => _contenido(context, widget.vm),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contenido(BuildContext context, RecetasViewModel vm) {
    final estado = vm.estado;
    switch (estado) {
      case RecetasInicial():
        return const Center(
          child: Text(
            'Escribe una receta o déjalo vacío y toca Buscar recetas.',
            textAlign: TextAlign.center,
          ),
        );
      case RecetasCargando():
        return const Center(child: CircularProgressIndicator());
      case RecetasVacias(:final busqueda):
        return Center(
          child: Text(
            busqueda.isEmpty
                ? 'No hay recetas disponibles.'
                : 'No encontramos recetas para "$busqueda".',
            textAlign: TextAlign.center,
          ),
        );
      case RecetasFallidas(:final mensaje):
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mensaje, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: vm.reintentar,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        );
      case RecetasListas(:final recetas, :final total):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mostrando ${recetas.length} de $total recetas · Rápidas: ${vm.rapidas}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: recetas.length,
                itemBuilder: (context, indice) {
                  final Receta receta = recetas[indice];
                  return TarjetaReceta(receta: receta);
                },
              ),
            ),
          ],
        );
    }
  }
}
