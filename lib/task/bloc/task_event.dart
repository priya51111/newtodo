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
