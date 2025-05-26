# Instruções para atualização das dependências no DocLense

As dependências `gallery_saver` e `photofilters` foram substituídas por alternativas mais modernas que são compatíveis com as versões mais recentes do Flutter.

## Substituições realizadas

1. `gallery_saver` -> `image_gallery_saver`
2. `photofilters` -> `image_editor_plus`

## Arquivos modificados

1. `lib/ui_components/image_view.dart` - Adaptado para usar o editor de imagens mais moderno
2. `lib/ui_components/multi_select_delete.dart` - Adaptado para usar o salvamento de galeria moderno

## Como aplicar as mudanças

### No Windows (PowerShell)

1. Substitua manualmente os arquivos da seguinte forma:
   - Copie o conteúdo de `image_view_new.dart` para `image_view.dart`
   - Copie o conteúdo de `multi_select_delete_new.dart` para `multi_select_delete.dart`

2. Execute os seguintes comandos:
   ```powershell
   cd "G:\OneDrive\Documentos\GitHub\DocLense"
   flutter clean
   flutter pub get
   flutter run
   ```

### No Linux/macOS

1. Torne o script executável e execute-o:
   ```bash
   chmod +x update_libs.sh
   ./update_libs.sh
   ```

## Observações

- As novas implementações mantêm a mesma funcionalidade, mas usando bibliotecas atualizadas e compatíveis
- Foram feitas pequenas melhorias na interface de seleção de imagens e no editor de imagens
- Caso encontre problemas, consulte a documentação oficial das bibliotecas:
  - [image_gallery_saver](https://pub.dev/packages/image_gallery_saver)
  - [image_editor_plus](https://pub.dev/packages/image_editor_plus)
