
import 'dart:convert';
import 'dart:io';

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
    await file.writeAsBytes(base64.decode(data['image']));

    return outputFile;
  }
}
