import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'resultado_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  XFile? _imagem;
  Uint8List? _imagemBytes;

  String? ciaSelecionada;
  String? pelotaoSelecionado;

  final Map<String, TextEditingController> controllers = {
    'Nome Completo': TextEditingController(),
    'RG': TextEditingController(),
    'Nascimento': TextEditingController(),
    'Ocorrência': TextEditingController(),
    'Local': TextEditingController(),
    'Equipe / Viatura': TextEditingController(),
    'BOPM': TextEditingController(),
    'BOPC': TextEditingController(),
    'Data': TextEditingController(),
  };

  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pegarImagem(ImageSource source) async {
    final img = await _picker.pickImage(
      source: source,
      imageQuality: 90,
    );

    if (img != null) {
      final bytes = await img.readAsBytes();
      setState(() {
        _imagem = img;
        _imagemBytes = bytes;
      });
    }
  }

  void _gerarResultado() {
    if (!_formKey.currentState!.validate()) return;
    if (_imagemBytes == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadoScreen(
          imagemBytes: _imagemBytes!,
          dados: {
            'CIA': ciaSelecionada!,
            'Pelotão': pelotaoSelecionado!,
            'Nome': controllers['Nome Completo']!.text,
            'RG': controllers['RG']!.text,
            'Nascimento': controllers['Nascimento']!.text,
            'Ocorrência': controllers['Ocorrência']!.text,
            'Local': controllers['Local']!.text,
            'Viatura': controllers['Equipe / Viatura']!.text,
            'BOPM': controllers['BOPM']!.text,
            'BOPC': controllers['BOPC']!.text,
            'Data': controllers['Data']!.text,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhotoBravo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // IMAGEM
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imagemBytes == null
                    ? const Center(
                        child: Icon(Icons.camera_alt, size: 80),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _imagemBytes!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),

              const SizedBox(height: 12),

              // BOTÕES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera),
                    label: const Text('Câmera'),
                    onPressed: () => _pegarImagem(ImageSource.camera),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text('Galeria'),
                    onPressed: () => _pegarImagem(ImageSource.gallery),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // CIA
              DropdownButtonFormField<String>(
                value: ciaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'CIA',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  '1ª CIA',
                  '2ª CIA',
                  '3ª CIA',
                  '4ª CIA',
                  '5ª CIA',
                  '6ª CIA',
                ]
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => ciaSelecionada = v),
                validator: (v) =>
                    v == null ? 'Selecione a CIA' : null,
              ),

              const SizedBox(height: 12),

              // PELOTÃO
              DropdownButtonFormField<String>(
                value: pelotaoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Pelotão',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  'Alpha',
                  'Bravo',
                  'Charlie',
                  'Delta',
                ]
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e)),
                    )
                    .toList(),
                onChanged: (v) =>
                    setState(() => pelotaoSelecionado = v),
                validator: (v) =>
                    v == null ? 'Selecione o Pelotão' : null,
              ),

              const SizedBox(height: 12),

              // CAMPOS
              ...controllers.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    controller: e.value,
                    decoration: InputDecoration(
                      labelText: e.key,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty
                            ? 'Campo obrigatório'
                            : null,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // GERAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Gerar Ficha'),
                  onPressed: _gerarResultado,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
