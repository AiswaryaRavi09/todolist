import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/HomeScreenController.dart';
import '../Utils/Colors.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final ToDoController controller = Get.put(ToDoController());
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    controller.fetchToDoList();
  }

  void startSearch(String query) {
    setState(() {
      isSearching = true;
      controller.searchTask(query); // Filter the list based on the input query
    });
  }
  void stopSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
      controller.searchTask('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color1,
      body: Padding(
        padding: const EdgeInsets.only(left: 20,top: 60),
        child: SingleChildScrollView( // Wrap the body with SingleChildScrollView
          child: Column(
            children: [
              Container(
                height: 60,
                width: 300,
                decoration: BoxDecoration(
                  color: color1,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black12, width: 2), // Border color and width
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                        onChanged: startSearch, // Call startSearch method when text changes
                      ),
                    ),
                  ],
                ),
              ),

              Obx(() {return controller.filteredToDoList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                child: ListView.builder(
                  shrinkWrap: true, // Set shrinkWrap to true
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                  itemCount: controller.filteredToDoList.length,
                  itemBuilder: (context, index) {
                    final task = controller.filteredToDoList[index];
                    return Card(
                      // color:color2,
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          task.title ?? '',
                          style: TextStyle(
                            decoration: task.completed ?? false
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: task.completed ?? false,
                              onChanged: (value) {
                                controller.markAsCompleted(index, value ?? false);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                              color: Colors.black45,),
                              onPressed: () {
                                // Show delete confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: const Text(
                                        'Are you sure you want to delete this task?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Perform deletion
                                          controller.deleteTask(index);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller.taskController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a new task',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.addTask(controller.taskController.text);
                        controller.taskController.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          height: 50.0,
        ),
      ),
    );
  }
}
