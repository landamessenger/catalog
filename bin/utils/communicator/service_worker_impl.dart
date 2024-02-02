import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
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

    final mode = (data['mode'] as String?) ?? 'blank';

    final height = (data['height'] as num).toInt();
    final width = (data['width'] as num).toInt();

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
        mode,
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
    String mode,
    String path,
    Uint8List screenshotData,
    int width,
    int height,
  ) async {
    Image? screenshotImage = decodeImage(screenshotData);
    if (screenshotImage == null) {
      return;
    }

    Image? baseImage;

    if (mode == 'blurHash') {
      baseImage = createBlurHashImage(width, height, screenshotImage);
    } else {
      baseImage = createBlankImage(width, height);
    }

    if (baseImage == null) {
      return;
    }

    screenshotImage = checkImage(baseImage, screenshotImage);

    int x = (width - screenshotImage.width) ~/ 2;
    int y = (height - screenshotImage.height) ~/ 2;

    drawImage(baseImage, screenshotImage, x, y);

    await File(path).writeAsBytes(encodePng(baseImage));
  }

  Image? createBlankImage(int width, int height) {
    final baseImage = Image(width: width, height: height);
    fill(
      baseImage,
      color: ColorRgba8(
        255,
        255,
        255,
        255,
      ),
    );
    return baseImage;
  }

  Image? createBlurHashImage(int width, int height, Image imageToJoin) {
    final blurHash = BlurHash.encode(imageToJoin, numCompX: 4, numCompY: 3);
    return blurHash.toImage(width, height);
  }

  /// Adjust image size to the base image
  Image checkImage(Image base, Image imageToJoin) {
    if (imageToJoin.height < base.height && imageToJoin.width < base.width) {
      return imageToJoin;
    }

    if ((imageToJoin.width / base.width) > (imageToJoin.height / base.height)) {
      int newWidth = base.width;
      int newHeight =
          ((newWidth / imageToJoin.width) * imageToJoin.height).round();

      return copyResize(imageToJoin, width: newWidth, height: newHeight);
    } else {
      int newHeight = base.height;
      int newWidth =
          ((newHeight / imageToJoin.height) * imageToJoin.width).round();

      return copyResize(imageToJoin, width: newWidth, height: newHeight);
    }
  }

  /// Draw the image over the base
  void drawImage(Image dst, Image src, int dstX, int dstY) {
    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        final color = src.getPixel(x, y);
        if (color.a == 0) {
          /// ignore alpha channel
          continue;
        }
        dst.setPixel(x + dstX, y + dstY, color);
      }
    }
  }
}
