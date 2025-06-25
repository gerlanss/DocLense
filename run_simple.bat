@echo off
echo 🧹 Limpando projeto...
flutter clean

echo 📱 Limpando Gradle...
cd android
call gradlew clean
cd ..

echo 📦 Baixando dependências...
flutter pub get

echo 🚀 Executando com configurações especiais...
flutter run --verbose --no-build-ios-framework