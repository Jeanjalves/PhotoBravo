import 'dart:typed_data';

export 'save_image_mobile.dart'
  if (dart.library.html) 'save_image_web.dart';

Future<void> salvarImagem(Uint8List bytes) async {}
