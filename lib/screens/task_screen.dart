import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_provider/constants/constants.dart';
import 'package:todo_app_provider/model/task_model.dart';
import 'package:todo_app_provider/viewmodel/task_view_model.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: primary,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(
                Icons.check,
                size: 25,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'TODO LIST',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Consumer<TaskViewModel>(builder: (context, taskProvider, _) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final task = taskProvider.tasks[index];
            return TaskWidget(
              task: task,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: primary,
              height: 1,
              thickness: 1,
            );
          },
          itemCount: taskProvider.tasks.length,
        );
      }),
      floatingActionButton: const CustomFloatingActionsButton(),
    );
  }
}

class TaskWidget extends StatelessWidget {
  final Task task;
  const TaskWidget({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      title: Text(
        task.taskName,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        '${task.date},${task.time}',
        style: const TextStyle(color: textBlue),
      ),
    );
  }
}

class CustomFloatingActionsButton extends StatelessWidget {
  const CustomFloatingActionsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primary,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const CustomDialog();
          },
        );
      },
      child: const Icon(
        Icons.add,
        size: 27,
        color: Colors.white,
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final taskProvider = Provider.of<TaskViewModel>(context, listen: false);
    return Dialog(
      backgroundColor: secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        height: screenHeight * 0.6,
        width: screenWidth * 0.8,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Create a new task",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "What has to be done",
                style: TextStyle(
                    
                    color: textBlue),
              ),
              CustomTextField(
                hint: "Enter a task",
                onChanged: (value) {
                  taskProvider.setTaskName(value);
                },
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "DueDate",
                style: TextStyle(
                   
                    color: textBlue),
              ),
              CustomTextField(
                controller: taskProvider.dateController,
                hint: "Enter date",
                icon: Icons.calendar_month,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2016),
                      lastDate: DateTime(2040));
                  taskProvider.setDate(date);
                },
                readOnly: true,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                hint: "Enter time",
                icon: Icons.timer,
                controller: taskProvider.timeController,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  taskProvider.setTime(time);
                },
                readOnly: true,
                onChanged: (value) {
                  taskProvider.setTaskName(
                      value); 
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () async {
                    await taskProvider.addTask();
                    if (context.mounted) {
                      

                      Navigator.pop(
                          context); 
                    }
                  },
                  child: const Text(
                    'Create',
                    style:
                        TextStyle(color: primary, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final void Function()? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  const CustomTextField({
    super.key,
    required this.hint,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: onTap,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
