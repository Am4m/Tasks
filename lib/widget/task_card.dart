import 'package:flutter/material.dart';
import 'package:task_manager/task/task_vault.dart';
import 'package:task_manager/widget/task_form.dart';
import 'package:task_manager/widget/task_table.dart';

class TaskCard extends StatelessWidget {
  final TaskVault vault;

  const TaskCard({super.key, required this.vault});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TaskTable(vault: vault);
        }));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vault.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      vault.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Created: ${vault.dateCreated.day}/${vault.dateCreated.month}/${vault.dateCreated.year}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Opacity(
                            opacity: vault.isPinned ? 1 : 0,
                            child: const Icon(
                              Icons.push_pin,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Tasks: ${vault.tasks.length}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  _moreMenu(this, context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreMenuItem {
  final String name;
  final Icon icon;
  final Function(TaskCard card, BuildContext context)? action;

  const _MoreMenuItem(this.name, this.icon, this.action);

  static final _MoreMenuItem pin = _MoreMenuItem(
    "Pin",
    const Icon(Icons.push_pin_outlined),
    (card, _) => card.vault.togglePinned(),
  );

  static final _MoreMenuItem edit = _MoreMenuItem(
    "Edit",
    const Icon(Icons.edit_outlined),
    (card, context) => _edit(card, context),
  );

  static final _MoreMenuItem delete = _MoreMenuItem(
    "Delete",
    const Icon(Icons.delete_outlined),
    (card, context) => _delete(card, context),
  );

  static List<_MoreMenuItem> values = [pin, edit, delete];
}

Widget _moreMenu(TaskCard card, BuildContext context) {
  return PopupMenuButton<_MoreMenuItem>(
    popUpAnimationStyle: AnimationStyle.noAnimation,
    icon: const Icon(Icons.more_vert),
    onSelected: (value) {
      value.action!(card, context);
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<_MoreMenuItem>>[
      for (var item in _MoreMenuItem.values)
        PopupMenuItem<_MoreMenuItem>(
          value: item,
          child: _listTile(
            item.icon,
            card.vault.isPinned && item == _MoreMenuItem.pin
                ? "Unpin"
                : item.name,
          ),
        ),
    ],
  );
}

Widget _listTile(Icon icon, String title) {
  return ListTile(
    leading: icon,
    title: Text(title),
  );
}

void _delete(TaskCard card, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete task vault ?"),
        content: Text('This will delete ${card.vault.name} '),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              TaskVault.list.removeVault(card.vault);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${card.vault.name} deleted !"),
              ));
            },
          ),
        ],
      );
    },
  );
}

void _edit(TaskCard card, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return TaskForm(
          title: "Edit task",
          onSubmit: (name, desc) {
            card.vault.name = name;
            card.vault.description = desc;
          },
        );
      },
    ),
  );
}
