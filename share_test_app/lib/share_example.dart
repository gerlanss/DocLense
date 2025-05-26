import 'package:share_plus/share_plus.dart';

void shareExample() {
  // Compartilhar um texto
  Share.share('Compartilhando texto exemplo');
  
  // Compartilhar com assunto (para emails)
  Share.share('Compartilhando texto com assunto', subject: 'Olá, veja isto!');
  
  // Compartilhar arquivos
  Share.shareFiles(['caminho/para/arquivo.pdf']);
  
  // Compartilhar arquivos com assunto
  Share.shareFiles(['caminho/para/arquivo.pdf'], subject: 'Meu PDF');
}
