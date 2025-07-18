// ignore_for_file: deprecated_member_use
import 'package:share_plus/share_plus.dart';
import 'dart:io';

/// Uma classe utilitária para encapsular funcionalidades de compartilhamento.
class ShareUtil {
  /// Compartilha um arquivo de PDF com o assunto fornecido.
  static Future<void> sharePdf(String filePath, String subject) async {
    final file = File(filePath);
    if (await file.exists()) {
      // Usando a API correta do share_plus
      await Share.shareXFiles([XFile(filePath)], subject: subject);
    }
  }

  /// Compartilha um texto com o assunto fornecido.
  static Future<void> shareText(String text, {String? subject}) async {
    // Usando a API correta do share_plus
    await Share.share(text, subject: subject);
  }
}
