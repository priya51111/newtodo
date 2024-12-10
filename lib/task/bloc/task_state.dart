import 'package:equatable/equatable.dart';
import 'package:newtodo/task/models.dart';

enum TaskStatus { initial, loading, success, error }

final class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.task,
    this.taskList = const [],
    this.message = '',
    this.updatetask = false,
    this.deleteTask = false,
     this.isTaskSelected = false,
  });

  final TaskStatus status;
  final Map<String, dynamic>? task;
  final List<Task> taskList;
  final String? message;
  final bool updatetask;
  final bool deleteTask;
  final bool isTaskSelected;

  static const TaskState initial = TaskState();

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? taskList,
    String? message,
    Map<String, dynamic>? task,
    bool? updatetask,
    bool? deleteTask,
   bool? isTaskSelected,
  }) {
    return TaskState(
      status: status ?? this.status,
      task: task ?? this.task,
      taskList: taskList ?? this.taskList,
      message: message ?? this.message,
      updatetask: updatetask ?? this.updatetask, 
      deleteTask: deleteTask??this.deleteTask,
       isTaskSelected: isTaskSelected ?? this.isTaskSelected,
    );
  }

  @override
  List<Object?> get props => [
        status,
        task,
        taskList,
        message,
        updatetask,
        deleteTask
      ];
}
