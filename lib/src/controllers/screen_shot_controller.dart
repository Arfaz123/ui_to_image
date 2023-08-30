part of ui_to_image; // This class is part of the 'ui_to_image' library

/// Controller class to manage capturing screenshots of widgets.
class ScreenShotController {
  late GlobalKey
      containerKey; // A GlobalKey used to identify the widget to capture

  /// Constructor to initialize the [containerKey].
  ScreenShotController() {
    containerKey = GlobalKey();
  }

  /// Captures the contents of the widget associated with [containerKey] as a [ui.Image].
  ///
  /// [pixelRatio] determines the resolution of the captured image.
  /// [delay] introduces a delay before capturing to account for any pending layout changes.
  /// Returns the captured [ui.Image] or null if capturing fails.
  Future<ui.Image?> captureAsUiImage(
      {double? pixelRatio = 1,
      Duration delay = const Duration(milliseconds: 20)}) {
    // Use Future.delayed to introduce a delay before capturing the image
    return Future.delayed(delay, () async {
      try {
        // Find the render object associated with the GlobalKey's current context
        var findRenderObject = containerKey.currentContext?.findRenderObject();
        if (findRenderObject == null) {
          return null; // If no render object is found, return null
        }

        // Convert the found render object to a RenderRepaintBoundary
        RenderRepaintBoundary boundary =
            findRenderObject as RenderRepaintBoundary;
        BuildContext? context = containerKey.currentContext;

        // Calculate the pixel ratio if it's not explicitly provided
        if (pixelRatio == null) {
          if (context != null) {
            pixelRatio = pixelRatio ?? MediaQuery.of(context).devicePixelRatio;
          }
        }

        // Capture the image of the boundary using the specified pixel ratio
        ui.Image image = await boundary.toImage(pixelRatio: pixelRatio ?? 1);
        return image; // Return the captured image
      } catch (e) {
        rethrow; // Rethrow any exceptions that occur during capturing
      }
    });
  }

  /// Captures the rendered representation of a widget as a [Uint8List].
  ///
  /// [widget] is the widget to capture.
  /// [pixelRatio] determines the resolution of the captured image.
  /// [delay] introduces a delay before capturing to account for any pending layout changes.
  /// [context] is the build context associated with the widget.
  /// [targetSize] specifies the size to capture.
  Future<Uint8List> captureFromWidget(
    Widget widget, {
    Duration delay = const Duration(seconds: 1),
    double? pixelRatio,
    BuildContext? context,
    Size? targetSize,
  }) async {
    // Capture the image of the widget using the widgetToUiImage method
    ui.Image image = await widgetToUiImage(
      widget,
      delay: delay,
      pixelRatio: pixelRatio,
      context: context,
      targetSize: targetSize,
    );

    // Convert the captured image to ByteData using the PNG format
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    // Dispose of the captured image to free up resources
    image.dispose();

    // Return the image bytes as Uint8List
    return byteData!.buffer.asUint8List();
  }

