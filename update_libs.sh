#!/bin/bash

# Script para fazer a transição das bibliotecas descontinuadas no DocLense

# Primeiro, substituir as dependências no pubspec.yaml
echo "Substituindo dependencies no pubspec.yaml..."
sed -i 's/gallery_saver: \^.*/image_gallery_saver: \^2.0.3  # Substituto moderno para gallery_saver/g' pubspec.yaml
sed -i 's/photofilters: \^.*/image_editor_plus: \^1.0.6  # Substituto moderno para photofilters/g' pubspec.yaml

# Executar flutter pub get
echo "Atualizando as dependências..."
flutter pub get

echo "Transição concluída! Agora execute 'flutter run' para testar."
