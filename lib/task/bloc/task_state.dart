import 'package:equatable/equatable.dart';
import 'package:newtodo/task/model.dart';

enum TaskStatus { initial, loading, success,updatesucess, error}

final class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.task,
    this.taskList = const [],
    this.message = '',
     this.tasks,
     this.time,
     this.date,
    this.deleteTask = false,
     this.isTaskSelected = false,
        this.isEditMode = false, 
  
  });

  final TaskStatus status;
  final Map<String, dynamic>? task;
  final List<Task> taskList;
  final String? message;
  final String?tasks;
  final String?time;
  final String ? date;
  final bool deleteTask;
  final bool isTaskSelected;
  final bool isEditMode;

  static const TaskState initial = TaskState();

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? taskList,
    String? message,
    Map<String, dynamic>? task,
     String?tasks,
   String?time,
  String ? date,
    bool? deleteTask,
   bool? isTaskSelected,
   bool? isEditMode,
  }) {
    return TaskState(
      status: status ?? this.status,
      task: task ?? this.task,
      taskList: taskList ?? this.taskList,
      message: message ?? this.message,
       tasks: tasks??this.tasks,
      time: time??this.time,
      date: date??this.date,
      deleteTask: deleteTask??this.deleteTask,
       isTaskSelected: isTaskSelected ?? this.isTaskSelected,
       isEditMode:isEditMode?? this.isEditMode
    );
  }

  @override
  List<Object?> get props => [
        status,
        task,
        taskList,
        message,
      
        deleteTask,
        isEditMode
      ];
}
