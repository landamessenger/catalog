import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

abstract class ServiceWorker {
  bool serviceStarted = false;

  final ip = '127.0.0.1';

  final port = 12345;

  Future Function() closeServer = () async {
    // nothing to do here
  };

  Future<void> start() async {
    try {
      if (serviceStarted) {
        print('Server already started in $ip:$port');
        return;
      }

      serviceStarted = true;

      final handler = const Pipeline()
          .addMiddleware(logRequests())
          .addHandler(_echoRequest);

      final server = await shelf_io.serve(handler, ip, port);
      closeServer = () async {
        await server.close(force: true);
      };
      print('Server WebSocket in http://${server.address.host}:${server.port}');
    } catch (e) {
      serviceStarted = false;
      print('Error starting server: $e');
    }
  }

  Future<Response> _echoRequest(Request request) async {
    final result = await processRequest(await request.readAsString());
    return Response.ok(result);
  }

  Future<void> stop() async {
    await closeServer();
    serviceStarted = false;
  }

  Future<String> processRequest(String requestData);
}
