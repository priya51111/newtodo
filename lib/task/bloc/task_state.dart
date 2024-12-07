import 'package:equatable/equatable.dart';
import 'package:newtodo/task/models.dart';

enum TaskStatus { initial, loading, success, error }

final class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.task,
    this.taskList = const [],
    this.message = '',
    this.tasks = false,
  });

  final TaskStatus status;
  final Map<String, dynamic>? task;
  final List<Task> taskList;
  final String? message;
  final bool tasks;

  static const TaskState initial = TaskState();

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? taskList,
    String? message,
    Map<String, dynamic>? task,
    bool? tasks, // Made nullable
  }) {
    return TaskState(
      status: status ?? this.status,
      task: task ?? this.task,
      taskList: taskList ?? this.taskList,
      message: message ?? this.message,
      tasks: tasks ?? this.tasks, // Fixed to use this.tasks
    );
  }

  @override
  List<Object?> get props => [
        status,
        task,
        taskList,
        message,
        tasks,
      ];
}
