import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/user_details.dart';
import '../data/chrushData.dart';
import '../widgets/addORremove/crush_service.dart';
import '../widgets/profile/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final StudentDataService _dataService = StudentDataService();
  final StudentDataService _dataFromSheet = StudentDataService();

  final CrushService _crushService = CrushService();
  // final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String _userEmail = "Loading...";
  String _userName = "Loading...";
  List<Student> students = [];
  Set<Student> crushList = {};
  int crushCount = 0;
  int crushOf = 0;
  int matched = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Load user details
    _userEmail = getCurrentUserEmail() ?? "Loading...";
    String? nickname = await fetchNickNameForCurrentUser(_userEmail);
    _userName = nickname ?? _userEmail;

    // Load student data
    final loadedStudents = await _dataService.loadStudents();

    // Fetch crush list from database and set the initial count
    final loadedCrushList = await _crushService.fetchCrushList(_userName);
    crushList = Set.from(loadedCrushList);
    crushCount = crushList.length;

    setState(() {
      students = loadedStudents;
    });
  }

  Future<void> _addCrush(Student student) async {
    await _crushService.addCrush(_userName, student);
    setState(() {
      crushList.add(student);
    });
  }

  Future<void> _removeCrush(Student student) async {
    await _crushService.removeCrush(_userName, student);
    setState(() {
      crushList.remove(student);
    });
  }

  void _showAddCrushDialog() async {
    final updatedCrushList = await showDialog<Set<Student>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Crush',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SearchAnchor(
                      builder:
                          (BuildContext context, SearchController controller) {
                        return SearchBar(
                          controller: controller,
                          padding: const WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          onTap: () {
                            controller.openView();
                          },
                          leading: const Icon(Icons.search),
                          hintText: 'Search student...',
                        );
                      },
                      suggestionsBuilder:
                          (BuildContext context, SearchController controller) {
                        final keyword = controller.text.toLowerCase();

                        return students
                            .where((student) =>
                                student.name.toLowerCase().contains(keyword) &&
                                !crushList.contains(student))
                            .map((student) => ListTile(
                                  title: Text(student.name),
                                  onTap: () async {
                                    setState(() {
                                      crushList.add(student);
                                    });
                                    await _addCrush(student);
                                    controller.clear();
                                    Navigator.pop(context);
                                  },
                                ))
                            .toList();
                      },
                    ),
                    const SizedBox(height: 16),
                    if (crushList.isNotEmpty) ...[
                      const Text(
                        'Selected Crushes:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: crushList.length,
                          itemBuilder: (context, index) {
                            final student = crushList.elementAt(index);
                            return ListTile(
                              title: Text(student.name),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle),
                                color: Colors.red,
                                onPressed: () async {
                                  await _removeCrush(student);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (updatedCrushList != null) {
      setState(() {
        crushList = updatedCrushList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: RefreshIndicator(
            onRefresh: _initializeData,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/home_bg_img.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const Expanded(flex: 1, child: TopPortion()),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            _userName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton.extended(
                                onPressed: _showAddCrushDialog,
                                heroTag: 'Crush-List',
                                elevation: 0,
                                label: const Text("Crush List"),
                                icon: const Icon(Icons.add),
                              ),
                              const SizedBox(width: 16.0),
                              FloatingActionButton.extended(
                                onPressed: () {},
                                heroTag: 'message',
                                elevation: 0,
                                backgroundColor: Colors.red,
                                label: const Text("Message"),
                                icon: const Icon(Icons.message_rounded),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn('Crush Of', crushOf.toString(), 1),
                              _buildStatColumn('Your Crush', crushList.length.toString(), 2),
                              _buildStatColumn('Matched', matched.toString(), 3),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
    );
  }

  Widget _buildStatColumn(String label, String value, int pos) {
    return OutlinedButton(
      onPressed: () {
        if (pos == 1) {
          // Do something specific for position 1
        } else if (pos == 2) {
          // Open the crush list dialog for position 2
          _showCrushListDialog();
        } else if (pos == 3) {
          // Do something specific for position 3
        }
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showCrushListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () async {
                            await _removeCrush(student);
                            setState(() {
                              crushList.remove(student);
                            });
                            Navigator.of(context).pop(); // Close the dialog
                            _showCrushListDialog(); // Reopen it with updated list
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
      },
    );
  }
}
