import 'package:todo/shared/network/local/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';

class WorkManager {

  void registerMyTask()async{
    await Workmanager().registerPeriodicTask(
      "id1",
      "Show Basic Notification",
      frequency: const Duration(minutes: 15),
    );
  }

  Future<void> init() async {
    await Workmanager().initialize(
      actionTasks,
      isInDebugMode: true,
    );
    registerMyTask();
  }

  void cancelTask(String uniqueName) {
    Workmanager().cancelByUniqueName(uniqueName);
  }
}

@pragma('vm:entry-point')
void actionTasks() {
  Workmanager().executeTask((task, inputData){
    LocalNotificationService.dailyScheduledNotification();
    return Future.value(true);
  });
}