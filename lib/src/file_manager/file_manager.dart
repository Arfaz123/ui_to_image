import 'package:ui_to_image/ui_to_image.dart';

/// An abstract class that defines a platform-specific file manager interface.
///
/// This class provides an abstract interface for saving files with platform-specific
/// implementations. The factory constructor is used to obtain an instance of the
/// platform-specific file manager.
abstract class PlatformFileManager {
  /// Factory constructor to obtain an instance of the platform-specific file manager.
  factory PlatformFileManager() => getFileManager();

  /// Saves the provided file content to the specified path with an optional name.
  ///
  /// This method saves the file content to the given path using the platform-specific
  /// implementation. An optional [name] parameter can be provided for the file name.
  /// Returns the path where the file is saved.
  Future<String> saveFile(Uint8List fileContent, String path, {String? name});
}
