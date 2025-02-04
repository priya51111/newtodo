import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../task/bloc/task_bloc.dart';
import '../../task/bloc/task_event.dart';
import '../../task/bloc/task_state.dart';
import '../menu/bloc/menu_bloc.dart';
import '../menu/bloc/menu_event.dart';
import '../widgets/dropdown_menu.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<TaskPage> {
  final Logger log = Logger();
  final _formKey = GlobalKey<FormBuilderState>();
  String? dropdownValue;
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
      body: BlocListener<TaskBloc, TaskState>(listener: (context, state) {
        if (state.status == TaskStatus.loading) {
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (state.status == TaskStatus.success) {
          Fluttertoast.showToast(
            msg: state.isEditMode
                ? "Task Updated Successfully!"
                : "Task Created Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          Future.delayed(const Duration(seconds: 1), () {
            context.go('/home');
          });
        } else if (state.status == TaskStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Task Creation Failed: ${state.message}')),
          );
        } 
      }, child: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
        return Padding(
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
                const SizedBox(
                  height: 9,
                ),
                const Text(
                  "Add to List",
                  style: TextStyle(
                    color: Color.fromARGB(135, 33, 149, 243),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownMenuWidget(),
                    ),
                    IconButton(
                      onPressed: () {
                        _showNewMenuDialog(context);
                      },
                      icon: const Icon(Icons.format_list_bulleted_add,
                          color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                FloatingActionButton(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  onPressed: () {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final DateTime parsedDate = formData['date'];
      final DateTime parsedTime = formData['time'];
      final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      final formattedTime = DateFormat('HH:mm:ss').format(parsedTime);

      final box = GetStorage();
      final taskId = box.read('taskId');  // Ensure taskId is retrieved correctly
      final menuId = box.read('menuId');

      if (state.isEditMode) {
        context.read<TaskBloc>().add(
          UpdateTask(
            taskId: taskId,
            task: formData['task'],
            date: formattedDate,
            time: formattedTime,
            menuId: menuId,
            isfinished: formData['finished'] ?? false,
            isEditMode: true,
          ),
        );
      } else {
        context.read<TaskBloc>().add(
          TaskCreated(
            task: formData['task'],
            date: formattedDate,
            time: formattedTime,
          ),
        );
      }
    } else {
      log.w("Validation failed");
    }
  },
  backgroundColor: Colors.white,
  child: const Icon(Icons.check),
),

              ],
            ),
          ),
        );
      })),
    );
  }
}

void _showNewMenuDialog(BuildContext context) {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DateTime? selectedDate;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        title: const Text(
          'Create New Menu',
          style: TextStyle(
            color: Color.fromARGB(201, 4, 83, 147),
          ),
        ),
        content: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FormBuilderTextField(
                name: 'menuName',
                decoration: const InputDecoration(hintText: 'Menu Name'),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(50),
                ]),
              ),
              FormBuilderTextField(
                name: 'date',
                readOnly: true,
                decoration: const InputDecoration(hintText: 'Select Date'),
                onTap: () async {
                  selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    _formKey.currentState?.fields['date']?.didChange(
                      DateFormat('yyyy-MM-dd').format(selectedDate!),
                    );
                  }
                },
                validator: FormBuilderValidators.required(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final formData = _formKey.currentState?.value;
                final String menuName = formData?['menuName'];
                final String date = formData?['date'];

                context
                    .read<MenuBloc>()
                    .add(CreateMenu(menuname: menuName, date: date));
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please fill in all fields'),
                      duration: Duration(seconds: 3)),
                );
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Color.fromARGB(201, 4, 83, 147),
              ),
            ),
          ),
        ],
      );
    },
  );
}
