import 'package:flutter/material.dart';
import '../../data/chrushData.dart';

class ShowCrushListDialog extends StatelessWidget {
  final Set<Student> crushList;
  final Future<void> Function(Student) removeCrush;

  const ShowCrushListDialog({
    Key? key,
    required this.crushList,
    required this.removeCrush,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your Crushes'),
      content: SizedBox(
        width: double.maxFinite,
        child: crushList.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          itemCount: crushList.length,
          itemBuilder: (context, index) {
            final student = crushList.elementAt(index);
            return ListTile(
              title: Text(student.name),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () async {
                  await removeCrush(student);
                  Navigator.of(context).pop(); // Close dialog
                  // Show the updated dialog with the latest crushList
                  showDialog(
                    context: context,
                    builder: (context) => ShowCrushListDialog(
                      crushList: crushList,
                      removeCrush: removeCrush,
                    ),
                  );
                },
              ),
            );
          },
        )
            : const Text("No crushes added yet."),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
