import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller.dart';




class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final filter = ref.watch(filterProvider);

    final filteredTasks = filter == 'All'
        ? tasks
        : filter == 'Completed'
        ? tasks.where((t) => t.isCompleted).toList()
        : tasks.where((t) => !t.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("📝 To-Do List"),

      ),
      body: filteredTasks.isEmpty
          ? const Center(child: Text("No tasks yet, add one!"))
          : ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          final actualIndex = tasks.indexOf(task);

          return Dismissible(
            key: ValueKey(task.title + index.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) =>
                ref.read(taskProvider.notifier).deleteTask(actualIndex),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (_) =>
                    ref.read(taskProvider.notifier).toggleTask(actualIndex),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      final controller =
                      TextEditingController(text: task.title);
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Edit Task"),
                          content: TextField(controller: controller),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (controller.text.trim().isNotEmpty) {
                                  ref
                                      .read(taskProvider.notifier)
                                      .updateTask(
                                      actualIndex, controller.text);
                                }
                                Navigator.pop(context);
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => ref
                        .read(taskProvider.notifier)
                        .deleteTask(actualIndex),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final controller = TextEditingController();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Add Task"),
              content: TextField(controller: controller),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      ref
                          .read(taskProvider.notifier)
                          .addTask(controller.text.trim());
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const ProviderScope(child: MaterialApp(

      debugShowCheckedModeBanner: false,
      home: TodoApp())));
}
