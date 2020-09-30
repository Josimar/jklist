# jklist

Lista para tudo

## Getting Started

Na pasta do APP
### Gerar dados da chave
keytool -genkey -v -keystore C:\Josimar\Free\JosimarJKList\jklist.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key

### listar dados da chave
keytool -list -v -alias key -keystore C:\Josimar\Free\JosimarJKList\jklist.jks

### Mostrar MD5, SHA1 e SHA-256
Botão direito no gradlew abrir no Terminal
gradlew signingReport

MD5:  81:B5:2D:73:24:7E:B6:3F:FA:71:69:E0:2C:36:B1:D3
SHA1: 80:3B:F1:3B:09:80:33:55:0C:7D:22:DA:87:D4:12:37:04:31:5C:F8
SHA256: 33:6D:F6:9F:E4:6B:85:19:7A:DE:7C:76:2C:E7:39:46:FA:77:83:8B:5E:10:55:25:57:C2:77:22:BF:43:A1:52

MD5: 52:35:DB:09:83:E6:77:96:E8:A4:84:7C:AA:E1:7A:56
SHA1: CD:A6:53:0D:E0:4D:5B:9C:10:0C:0A:4B:75:8D:DC:F2:86:61:6E:DE
SHA-256: 2C:02:F5:5B:5C:6C:0D:83:58:05:00:B3:77:FC:E4:22:0A:C1:4D:EB:33:3F:EF:0E:64:DC:65:9F:F2:1C:C5:F9



### Ícones na aplicação
    flutter_launcher_icons: 0.7.5

  flutter_icons:
    android: true
    ios: true
    image_path: "assets/icone.png"
    adaptive_icon_background: "#FFFFFF"
    adaptive_icon_foreground: "assets/icone-adaptative.png"

   flutter pub run flutter_launcher_icons:main

### Assinando APP para Release

Create a file named <app dir>/android/key.properties that contains a reference to your keystore:

storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=key
storeFile=<location of the key store file, such as /Users/<user name>/key.jks>


Configure signing for your app by editing the <app dir>/android/app/build.gradle file.

# Tradução
https://pub.dev/packages/intl_utils

flutter pub run intl_utils:generate
