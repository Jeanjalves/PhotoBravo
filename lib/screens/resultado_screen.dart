import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../utils/save_image.dart';

class ResultadoScreen extends StatefulWidget {
  final Uint8List foto;
  final String cia;
  final String pelotao;
  final String nome;
  final String rg;
  final String nascimento;
  final String ocorrencia;
  final String local;
  final String viatura;
  final String bopm;
  final String bopc;
  final String data;

  const ResultadoScreen({
    super.key,
    required this.foto,
    required this.cia,
    required this.pelotao,
    required this.nome,
    required this.rg,
    required this.nascimento,
    required this.ocorrencia,
    required this.local,
    required this.viatura,
    required this.bopm,
    required this.bopc,
    required this.data,
  });

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  final GlobalKey _key = GlobalKey();

  Future<void> _salvarOuCompartilhar() async {
    try {
      final boundary =
          _key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // Adicionado await e verificação básica
        await salvarImagemUtil(pngBytes);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagem salva com sucesso!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar imagem: $e')),
        );
      }
    }
  }

  Widget _campo(String valor, String label) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            RepaintBoundary(
              key: _key,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text(
                      'POLÍCIA MILITAR DO ESTADO DE SÃO PAULO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.pelotao} - ${widget.cia}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Image.memory(
                      widget.foto,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _campo(widget.rg, 'RG'),
                        _campo(widget.nascimento, 'Nascimento'),
                        _campo(widget.ocorrencia, 'Ocorrência'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _campo(widget.local, 'Local'),
                        _campo(widget.viatura, 'Viatura'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _campo(widget.bopm, 'BOPM'),
                        _campo(widget.bopc, 'BOPC'),
                        _campo(widget.data, 'Data'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _salvarOuCompartilhar,
              icon: const Icon(Icons.download),
              label: const Text('Salvar / Compartilhar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
