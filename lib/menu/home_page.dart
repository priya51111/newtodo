import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../task/bloc/task_bloc.dart';
import '../task/bloc/task_state.dart';
import '../widgets/dropdown_menu.dart';
import '../widgets/task_list.dart';
import '../widgets/popup_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(134, 4, 83, 147),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(135, 33, 149, 243),
        title: Row(
          children: [
            const Icon(Icons.check_circle, size: 30, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownMenuWidget(),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          buildPopupMenu(context),
        ],
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == TaskStatus.updatesucess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task updated successfully!')),
            );
          } else if (state.status == TaskStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task update failed: ${state.message}')),
            );
          }
        },
        child: TaskListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/taskpage');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
