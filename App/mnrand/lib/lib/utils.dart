import 'package:intl/intl.dart';
import 'package:tafqit/tafqit.dart';

final NumberFormat float2ArFormat = NumberFormat(',###.##', 'ar');
final NumberFormat float3ArFormat = NumberFormat(',###.###', 'ar');
final NumberFormat float2EnFormat = NumberFormat(',###.##', 'en');
final NumberFormat float3EnFormat = NumberFormat(',###.###', 'en');

Tafqit _t = Tafqit();
String onlyStr(double ammount, TafqitUnitCode unit) {
  return _t.tafqitNumberWithParts(listOfNumberAndParts: [
        ammount.truncate(),
        (ammount * 100).round() % 100
      ], tafqitUnitCode: unit) ??
      '';
}
