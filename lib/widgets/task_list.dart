import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newtodo/task/bloc/task_bloc.dart';
import 'package:newtodo/task/bloc/task_event.dart';
import 'package:newtodo/task/bloc/task_state.dart';


class TaskListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state.status == TaskStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == TaskStatus.success) {
          return ListView.builder(
            itemCount: state.taskList.length,
            itemBuilder: (context, index) {
              final task = state.taskList[index];
              return GestureDetector(
                onTap: () {
                  context.read<TaskBloc>().add(UpdateTask(
                      taskId: task.taskId,
                      task: task.task,
                      date: task.date,
                      time: task.time,
                      menuId: task.menuId,
                      isfinished: task.isFinished,
                      isEditMode: true));
                  context.push('/taskpage');
                },
                child:  Padding(
                      padding: const EdgeInsets.all(9),
                      child: Container(
                        height: 70,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                           color: Color.fromARGB(255, 24, 85, 136),
                        ),
                        child: Row(
                          children: [
                          
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 100),
                                  child: Text(
                                    task.task,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: Text(
                                    '${task.date}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(135, 33, 149, 243),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 85),
                                  child: Text(
                                    "${task.time}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              );
            },
          );
        } else {
          return const Center(child: Text('No tasks available'));
        }
      },
    );
  }
}
