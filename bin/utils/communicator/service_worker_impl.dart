
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
    final file = File("test_image.png");
    final data = jsonDecode(requestData);
    print(requestData);
    await file.writeAsBytes(base64.decode(data['image']));
    return 'work_done: $requestData';
  }
}
