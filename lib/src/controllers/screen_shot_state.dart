part of ui_to_image; // Assuming this file is part of a file named 'ui_to_image.dart'

/// The state for the [Screenshot] widget.
///
/// This class manages the state for the [Screenshot] widget and is responsible
/// for initializing the [ScreenShotController] and building the widget tree
/// with a [RepaintBoundary] to capture the rendered content.
class ScreenshotState extends State<Screenshot> with TickerProviderStateMixin {
  late ScreenShotController
      controller; // The controller to manage screenshot capturing

  @override
  void initState() {
    super.initState();

    // Initialize the controller using the provided controller from the widget
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget tree with a RepaintBoundary to capture the rendered content
    return RepaintBoundary(
      key: controller.containerKey, // Use the controller's GlobalKey as the key
      child: widget.child, // Render the child widget to capture
    );
  }
}
