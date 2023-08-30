part of ui_to_image; // Assuming this file is part of a file named 'ui_to_image.dart'

/// A custom render box used for measuring the layout constraints of a child.
///
/// This class is used to measure the layout constraints of a child widget. It
/// is part of the rendering process to ensure that the child widget is laid out
/// correctly within its parent.
class _MeasurementView extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  final BoxConstraints boxConstraints;

  /// Creates a [_MeasurementView] with the specified [boxConstraints].
  _MeasurementView(this.boxConstraints);

  @override
  void performLayout() {
    assert(child != null); // Ensure that a child widget is provided
    child!.layout(boxConstraints,
        parentUsesSize:
            true); // Layout the child widget using the provided constraints
    size = child!
        .size; // Set the size of this render box to match the child's size
  }

  @override
  void debugAssertDoesMeetConstraints() =>
      true; // In debug mode, asserts if constraints are not met (not relevant in this context)
}
