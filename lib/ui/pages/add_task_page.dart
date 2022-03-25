import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';

import '../theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(Duration(minutes: 15)))
      .toString();

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: Container(
        //padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter title here.',
                controller: _titleController,
              ),
              const SizedBox(
                height: 5,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here.',
                controller: _noteController,
              ),
              const SizedBox(
                height: 5,
              ),
              InputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    onPressed: () => _getDateFromUser(),
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  )),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: true),
                          icon: Icon(Icons.access_time_rounded,
                              color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                          icon: Icon(Icons.access_time_rounded,
                              color: Colors.grey)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              InputField(
                  title: 'Remind',
                  hint: '$_selectedRemind minutes early',
                  widget: DropdownButton(
                    dropdownColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    items: remindList
                        .map((e) => DropdownMenuItem(
                              child: Text('$e'),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedRemind = newValue!;
                      });
                    },
                  )),
              const SizedBox(
                height: 5,
              ),
              InputField(
                  title: 'Repeat',
                  hint: _selectedRepeat,
                  widget: DropdownButton(
                    dropdownColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    items: repeatList
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                  )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildColumn(),
                    MyButton(
                        label: 'Create Task',
                        onTap: () {
                          _validateDate();
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
        ),
        SizedBox(
          width: 20,
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 24,
          color: primaryClr,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('required', 'All fields are required!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      print('########### SOMETHING BAD HAPPENED ##########');
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    ));
    print(value);
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        SizedBox(
          height: 3,
        ),
        Row(
            children: List.generate(
                3,
                (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = index;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          child: _selectedColor == index
                              ? Icon(
                                  Icons.done,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                          backgroundColor: index == 0
                              ? primaryClr
                              : index == 1
                                  ? pinkClr
                                  : orangeClr,
                        ),
                      ),
                    )))
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 15))),
    );
    if (_pickedTime != null) {
      String _formattedTime = _pickedTime.format(context);
      if (isStartTime) {
        _startTime = _formattedTime;
      } else if (!isStartTime) {
        _endTime = _formattedTime;
      }
    }
  }
}
