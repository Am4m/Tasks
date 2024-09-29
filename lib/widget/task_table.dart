import 'package:flutter/material.dart';
import 'package:task_manager/task/task.dart';
import 'package:task_manager/task/task_vault.dart';
import 'package:task_manager/widget/task_table_form.dart';

class TaskTable extends StatefulWidget {
  final TaskVault vault;

  const TaskTable({super.key, required this.vault});

  @override
  State<TaskTable> createState() => _TaskTableState();
}

class _TaskTableState extends State<TaskTable> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  List<Task> _sortTasks(List<Task> tasks) {
    return List.from(tasks)
      ..sort((a, b) {
        switch (_sortColumnIndex) {
          case 0:
            return _sortAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id);
          case 1:
            return _sortAscending
                ? a.title.compareTo(b.title)
                : b.title.compareTo(a.title);
          case 2:
            return _sortAscending
                ? a.status.index.compareTo(b.status.index)
                : b.status.index.compareTo(a.status.index);
          case 3:
            return _sortAscending
                ? a.priority.index.compareTo(b.priority.index)
                : b.priority.index.compareTo(a.priority.index);
          default:
            return 0;
        }
      });
  }

  void _deleteTask(Task task) {
    setState(() {
      widget.vault.removeTask(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Task> sortedTasks = _sortTasks(widget.vault.tasks.toList());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        tooltip: "Add new Task",
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(widget.vault.name),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(16.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: DataTable(
                  columnSpacing: 5,
                  sortAscending: _sortAscending,
                  sortColumnIndex: _sortColumnIndex,
                  columns: [
                    _buildDataColumn("ID"),
                    _buildDataColumn("Task"),
                    _buildDataColumn("Status"),
                    _buildDataColumn("Priority"),
                    const DataColumn(
                      label: Text(
                        "",
                      ),
                    ),
                  ],
                  rows: _buildDataRows(sortedTasks),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onSort: (columnIndex, _) {
        setState(() {
          _sortColumnIndex = columnIndex;
          _sortAscending = !_sortAscending;
        });
      },
    );
  }

  List<DataRow> _buildDataRows(List<Task> sortedTasks) {
    return List<DataRow>.generate(sortedTasks.length, (index) {
      final task = sortedTasks[index];

      return DataRow(
        cells: [
          DataCell(Text("${task.id}")),
          DataCell(Text(task.title)),
          DataCell(
            DropdownButton<Status>(
              value: task.status,
              items: Status.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Icon(
                        IconData(status.codePoint, fontFamily: 'MaterialIcons'),
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(status.text),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newStatus) {
                if (newStatus != null) {
                  setState(() {
                    task.status = newStatus;
                  });
                }
              },
            ),
          ),
          DataCell(
            DropdownButton<Priority>(
              value: task.priority,
              items: Priority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Row(
                    children: [
                      Icon(
                        IconData(priority.codePoint,
                            fontFamily: 'MaterialIcons'),
                        size: 18,
                        color: Color(priority.colorValue),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        priority.text,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newPriority) {
                if (newPriority != null) {
                  setState(() {
                    task.priority = newPriority;
                  });
                }
              },
            ),
          ),
          DataCell(
            IconButton(
              // Delete button cell
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                _deleteTask(task);
              },
            ),
          ),
        ],
      );
    });
  }

  void _addTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskTableForm(
          onSave: (newTask) {
            setState(() {
              widget.vault.addTask(newTask);
            });
          },
        );
      },
    );
  }
}
