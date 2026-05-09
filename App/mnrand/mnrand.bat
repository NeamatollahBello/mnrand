chcp 65001
copy /Y .\lib\my_reader_and.dart1 .\lib\my_reader.dart
copy /Y .\lib\apptypemanara.dart1 .\lib\apptype.dart
copy /Y mnrand.yaml pubspec.yaml
cmd /c flutter pub get
cmd /c dart run change_app_package_name:main aram.mnrand --android
cmd /c dart run rename_app:main android="المنارة أندرويد"
cmd /c dart run flutter_launcher_icons
pause