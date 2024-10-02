import '../../utils/communicator/service_worker_impl.dart';
import '../base/base_task.dart';

class ServerTask extends BaseTask {
  @override
  Future<void> work(List<String> args) async {
    await ServiceWorkerImpl().start();
  }
}
