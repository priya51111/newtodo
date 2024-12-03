import 'package:equatable/equatable.dart';
import 'package:newtodo/task/models.dart';

enum TaskStatus { initial, loading, success, error }

final class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.task,
    this.taskList = const [],
    this.message = '',
  });

  final TaskStatus status;
  final  Map<String, dynamic>? task; 
  final List<Task> taskList;
  final String? message;

  static const TaskState initial = TaskState(
    status: TaskStatus.initial,
    task:{},
    taskList: [],
    message: '',
  );

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? taskList,
    String? message,
     Map<String, dynamic>? task,
  }) {
    return TaskState(
      status: status ?? this.status,
      task: task ?? this.task,
      taskList: taskList ?? this.taskList,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        task,
        taskList,
        message,
      ];
}
