
# UiToImage

[![Pub Version](https://img.shields.io/pub/v/ui_to_image)](https://pub.dev/packages/ui_to_image)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ

A Flutter package that enables easy generation and sharing of images from custom UI designs.

## Features

- Generate captivating images from custom UI designs.
- Highlight app features with custom text.
- Share generated images seamlessly.
- Load previously generated images.
- Error handling with customizable toasts or debug prints.

---

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Import](#import-the-package)
  - [Create Instance](#create-a-uitoimage-instance)
  - [Generate and Share Images](#generate-and-share-images)
  - [Load a Previously Generated Image](#load-a-previously-generated-image)
- [Example](#example)
- [Contributing](#contributing)
- [License](#license)

---

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  ui_to_image: <latest_version>
```
## IMPORTANT Note for iOS
If you are starting a new fresh app, you need to create the Flutter App with `flutter create -i swift` (see [flutter/flutter#13422 (comment)](https://github.com/flutter/flutter/issues/13422#issuecomment-392133780)), otherwise, you will get this message:
```
=== BUILD TARGET flutter_inappbrowser OF PROJECT Pods WITH CONFIGURATION Debug ===
The "Swift Language Version" (SWIFT_VERSION) build setting must be set to a supported value for targets which use Swift. Supported values are: 3.0, 4.0, 4.2. This setting can be set in the build settings editor.
```

If you still have this problem, try to edit iOS `Podfile` like this (see [#15](https://github.com/pichillilorenzo/flutter_inappbrowser/issues/15)):
```
target 'Runner' do
  use_frameworks!  # required by simple_permission
  ...
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'  # required by simple_permission
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

Instead, if you have already a non-swift project, you can check this issue to solve the problem: [Friction adding swift plugin to objective-c project](https://github.com/flutter/flutter/issues/16049).

## Usage

## Import the package

First, import the `ui_to_image` package in your Dart file:

```dart
import 'package:ui_to_image/ui_to_image.dart';
```

## Create a UiToImage instance

Create an instance of `UiToImage` by providing your custom UI design widget, along with other optional parameters:

```dart
final UiToImage imageGenerator = UiToImage(
  customDesign: YourCustomWidget(), // Your custom UI design widget
  customText: "Custom text to highlight features",
  generatedImageName: 'custom_image.png',
  mimeType: 'image/png',
  shareTitle: 'Share via',
);
```

Replace `YourCustomWidget()` with the actual widget that represents your custom UI design.

## Generate and share images

To generate an image from your custom UI design and share it, use the `generateImage()` method. If the image is generated successfully, you can then call the `shareImage()` method to share it:

```dart
// Generate and display the image
await imageGenerator.generateImage().then((success) {
  if (success) {
    // Image generated successfully
    imageGenerator.shareImage(); // Share the generated image
  } else {
    // Error generating image
  }
});
```

## Load a previously generated image

You can use the `loadLastImage()` method to load a previously generated image:

```dart
File? imageFile = await imageGenerator.loadLastImage();
if (imageFile != null) {
  // Display the loaded image
}
```

This can be useful for scenarios where you want to display or process a previously generated image.

---

## Note: Limitations on Widget Support

Please note that as of the current version, the package does not fully support `ListView`, `GridView`, or `CustomScrollView` widgets. It's recommended to avoid using these widgets directly within your custom design, as they may not be captured accurately in the generated image. However, we're actively working to improve widget support in upcoming versions.

---

## Example

Check out the [example](https://github.com/yourusername/ui_to_image/tree/main/example) directory for a full working example.

---

## Contributing

Contributions are welcome! If you find a bug or want to add a new feature, feel free to open an issue or submit a pull request.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Get in touch

If you have any questions, feel free to reach out:

- Email: chhapawalaarfaz@gmail.com
- GitHub: [@Arfaz123](https://github.com/Arfaz123)
- LinkedIn: [@Arfaz Chhapawala](https://www.linkedin.com/in/arfaz-chhapawala-501357234)
- YouTube: [@devfaaz](https://www.youtube.com/@devfaaz)

---

## Contributing

Contributions to the `ui_to_image` package are welcome! Please read the [contribution guidelines](CONTRIBUTING.md) before submitting a pull request.

## Contributors

<a href="https://github.com/Arfaz123/ui_to_image/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=Arfaz123/ui_to_image" />
</a>

---

Feel free to explore the features of the `ui_to_image` package and customize it to suit your needs. If you have any questions or feedback, don't hesitate to reach out. Happy coding!
