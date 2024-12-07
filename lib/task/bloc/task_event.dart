import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskCreated extends TaskEvent {
  final String task;
  final String date;
  final String time;
 

  TaskCreated({
    required this.task,
    required this.date,
    required this.time,
    
  });

  @override
  List<Object> get props => [task, date, time];
}
class FetchTask extends TaskEvent {
  final String userId;
  final String date;

 

  FetchTask({
    required this.userId,
    required this.date,
    
  });

  @override
  List<Object> get props => [userId, date];
}

class UpdateTask extends TaskEvent {
  final String taskId;
  final String task;
  final String date;
  final String time;
  final String menuId;
  final bool isfinished;
  UpdateTask(
      {required this.taskId,
      required this.task,
      required this.date,
      required this.time,
      required this.menuId,
      required this.isfinished});
}
class deleteTask extends TaskEvent {
  final String taskId;

  deleteTask({required this.taskId});
}

