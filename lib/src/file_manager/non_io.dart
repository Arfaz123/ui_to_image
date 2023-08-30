import 'package:ui_to_image/ui_to_image.dart';

/// Returns an instance of the platform-specific file manager.
///
/// This function returns an instance of [PlatformFileManagerWeb], which is
/// a placeholder implementation for web platforms. It throws an
/// [UnsupportedError] when attempting to save a file.
///
/// Use this function to provide a fallback implementation for web platforms
/// where the file saving functionality is not supported.
PlatformFileManager getFileManager() => PlatformFileManagerWeb();

/// A placeholder implementation of [PlatformFileManager] for web platforms.
///
/// This implementation throws an [UnsupportedError] when attempting to save a file,
/// as file saving is not supported on web platforms.
class PlatformFileManagerWeb implements PlatformFileManager {
  @override
  Future<String> saveFile(Uint8List fileContent, String path,
      {String? name}) async {
    throw UnsupportedError("File cannot be saved in the current platform");
  }
}
