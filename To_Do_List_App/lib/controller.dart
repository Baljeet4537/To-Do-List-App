import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'models.dart';

class TaskNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() => [];

  void addTask(String title) {
    state = [...state, Task(title)];
    Fluttertoast.showToast(msg: "✅ Task added");
  }

  void toggleTask(int index) {
    final updated = [...state];
    updated[index].isCompleted = !updated[index].isCompleted;
    state = updated;
    Fluttertoast.showToast(
      msg: updated[index].isCompleted ? "🎉 Task completed" : "⏳ Task pending",
    );
  }

  void updateTask(int index, String newTitle) {
    final updated = [...state];
    updated[index].title = newTitle;
    state = updated;
    Fluttertoast.showToast(msg: "✏️ Task updated");
  }

  void deleteTask(int index) {
    final taskName = state[index].title;
    final updated = [...state]..removeAt(index);
    state = updated;
    Fluttertoast.showToast(msg: "🗑️ Deleted: $taskName");
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(TaskNotifier.new);
final filterProvider = StateProvider<String>((ref) => 'All');