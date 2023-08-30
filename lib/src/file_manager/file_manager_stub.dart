import 'package:ui_to_image/ui_to_image.dart';

/// Returns an instance of the platform-specific file manager.
///
/// This function returns a placeholder implementation that throws an
/// [UnimplementedError] with a message indicating that the file picker
/// is not implemented in the current platform.
///
/// Use this function to provide a fallback implementation when the file picker
/// functionality is not available on a particular platform.
PlatformFileManager getFileManager() => throw UnimplementedError(
    "File Picker is Not Implemented in the current platform");
