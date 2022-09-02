import 'package:bloc_pattern/blocs/todos/todos_bloc.dart';
import 'package:bloc_pattern/blocs/todos_filter/todos_filter_bloc.dart';
import 'package:bloc_pattern/models/todos_filter_model.dart';
import 'package:bloc_pattern/models/todos_models.dart';
import 'package:bloc_pattern/screens/add_todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("BloC Pattern: To Dos"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTodoScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            )
          ],
          bottom: TabBar(
            onTap: (tabIndex) {
              // Using switch case to detect which todos type we wanna show the user...
              switch (tabIndex) {
                case 0:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodos(
                      todosFilter: TodosFilter.pending,
                    ),
                  );
                  break;
                case 1:
                  BlocProvider.of<TodosFilterBloc>(context).add(
                    const UpdateTodos(
                      todosFilter: TodosFilter.completed,
                    ),
                  );
                  break;
              }
            },
            tabs: const [
              Tab(icon: Icon(Icons.pending)),
              Tab(icon: Icon(Icons.add_task)),
            ],
          ),
        ),
        body: TabBarView(children: [
          _todos("Pending To Dos"),
          _todos("Completed To Dos"),
        ]),
      ),
    );
  }

  // BlocBuilder<TodosBloc, TodosState> _todos(String title) { // we won't be using the TodosBloc, but the TodosFilterBloc...Refactoring...
  BlocConsumer<TodosFilterBloc, TodosFilterState> _todos(String title) {
    return BlocConsumer<TodosFilterBloc, TodosFilterState>(
      listener: (context, state) {
        if (state is TodosFilterLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('You have ${state.filteredTodos.length} task.')));
        }
      },
      // The BlocBuilder allows use to build/render a widget based on the value of the Bloc's state
      builder: (context, state) {
        if (state is TodosFilterLoading) {
          return const CircularProgressIndicator();
        }
        if (state is TodosFilterLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    // 'Pending To Dos',
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  // We can access our todos from the state, like the ones loaded in the main.dart
                  // itemCount: Todo.todos.length,
                  itemCount: state.filteredTodos.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return _todoCard(Todo.todos[index]);
                    return _todoCard(context, state.filteredTodos[index]);
                  },
                )
              ],
            ),
          );
        } else {
          return const Text("Oops!!! Something went wrong...");
        }
      },
    );
  }

  Card _todoCard(BuildContext context, Todo todo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${todo.id}: ${todo.task}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<TodosBloc>().add(
                            UpdateTodo(
                              todo: todo.copyWith(
                                isCompleted: true,
                              ),
                            ),
                          );
                    },
                    icon: const Icon(
                      Icons.add_task,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<TodosBloc>().add(
                            DeleteTodo(todo: todo),
                          );
                    },
                    icon: const Icon(
                      Icons.cancel,
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
