import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageStorage {
  static Future<String> saveImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = File('${directory.path}/$fileName');
    await imageFile.copy(savedImage.path);
    return savedImage.path;
  }

  static Future<File?> getImage(String imagePath) async {
    final file = File(imagePath);
    return file.existsSync() ? file : null;
  }
}
