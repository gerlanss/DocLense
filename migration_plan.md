# Plano de Migração para ShareUtil

## Objetivo
Substituir todos os usos diretos da classe `Share` do pacote `share_plus` pelo novo utilitário `ShareUtil` para centralizar a funcionalidade de compartilhamento e lidar corretamente com os métodos obsoletos.

## Alterações Já Realizadas
1. ✅ Criado o arquivo `share_util_new.dart` com métodos para compartilhar PDFs e texto
2. ✅ Atualizado `home.dart` para usar `ShareUtil.sharePdf` em vez de `Share.shareFiles`
3. ✅ Atualizado `main_drawer.dart` para usar `ShareUtil.shareText` em vez de `Share.share`
4. ✅ Atualizado `starred_documents.dart` para usar `ShareUtil.sharePdf` em vez de `Share.shareXFiles`
5. ✅ Removidos imports desnecessários de `share_plus` nos arquivos acima
6. ✅ Atualizado o `ShareUtil` para usar a nova API (`SharePlus.instance.share()` com `ShareParams`)
7. ✅ Removido o import não utilizado de `camera` do arquivo `starred_documents.dart`

## Alterações Pendentes
1. ⬜ `image_view.dart`: O arquivo tem um método de menu popup comentado que usa a funcionalidade de compartilhamento. Se este código for descomentado no futuro, será necessário atualizá-lo para usar `ShareUtil.sharePdf()`.
2. ⬜ Revisar estrutura do arquivo `image_view.dart` que parece ter alguns problemas de formatação.

## Observações
- O arquivo `share_util_new.dart` foi criado com a anotação `// ignore_for_file: deprecated_member_use` para evitar avisos de depreciação
- Todos os métodos incluem verificações de existência de arquivo antes de compartilhar para evitar erros
- A API antiga (`Share.share`, `Share.shareFiles`, etc.) foi totalmente substituída pela nova API (`SharePlus.instance.share()` com `ShareParams`)

## Como testar as alterações
1. Compartilhar um documento PDF da tela principal
2. Compartilhar um documento PDF da tela de documentos favoritos
3. Compartilhar o aplicativo usando a função no menu lateral

## Próximos passos
1. Considerar a atualização para versões mais recentes das dependências
2. Implementar testes automatizados para a funcionalidade de compartilhamento
3. Documentar o uso de `ShareUtil` para futuros desenvolvedores
