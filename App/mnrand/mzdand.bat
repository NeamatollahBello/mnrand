chcp 65001
copy /Y .\lib\my_reader_and.dart1 .\lib\my_reader.dart
copy /Y .\lib\apptypemazeed.dart1 .\lib\apptype.dart
copy /Y mzdand.yaml pubspec.yaml
cmd /c flutter pub get
cmd /c dart run change_app_package_name:main aram.mzdand --android
cmd /c dart run rename_app:main android="المزيد أندرويد"
cmd /c dart run flutter_launcher_icons
pause