  /// Captures the rendered representation of a widget as a [ui.Image].
  ///
  /// [widget] is the widget to capture.
  /// [delay] introduces a delay before capturing to account for any pending layout changes.
  /// [pixelRatio] determines the resolution of the captured image.
  /// [context] is the build context associated with the widget.
  /// [targetSize] specifies the size to capture.
  static Future<ui.Image> widgetToUiImage(
    Widget widget, {
    Duration delay = const Duration(seconds: 1),
    double? pixelRatio,
    BuildContext? context,
    Size? targetSize,
  }) async {
    int retryCounter =
        3; // Number of times to retry capturing if the render is still dirty
    bool isDirty = false; // Flag indicating if the render is dirty

    Widget child = widget;

    // Modify the widget tree if a context is provided
    if (context != null) {
      child = InheritedTheme.captureAll(
        context,
        MediaQuery(
            data: MediaQuery.of(context),
            child: Material(
              color: Colors.transparent,
              child: child,
            )),
      );
    }

    // Initialize a RenderRepaintBoundary to capture the widget
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    // Obtain platform dispatcher and default view
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final fallBackView = platformDispatcher.views.first;

    // Determine the view to use for rendering
    final view =
        context == null ? fallBackView : View.maybeOf(context) ?? fallBackView;

    // Determine logical and image sizes
    Size logicalSize = targetSize ?? view.physicalSize / view.devicePixelRatio;
    Size imageSize = targetSize ?? view.physicalSize;

    // Ensure aspect ratios are within a close range
    assert(logicalSize.aspectRatio.toStringAsPrecision(5) ==
        imageSize.aspectRatio.toStringAsPrecision(5));

    // Create a RenderView for rendering the widget
    final RenderView renderView = RenderView(
      view: view,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: pixelRatio ?? 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(
      focusManager: FocusManager(),
      onBuildScheduled: () {
        // Mark the current render as dirty
        isDirty = true;
      },
    );

    // Set the root node and prepare initial frame
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: child,
      ),
    ).attachToRenderTree(buildOwner);

    // Render the widget tree
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    ui.Image? image;

    do {
      // Reset the dirty flag
      isDirty = false;

      // Capture the image from the repaint boundary
      image = await repaintBoundary.toImage(
          pixelRatio: pixelRatio ?? (imageSize.width / logicalSize.width));

      // Introduce a delay before checking if a rebuild is needed
      await Future.delayed(delay);

      // Check if the render is still dirty and requires a rebuild
      if (isDirty) {
        // Re-render the widget and update the render tree
        buildOwner.buildScope(rootElement);
        buildOwner.finalizeTree();
        pipelineOwner.flushLayout();
        pipelineOwner.flushCompositingBits();
        pipelineOwner.flushPaint();
      }
      retryCounter--;
    } while (isDirty && retryCounter >= 0);

    try {
      // Finalize the render tree
      buildOwner.finalizeTree();
    } catch (e) {
      rethrow;
    }

    // Return the captured image
    return image; // Adapted to directly return the image and not the Uint8List
  }

  /// Captures the rendered representation of a long widget as a [ui.Image].
  ///
  /// [widget] is the widget to capture.
  /// [delay] introduces a delay before capturing to account for any pending layout changes.
  /// [pixelRatio] determines the resolution of the captured image.
  /// [context] is the build context associated with the widget.
  /// [constraints] specify the constraints for rendering the widget.
  Future<ui.Image> longWidgetToUiImage(Widget widget,
      {Duration delay = const Duration(seconds: 1),
      double? pixelRatio,
      BuildContext? context,
      BoxConstraints constraints = const BoxConstraints(
        maxHeight: double.maxFinite,
      )}) async {
    final PipelineOwner pipelineOwner =
        PipelineOwner(); // Pipeline owner for rendering
    final _MeasurementView rootView = pipelineOwner.rootNode =
        _MeasurementView(constraints); // Root node for measurement

    final BuildOwner buildOwner = BuildOwner(
        focusManager:
            FocusManager()); // Build owner for managing the render tree
    final RenderObjectToWidgetElement<RenderBox> element =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: rootView,
      debugShortDescription: 'root_render_element_for_size_measurement',
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    ).attachToRenderTree(buildOwner); // Attach widget to render tree

    try {
      rootView.scheduleInitialLayout(); // Schedule initial layout
      pipelineOwner.flushLayout(); // Flush layout calculations

      return widgetToUiImage(
        widget,
        targetSize: rootView.size, // Use measured size as target size
        context: context,
        delay: delay,
        pixelRatio: pixelRatio,
      );
    } finally {
      // Clean up by updating the render tree and finalizing build
      element
          .update(RenderObjectToWidgetAdapter<RenderBox>(container: rootView));
      buildOwner.finalizeTree();
    }
  }
}
