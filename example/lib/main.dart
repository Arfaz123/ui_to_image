import 'package:ui_to_image/ui_to_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Generator Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Initialize CustomImageGenerator with custom design and parameters
  final UiToImage imageGenerator = UiToImage(
    customDesign: Container(
      height: 400,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Generated Image',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Divider(
            color: Colors.white70,
            height: 20,
            thickness: 1,
          ),
          Text(
            // Explanation of the package usage
            '○ Import the package: Import the UiToImage class from your package.\n'
            '○ Create a design: Design your custom widget (e.g., a container with text).\n'
            '○ Initialise the package: Create an instance of UiToImage, passing your custom design and other optional parameters.\n'
            '○ Generate image: Call the generateImage() method to capture your design as an image.\n'
            '○ Share image: Call the shareImage() method to share the generated image.\n'
            '○ Load image: Call the loadImage() method to load a previously generated image.\n'
            '○ Error handling: The package handles errors with custom toasts or debug prints, based on your preference.',
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
    customText:
        "Elevate your app's presentation with the 'UiToImage' package for Flutter! Transform your UI designs into captivating images 🎉, highlight app features with text 📝, and share them effortlessly. Spark visual interest in your app today! 💥 #Flutter #UiToImage",
    generatedImageName: 'custom_image.png',
    mimeType: 'image/png',
    shareTitle: 'Share via',
  );

  File? imagepath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Generator Example'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the custom design from the imageGenerator
              imageGenerator.customDesign!,
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Generate and load the image
                  await imageGenerator.generateImage().then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image generated!')),
                      );
                      imageGenerator.loadLastImage().then((value) {
                        setState(() {
                          imagepath = value;
                        });
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to generate image')),
                      );
                    }
                  });
                },
                child: const Text('Sample UI'),
              ),
              // Display the generated image if available
              if (imagepath != null) Image.file(imagepath!),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Share the generated image
                  await imageGenerator.shareImage();
                },
                child: const Text('Share Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
