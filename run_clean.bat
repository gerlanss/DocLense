# Limpeza completa dos caches
echo "🧹 Limpando caches Flutter e Gradle..."
flutter clean

echo "📱 Limpando cache Gradle Android..."
cd android && ./gradlew clean && cd ..

echo "🗑️ Removendo cache pub..."
flutter pub cache clean

echo "📦 Reinstalando dependências..."
flutter pub get

echo "🚀 Tentando executar..."
flutter run