import 'package:flutter/material.dart';
import 'widgets/gradient_background.dart';
import 'widgets/todo_list_item.dart';
import 'widgets/add_todo_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF4CAF50), // Primary green
        hintColor: const Color(0xFFFF5722),  // Accent orange
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: TodoListApp(),
    );
  }
}

class TodoListApp extends StatefulWidget {
  const TodoListApp({super.key});

  @override
  _TodoListAppState createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  final List<Map<String, dynamic>> _todos = [];
  final _listKey = GlobalKey<AnimatedListState>();

  void _addTodo(String task) {
    final newTodo = {'task': task, 'isDone': false};
    _todos.insert(0, newTodo);
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 300));
    setState(() {});
  }

  void _editTodo(int index, String updatedTask) {
    setState(() {
      _todos[index]['task'] = updatedTask;
    });
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index]['isDone'] = !_todos[index]['isDone'];
    });
  }

  void _removeTodo(int index) {
    final removedItem = _todos[index];
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildTodoItem(removedItem, index, animation),
      duration: const Duration(milliseconds: 300),
    );
    _todos.removeAt(index);
  }

  Widget _buildTodoItem(Map<String, dynamic> todo, int index, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: TodoListItem(
        todo: todo,
        onEdit: (updatedTask) => _editTodo(index, updatedTask),
        onToggle: () => _toggleTodoStatus(index),
        onRemove: () => _removeTodo(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              'Todo List',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _todos.length,
                itemBuilder: (context, index, animation) {
                  return _buildTodoItem(_todos[index], index, animation);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AddTodoButton(onAdd: _addTodo),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
