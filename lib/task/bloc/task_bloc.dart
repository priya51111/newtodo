

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import 'package:newtodo/task/bloc/task_event.dart';
import 'package:newtodo/task/bloc/task_state.dart';
import 'package:newtodo/task/models.dart';
import 'package:newtodo/task/repo/repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(TaskState.initial) {
    on<TaskCreated>(_onCreateTask);
    on<FetchTask>(_onFetchTask);
    on<UpdateTask>(_onUpdateTask);
    on<deleteTask>(_deleteTask); 
     on<TaskLongPressEvent>(_onTaskLongPress);
  }

  final TaskRepository _taskRepository;
  final Logger logger = Logger();
     final box = GetStorage();
  Future<void> _onCreateTask(
    TaskCreated event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TaskStatus.loading));
      final taskCreate = await _taskRepository.createTask(
        event.task,
        event.date,
        event.time,
      );
      logger.d("TaskBloc ::: _onCreateTask:: $taskCreate");
      emit(state.copyWith(
        status: TaskStatus.success,
        task: taskCreate,
      ));
        final userId = box.read('userId');
      final date = box.read('taskDate');
      if (userId == null || date == null) {
        emit(state.copyWith(
          status: TaskStatus.error,
          message: "date or userId is missied"
        ));
        
      }
 
      add(FetchTask   (userId: userId, date: date));
    } catch (error) {
      logger.e("Error creating task: $error");
      emit(
        state.copyWith(
          status: TaskStatus.error,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onFetchTask(
    FetchTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TaskStatus.loading));
      final List<Task> tasks = await _taskRepository.fetchTasks(
          userId: event.userId, date: event.date);
      emit(state.copyWith(status: TaskStatus.success, taskList: tasks));
    } catch (error) {
      logger.e("Error creating task: $error");
      emit(
        state.copyWith(
          status: TaskStatus.error,
          message: error.toString(),
        ),
      );
       add(FetchTask(userId: event.userId, date: event.date));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      emit(state.copyWith(status: TaskStatus.loading));
      final updatedTask = await _taskRepository.updateTask(
          taskId: event.taskId,
          task: event.task,
          date: event.date,
          time: event.time,
          menuId: event.menuId,
          isFinished: event.isfinished);
      emit(state.copyWith(updatetask: updatedTask));
    } catch (error) {
      logger.e("Error creating task: $error");
      emit(
        state.copyWith(
          status: TaskStatus.error,
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _deleteTask(
    deleteTask event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TaskStatus.loading));
      final deleteTask = await _taskRepository.deleteTask(event.taskId);
      emit(state.copyWith(deleteTask: deleteTask));
    } catch (error) {
      logger.e("Error creating task: $error");
      emit(
        state.copyWith(
          status: TaskStatus.error,
          message: error.toString(),
        ),
      );
    }
  }
   void _onTaskLongPress(TaskLongPressEvent event, Emitter<TaskState> emit) {
    emit(state.copyWith(isTaskSelected: event.isSelected));
  }
}

