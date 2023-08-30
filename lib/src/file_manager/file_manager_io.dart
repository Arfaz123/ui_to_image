import 'package:ui_to_image/ui_to_image.dart';

/// A platform-specific implementation of the [PlatformFileManager] interface for Windows.
///
/// This class implements the methods required to save files on the Windows platform.
class PlatformFilePickerWindows implements PlatformFileManager {
  @override
  Future<String> saveFile(Uint8List fileContent, String path,
      {String? name}) async {
    // If no name is provided, generate a name based on the current timestamp
    name = name ?? "${DateTime.now().microsecondsSinceEpoch}.png";

    // Create the file at the specified path with the provided name
    File file = await File("$path/$name").create(recursive: true);

    // Write the file content as bytes
    file.writeAsBytesSync(fileContent);

    // Return the path where the file is saved
    return file.path;
  }
}

/// Returns an instance of the platform-specific file manager for Windows.
///
/// This function returns an instance of [PlatformFilePickerWindows] as the
/// platform-specific implementation of the [PlatformFileManager] interface.
PlatformFileManager getFileManager() => PlatformFilePickerWindows();
