import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> salvarImagem(Uint8List bytes) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/photobravo.png');
  await file.writeAsBytes(bytes);

  await Share.shareXFiles([XFile(file.path)]);
}
