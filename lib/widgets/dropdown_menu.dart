import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:newtodo/menu/bloc/menu_bloc.dart';
import 'package:newtodo/menu/bloc/menu_event.dart';
import 'package:newtodo/menu/bloc/menu_state.dart';

import 'package:flutter/material.dart';

import '../menu/repo/repositiry.dart';

class DropdownMenuWidget extends StatefulWidget {
  @override
  _DropdownMenuWidgetState createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
 

  @override
  Widget build(BuildContext context) {
  
    return BlocProvider(
      create: (_) {
        return MenuBloc(menuRepository: MenuRepository());
         
      },
      child: DropDownWidget()
    );
  }

 

}
class DropDownWidget extends StatelessWidget {
  const DropDownWidget({super.key});

  @override
  Widget build(BuildContext context) {
  String? dropdownValue;
  final box = GetStorage();
    return  BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state.status == MenuStatus.loading) {
            return const CircularProgressIndicator(color: Colors.white);
          }

          if (state.status == MenuStatus.error) {
            return const Text('Error loading menus',
                style: TextStyle(color: Colors.red));
          }

          final menuItems = [
            'New List',
            ...state.menuList.map((menu) => menu.menuname).toList(),
            'Finished',
          ];
          return Container(
            width: 150,
            child: DropdownButton<String>(
              value: dropdownValue ?? menuItems.first,
              hint: const Text('Select'),
              items: menuItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child:
                      Text(item, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                 
                  if (value == 'New List') {
                    _showNewMenuDialog(context);
                  }
                }
              },
              dropdownColor: const Color.fromARGB(135, 33, 149, 243),
              iconEnabledColor: Colors.white,
              isExpanded: true,
              underline: const SizedBox(),
            ),
          );
        },
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
                  final String? menuName =
                      formData?['menuName']; // Check if this is null
                  final String? date =
                      formData?['date']; // Check if this is null

                  // Debugging - Check the values
                  print("Form Data: $formData");
                  print("Menu Name: $menuName, Date: $date");

                  // If either value is null, show an error
                  if (menuName == null || date == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menu name and date are required!'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    context
                        .read<MenuBloc>()
                        .add(CreateMenu(menuname: menuName, date: date));
                    Navigator.of(context).pop();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      duration: Duration(seconds: 3),
                    ),
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
}
