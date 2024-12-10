import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:newtodo/menu/bloc/menu_bloc.dart';
import 'package:newtodo/menu/bloc/menu_event.dart';
import 'package:newtodo/menu/bloc/menu_state.dart';
import 'package:newtodo/task/bloc/task_bloc.dart';
import 'package:newtodo/task/bloc/task_state.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum Menu {
  TaskLists,
  AddInBatchMode,
  RemoveAds,
  MoreApps,
  SendFeedback,
  FollowUs,
  Invite,
  Settings,
  MenuPage,
  Logout
}

class _HomepageState extends State<Homepage> {
  String? dropdownValue;
  Logger logger = Logger();
  List<String> dropdownItems = ['New List', 'Finished '];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(134, 4, 83, 147),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(135, 33, 149, 243),
        title: Row(
          children: [
            const Icon(
              Icons.check_circle,
              size: 30,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            BlocBuilder<MenuBloc, MenuState>(
              builder: (context, state) {
                if (state.status == MenuStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (state.status == MenuStatus.error) {
                  return const Center(
                    child: Text(
                      'Error loading menus',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final menuItems = [
                  'New List',
                  ...state.menuList.map((menu) => menu.menuname).toList(),
                  'Finished',
                ];

                dropdownValue ??= menuItems.first;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SizedBox(
                        width: 160.0,
                        height: 60.0,
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          hint: const Text('Select'),
                          items: menuItems.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            
                            if (value == 'New List') {
                              _showNewMenuDialog(context);
                            }
                          },
                          dropdownColor:
                              const Color.fromARGB(135, 33, 149, 243),
                          iconEnabledColor: Colors.white,
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            BlocListener<MenuBloc, MenuState>(
              listener: (context, state) {
                if (state.status == MenuStatus.loaded) {
                  Fluttertoast.showToast(
                    msg: 'Menu created successfully',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                } else if (state.status == MenuStatus.error) {
                  Fluttertoast.showToast(
                    msg: 'Error creating menu',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          _buildPopupMenu(context),
        ],
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state.status == TaskStatus.success) {
            Fluttertoast.showToast(
              msg: 'Task created successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          } else if (state.status == TaskStatus.error) {
            Fluttertoast.showToast(
              msg: 'Error in created  successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          }
        },
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state.status == TaskStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == TaskStatus.success) {
              final tasks = state.taskList;
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: Container(
                        height: 70,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color.fromARGB(135, 33, 149, 243),
                        ),
                        child: Row(
                          children: [
                            Column(children: []),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 100),
                                  child: Text(
                                    task.task,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: Text(
                                    '${task.date}',
                                    style: const TextStyle(
                                      color: Color.fromARGB(135, 33, 149, 243),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 85),
                                  child: Text(
                                    "${task.time}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == TaskStatus.error) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No tasks available'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/taskpage');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget _buildPopupMenu(BuildContext context) {
  return PopupMenuButton<Menu>(
    elevation: 0,
    color: const Color.fromARGB(135, 33, 149, 243),
    constraints: const BoxConstraints.tightFor(height: 340, width: 200),
    icon: const Icon(
      Icons.more_vert,
      color: Colors.white,
    ),
    onSelected: (Menu item) {
      switch (item) {
        case Menu.TaskLists:
          break;
        case Menu.AddInBatchMode:
          break;
        case Menu.RemoveAds:
          break;
        case Menu.MoreApps:
          break;
        case Menu.SendFeedback:
          break;
        case Menu.FollowUs:
          break;
        case Menu.Invite:
          break;
        case Menu.Settings:
          GoRouter.of(context).go('/setting');
          break;
        case Menu.MenuPage:
          break;
        case Menu.Logout:
          GoRouter.of(context).go('/logout');
          break;
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
      const PopupMenuItem<Menu>(
        value: Menu.TaskLists,
        child: Text('Task Lists'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.AddInBatchMode,
        child: Text('Add in Batch Mode'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.RemoveAds,
        child: Text('Remove Ads'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.MoreApps,
        child: Text('More Apps'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.SendFeedback,
        child: Text('Send Feedback'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.FollowUs,
        child: Text('Follow Us'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.Invite,
        child: Text('Invite'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.Settings,
        child: Text('Settings'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.MenuPage,
        child: Text('Menu Page'),
      ),
      const PopupMenuItem<Menu>(
        value: Menu.Logout,
        child: Text('Logout'),
      ),
    ],
  );
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
