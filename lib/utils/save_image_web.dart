import 'dart:html' as html;
import 'dart:typed_data';

Future<void> salvarImagem(Uint8List bytes) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "photobravo.png")
    ..click();

  html.Url.revokeObjectUrl(url);
}
