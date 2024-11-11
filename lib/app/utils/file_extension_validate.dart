import 'package:print_script/app/consts/const_extensions_file.dart';

class FileExtensionValidate {
  /// Take the name of the file and divide it using the character ".",
  ///  into several parts of the file, I didn't consider taking position 1 in the list,
  ///  as a joker can do this image.php.jpg,
  /// then taking the last possible position in the list,
  /// regardless of whether did the right thing which is file_name.js
  /// or file_name.js.jpg, it takes the last extension passed which is the valid one
  static bool check({required String fileName}) {
    List<String> partsName = fileName.split(".");
    if (extensionsAlloweds.contains(partsName[partsName.length - 1])) {
      return true;
    }
    return false;
  }
}
