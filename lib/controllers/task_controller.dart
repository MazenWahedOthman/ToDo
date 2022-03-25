import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;

  Future<int> addTask(Task task) async {
    return await DBHelper.insert(task);
  }

  getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((date) => Task.fromJson(date)).toList());
  }
  deleteAllTask() async{
    await DBHelper.deleteAll();
    getTasks();
  }
  deleteTask(Task task) async{
     await DBHelper.delete(task);
     getTasks();
  }


  markUsCompleted(int id) async{
    await DBHelper.update(id);
    getTasks();

  }
}
