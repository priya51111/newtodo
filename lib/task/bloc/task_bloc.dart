import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:newtodo/task/bloc/task_event.dart';
import 'package:newtodo/task/bloc/task_state.dart';

import '../repo/repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(TaskState.initial) {
    on<TaskCreated>(_onTaskCreated);
  }
  final TaskRepository _taskRepository;
  final Logger logger = Logger();
  Future <void >_onTaskCreated(
    TaskCreated event,
    Emitter<TaskState> emit,
  )async{
    try {
    emit(state.copyWith(status: TaskStatus.loading));
    final taskcreation = await _taskRepository.CreateTask(event.task, event.date, event.time);
    logger.d('TaskBloc:::_onTaskCreated:$taskcreation');
      emit(
        state.copyWith(
          status: TaskStatus.success,
          task: taskcreation,
        ),
      );
    } catch (error) {
      logger.e("Error creating data: $error");

      emit(
        state.copyWith(
          status: TaskStatus.error,
          message: error.toString(),
        ),
      );
    }
  }
}
