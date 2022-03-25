import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/pages/notification_screen.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';
import 'package:todo/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 6,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchMode();
        },
        icon: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            notifyHelper.cancelAllNotification();
            _taskController.deleteAllTask();
          },
          icon: Icon(
            Icons.cleaning_services_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
        ),
        SizedBox(
          width: 20,
        ),
      ],
      elevation: 0,
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              label: '+ Add Task',
              onTap: () async {
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: _selectedDate,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        monthTextStyle: bodyStyle,
        dateTextStyle: bodyStyle,
        dayTextStyle: bodyStyle,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  showBottmSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        notifyHelper.cancelNotification(task);
                        _taskController.markUsCompleted(task.id!);
                        Get.back();
                      },
                      clr: primaryClr),
              _buildBottomSheet(
                  label: 'delete Task',
                  onTap: () {
                    _taskController.deleteTask(task);
                    notifyHelper.cancelNotification(task);
                    Get.back();
                  },
                  clr: Colors.red[300]!),
              Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
              ),
              _buildBottomSheet(
                  label: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                  clr: primaryClr),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
          border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              var task = _taskController.taskList[index];
              if (task.repeat == 'Daily' ||
                  task.date == DateFormat.yMd().format(_selectedDate) ||
                  (task.repeat == 'Weekly' &&
                      _selectedDate
                                  .difference(
                                      DateFormat.yMd().parse(task.date!))
                                  .inDays %
                              7 ==
                          0) ||
                  (task.repeat == 'Monthly' &&
                      DateFormat.yMd().parse(task.date!).day ==
                          _selectedDate.day)) {
                var hour = task.startTime.toString().split(':')[0];
                var minutes = task.startTime.toString().split(':')[1];
                int a = 0;
                if (minutes.isCaseInsensitiveContains('PM')) {
                  a = int.parse(hour) + 12;
                } else {
                  a = int.parse(hour);
                }
                minutes = minutes.toString().split(' ')[0];
                notifyHelper.scheduledNotification(a, int.parse(minutes), task);
                return GestureDetector(
                  onTap: () {
                    showBottmSheet(context, task);
                  },
                  child: TaskTile(
                    task,
                  ),
                );
              } else {
                return Container();
              }
            },
            itemCount: _taskController.taskList.length,
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: SizeConfig.orientation == Orientation.landscape
            ? Axis.horizontal
            : Axis.vertical,
        children: [
          SizeConfig.orientation == Orientation.landscape
              ? const SizedBox(
                  height: 120,
                )
              : const SizedBox(
                  height: 350,
                ),
          SvgPicture.asset(
            'images/task.svg',
            height: 90,
            color: primaryClr.withOpacity(0.5),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              'You do not have any task yet!\nAdd new tasks to make your days productive',
              style: subTitleStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
