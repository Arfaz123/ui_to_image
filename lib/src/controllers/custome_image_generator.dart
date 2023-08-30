part of ui_to_image;

/// A utility class for generating custom images from widgets with text.
class UiToImage {
  /// The custom widget design to be rendered in the image.
  final Widget? customDesign;

  /// The custom text to be added to the image.
  final String? customText;

  /// The name of the generated image file.
  final String? generatedImageName;

  /// The MIME type of the generated image.
  final String? mimeType;

  /// The title to be used when sharing the generated image.
  final String? shareTitle;

  /// The bytes of the generated image.
  Uint8List? bytes;

  /// Creates a [UiToImage] instance.
  ///
  /// You can provide a [customDesign] widget that represents the design to be captured.
  /// [customText] is an optional parameter to add custom text to the image.
  /// [generatedImageName] is the desired name of the generated image file.
  /// [mimeType] specifies the MIME type of the generated image.
  /// [shareTitle] is the title to be used when sharing the generated image.
  UiToImage({
    this.customDesign,
    this.customText,
    this.generatedImageName,
    this.mimeType,
    this.shareTitle,
  });

  /// Generates a custom image from the provided widget and text.
  ///
  /// This method captures the provided [customDesign] widget and generates
  /// an image. The generated image is stored in the [bytes] field. The [generatedImageName]
  /// is used as the filename when saving the image. Returns `true` if the image is generated
  /// and saved successfully, otherwise returns `false`.
  Future<bool> generateImage() async {
    try {
      final controller = ScreenShotController();
      final customWidget = Material(child: customDesign!);

      // Capture the custom widget and get the generated image bytes
      final bytes = await controller.captureFromWidget(customWidget);

      // Store the generated image bytes
      this.bytes = bytes;

      // Save the generated image and return the result
      return await _saveImage(bytes);
    } catch (e) {
      _handleError("Error generating image: $e");
      return false;
    }
  }

  /// Shares the generated custom image.
  ///
  /// This method uses the Share package to share the generated custom image.
  /// If the image bytes are not available, an error message will be displayed.
  Future<void> shareImage() async {
    try {
      if (bytes == null) {
        _handleError("No image available for sharing.");
        return; // Exit the method if no image is available
      }

      // Share the generated image using the Share package
      await Share.file(
        shareTitle ?? 'Share via', // Title for the share dialog
        generatedImageName ??
            'CustomImageGenerator.png', // Name of the shared file
        bytes!, // Image bytes to be shared
        mimeType ?? 'image/png', // MIME type of the shared file
        text: customText ??
            "Elevate your app's presentation with the 'ui_to_image' package for Flutter! Transform your UI designs into captivating images 🎉, highlight app features with text 📝, and share them effortlessly. Spark visual interest in your app today! 💥 #Flutter #ui_to_image", // Optional text to accompany the shared image
      );
    } catch (e) {
      _handleError(
          "Error sharing image: $e"); // Handle any errors that occur during sharing
    }
  }

  /// Loads the last saved custom image.
  ///
  /// This method attempts to load the last saved custom image from the application's
  /// documents directory. If a saved image is found, its bytes are stored in the
  /// [bytes] field and the image file is returned. If no saved image is found,
  /// the method returns null.
  Future<File?> loadLastImage() async {
    try {
      final appStorage =
          await getApplicationDocumentsDirectory(); // Get the application's documents directory
      final file = File(
          '${appStorage.path}/CustomImageGenerator.png'); // Define the path to the saved image file

      if (file.existsSync()) {
        final bytes =
            await file.readAsBytes(); // Read the image bytes from the file
        this.bytes = bytes; // Store the loaded image bytes
        return file; // Return the loaded image file
      }

      return null; // Return null if no saved image is found
    } catch (e) {
      _handleError(
          "Error loading saved image: $e"); // Handle any errors that occur during loading
      return null;
    }
  }

  /// Handles errors by throwing an exception with the provided error message.
  ///
  /// This method is used to handle errors that occur during various operations.
  /// It throws an exception with the provided [errorMessage], which can be caught
  /// and handled further up the call stack.
  ///
  /// Usage example:
  /// ```dart
  /// try {
  ///   // Code that might throw an error
  /// } catch (e) {
  ///   _handleError("An error occurred: $e");
  /// }
  /// ```
  void _handleError(String errorMessage) {
    throw errorMessage; // Throw an exception with the error message
  }

  /// Saves the provided image bytes to a file.
  ///
  /// This method saves the provided [bytes] to a file named 'CustomImageGenerator.png'
  /// in the application's documents directory. Returns `true` if the image bytes
  /// are successfully written to the file, otherwise returns `false`.
  Future<bool> _saveImage(Uint8List bytes) async {
    try {
      final appStorage =
          await getApplicationDocumentsDirectory(); // Get the application's documents directory
      final file = File(
          '${appStorage.path}/CustomImageGenerator.png'); // Define the path to the image file

      // Write the image bytes to the file and return true when completed
      return await file.writeAsBytes(bytes).then((value) {
        return true;
      });
    } catch (e) {
      _handleError(
          "Error saving image: $e"); // Handle any errors that occur during saving
      return false;
    }
  }
}
