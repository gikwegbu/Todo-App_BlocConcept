import 'package:bloc_pattern/blocs/todos/todos_bloc.dart';
import 'package:bloc_pattern/blocs/todos_filter/todos_filter_bloc.dart';
import 'package:bloc_pattern/models/todos_models.dart';
import 'package:flutter/material.dart';

import 'package:bloc_pattern/screens/home_screen.dart';
import 'package:bloc_pattern/blocs/blocs.dart';
import 'package:bloc_pattern/models/models.dart';
import 'package:bloc_pattern/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Creating an instance of the TodosBloc
        BlocProvider(
          create: (context) => TodosBloc()
            ..add(
              // We will be adding the LoadTodos with empty list of todos once this file is created...
              LoadTodos(
                todos: [
                  Todo(
                    id: '1',
                    task: 'Work Out',
                    description: "Wake up on time tomorrow George",
                  ),
                  Todo(
                    id: '2',
                    task: 'Learning',
                    description: "Finish Swift Courses",
                  ),
                ],
              ),
            ),
        ),
        // Creating an instance of the TodosFilterBloc, then passing the TodosBloc into is as a child, so the streamBuilder will then listen to it...
        // Recall we are expecting the 'todosBloc' as a data in the TodosFilterBloc file ::: "TodosFilterBloc({required TodosBloc todosBloc})"
        // After this, we'll extract the BlocBuilder from the Home_screen.dart file as a method _todos(), then wrap the scaffold with a default tabBar contoller...
        // These will be used to show todos that are pending and completed...
        BlocProvider(
          create: (context) => TodosFilterBloc(
            todosBloc: BlocProvider.of<TodosBloc>(context),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BloC Pattern - Todos',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: const Color(0xFF000A1F),
            appBarTheme: const AppBarTheme(
              color: Color(0xFF000A1F),
            )),
        home: const MyHomePage(),
      ),
    );
  }
}
