import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todo_task/todo_model.dart';

class ToDoHome extends StatefulWidget {
  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

const Color tbBackgrnd = Color(0xffC39BD3);

class _ToDoHomeState extends State<ToDoHome> {
  final title_controller = TextEditingController();
  final descrip_controller = TextEditingController();
  final _todoBox = Hive.box<TodoModel>('todos');

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: tbBackgrnd,
        title: const Text("ToDo"),
      ),
      body: ValueListenableBuilder(
          valueListenable: _todoBox.listenable(),
          builder: (context, Box<TodoModel> box, _) {
            if (box.length != 0) {
              return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final todo = box.getAt(index)!;
                    return ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        todo.description,
                        
                      ),
                      leading: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: todo.isDone ? tbBackgrnd: Colors.grey,
                              width: 3,
                            )),
                        child: Center(
                            child: todo.isDone
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.black)
                                : null),
                      ),
                      onTap: () {
          final newTodo = TodoModel(
            title: todo.title,
            description: todo.description,
            isDone: !todo.isDone,
          );
          Hive.box<TodoModel>('todos').putAt(index, newTodo);
        },
        onLongPress: (){
          _deleteTodo(index);
        },

                      trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: tbBackgrnd,
                          ),
                          onPressed: () {
                            _deleteTodo(index);
                            // Navigator.of(context).pop();
                          }),
                    );
                  });
            } else {
              return const Center(
                child: Text(
                  "No ToDos",
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: tbBackgrnd,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Create", style: TextStyle(color: Colors.white)),
          onPressed: () => showBottom(context, null)),
    ));
  }







  void _deleteTodo(int index) {
    _todoBox.deleteAt(index);
  }







  void showBottom(BuildContext context, param1) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            color: tbBackgrnd,
            height: 100,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      createTask(context);
                      // Navigator.pop(context);
                    },
                    child: const Text(
                      'Add ToDo',
                      style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }







  void createTask(BuildContext context) async {
    final newTodo = await showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String description = '';
        return AlertDialog(
          backgroundColor: tbBackgrnd,
          title: const Text(
            'Add Todo',
          ),
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.black,width: 5)
                    ),
                    hintText: "title"
                  ),
                  onChanged: (value) {
                    description = value;
                    title = value;
                  },
                ),
                const SizedBox(height: 20,),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black,width: 5)
                    ),
                    hintText: "description"
                  ),
                  onChanged: (value) {
                    title = value;
                    title = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                addTodo(description, title);
                 Navigator.pop(context, null);
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }




  void addTodo(String description, String title) {
    final todo = TodoModel(description: description, title: title);
    _todoBox.add(todo);
  }
}
