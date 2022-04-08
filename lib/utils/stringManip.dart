// ignore_for_file: file_names

extension CapExtension on String {
  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstofEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

class StringManip {
  String getFirstLetter(string) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    for (var i = 0; i < 1; i++) {
      buffer.write(split[i][0]);
    }
    return buffer.toString();
  }
}
