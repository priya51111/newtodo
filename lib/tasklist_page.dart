import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newtodo/task/bloc/task_bloc.dart';
import 'package:newtodo/task/bloc/task_event.dart';

import 'task/bloc/task_state.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 4, 83, 147),
      appBar: AppBar(
        title: Text(
          'Task List Page',
          style: TextStyle(color: Colors.white),
        ),
           backgroundColor: Color.fromARGB(135, 33, 149, 243),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == TaskStatus.success) {
            return ListView.builder(
              itemCount: state.taskList.length,
              itemBuilder: (context, index) {
                final task = state.taskList[index];
              return Padding(
                      padding: const EdgeInsets.all(9),
                      child: Container(
                        height: 70,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(135, 33, 149, 243),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 38),
                                  child: Text(
                                    task.task,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    '${task.date} ${task.time}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ), 

                               // Di
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 150, top: 11),
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        context.read<TaskBloc>().add(
                                            deleteTask(taskId: task.taskId));
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
              },
            );
          } else {
            return const Center(child: Text('No tasks available'));
          }
        },
      ),
    );
  }
}
