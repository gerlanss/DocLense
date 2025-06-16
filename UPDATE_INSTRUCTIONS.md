# Instruções para atualização das dependências no DocLense

As dependências `gallery_saver` e `photofilters` foram substituídas por alternativas mais modernas que são compatíveis com as versões mais recentes do Flutter.

## Substituições realizadas

1. `gallery_saver` -> `image_gallery_saver`
2. `photofilters` -> `image_editor_plus`

## Arquivos modificados

1. `lib/ui_components/image_view.dart` - Adaptado para usar o editor de imagens mais moderno
2. `lib/ui_components/multi_select_delete.dart` - Adaptado para usar o salvamento de galeria moderno

## Como aplicar as mudanças

### Atualização manual

1. Certifique-se de ter o Flutter instalado.
2. Execute os comandos a seguir na raiz do projeto:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## Observações

- As novas implementações mantêm a mesma funcionalidade, mas usando bibliotecas atualizadas e compatíveis
- Foram feitas pequenas melhorias na interface de seleção de imagens e no editor de imagens
- Caso encontre problemas, consulte a documentação oficial das bibliotecas:
  - [image_gallery_saver](https://pub.dev/packages/image_gallery_saver)
  - [image_editor_plus](https://pub.dev/packages/image_editor_plus)
