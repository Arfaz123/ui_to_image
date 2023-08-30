part of ui_to_image; // Assuming this file is part of a file named 'ui_to_image.dart'

/// A widget that captures the rendered image of its child.
///
/// This widget captures the rendered image of its child using the provided
/// [ScreenShotController] and makes it available for further processing.
class Screenshot extends StatefulWidget {
  /// The child widget whose image will be captured.
  final Widget? child;

  /// The controller responsible for capturing screenshots.
  final ScreenShotController controller;

  /// Creates a [Screenshot] widget with the specified [child] and [controller].
  const Screenshot({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  State<Screenshot> createState() {
    return ScreenshotState();
  }
}
