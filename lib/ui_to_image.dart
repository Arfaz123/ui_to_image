/// This is the main library for the UI to Image package.
library ui_to_image;

// Import necessary Dart libraries
import 'dart:ui' as ui;

import 'package:ui_to_image/ui_to_image.dart';

// Export commonly used Dart libraries and packages
export 'dart:io';
export 'dart:typed_data';

export 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
export 'package:flutter/material.dart';
export 'package:flutter/rendering.dart';
export 'package:path_provider/path_provider.dart';
// Import platform-specific file manager classes based on the current platform
export 'package:ui_to_image/src/file_manager/file_manager.dart';
export 'package:ui_to_image/src/file_manager/file_manager_stub.dart'
    if (dart.library.io) 'package:ui_to_image/src/file_manager_io.dart'
    if (dart.library.html) 'package:ui_to_image/src/non_io.dart';

// Part files that complete the library
part 'src/controllers/custome_image_generator.dart';
part 'src/controllers/measurement_view.dart';
part 'src/controllers/screen_shot.dart';
part 'src/controllers/screen_shot_controller.dart';
part 'src/controllers/screen_shot_state.dart';
