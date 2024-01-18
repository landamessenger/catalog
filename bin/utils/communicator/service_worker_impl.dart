import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

import 'service_worker.dart';

class ServiceWorkerImpl extends ServiceWorker {
  static ServiceWorkerImpl? _instance;

  ServiceWorkerImpl._internal();

  factory ServiceWorkerImpl() {
    _instance ??= ServiceWorkerImpl._internal();
    return _instance!;
  }

  @override
  Future<String> processRequest(String requestData) async {
    final data = jsonDecode(requestData);

    final height = data['height'] as int;
    final width = data['width'] as int;

    final outputFolder = data['outputFolder'] as String;
    final folder = Directory(outputFolder);
    if (!await folder.exists()) {
      print('📁 Creating output folder: $outputFolder');
    }

    await folder.create(
      recursive: true,
    );

    final fileName = data['fileName'] as String;
    final outputFile = '$outputFolder$fileName';
    final file = File(outputFile);
    if (!await file.exists()) {
      print('🖼️ Writing file: $outputFile');
    } else {
      print('🖼️ Overwriting file: $outputFile');
    }

    final screenshotData = base64.decode(data['image']);

    if (height > 0.0 && width > 0.0) {
      await createImage(
        outputFile,
        screenshotData,
        width.toInt(),
        height.toInt(),
      );
    } else {
      await file.writeAsBytes(screenshotData);
    }

    return outputFile;
  }

  Future<void> createImage(
    String path,
    Uint8List screenshotData,
    int width,
    int height,
  ) async {
    Image blankImage = Image(width: width, height: height);
    fill(
      blankImage,
      color: ColorRgba8(
        255,
        255,
        255,
        255,
      ),
    );

    Image? screenshotImage = decodeImage(screenshotData);
    if (screenshotImage == null) {
      return;
    }

    int x = (width - screenshotImage.width) ~/ 2;
    int y = (height - screenshotImage.height) ~/ 2;

    drawImage(blankImage, screenshotImage, x, y);

    await File(path).writeAsBytes(encodePng(blankImage));
  }

  void drawImage(Image dst, Image src, int dstX, int dstY) {
    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        final color = src.getPixel(x, y);
        dst.setPixel(x + dstX, y + dstY, color);
      }
    }
  }
}
