import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../task/bloc/task_bloc.dart';
import '../../task/bloc/task_event.dart';
import '../../task/bloc/task_state.dart';

class TaskPage extends StatefulWidget {
 

  const TaskPage({Key? key,}) : super(key: key);

  @override
  State<TaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<TaskPage> {
  final Logger log = Logger();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(134, 4, 83, 147),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(135, 33, 149, 243),
        title: Text(
         'New Task',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state.status == TaskStatus.loading) {
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state.status == TaskStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                     
                       'Task Created Successfully')),
            );
            
          } else if (state.status == TaskStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task Creation Failed: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "What is to be done?",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'task',
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter Task here",
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Due Date",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderDateTimePicker(
                  name: 'date',
                  style: const TextStyle(color: Colors.white),
                  initialDate: DateTime.now(),
                  inputType: InputType.date,
                  format: DateFormat('dd-MM-yyyy'),
                  decoration: const InputDecoration(
                    hintText: "Date not set",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Time",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderDateTimePicker(
                  name: 'time',
                  style: const TextStyle(color: Colors.white),
                  inputType: InputType.time,
                  decoration: const InputDecoration(
                    hintText: "Time not set",
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: Icon(Icons.access_time, color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 24),
                Center(
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final formData = _formKey.currentState!.value;
                        context.read<TaskBloc>().add(TaskCreated(
                              task: formData['task'],
                              date: formData['date'].toString(),
                              time: formData['time'].toString(),
                            ));
                      } else {
                        log.w("Validation failed");
                      }
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.check),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
