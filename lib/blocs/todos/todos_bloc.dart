import 'package:bloc/bloc.dart';
import 'package:bloc_pattern/models/todos_models.dart';
import 'package:equatable/equatable.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(TodosLoading()) {
    // on<TodosEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodos event, Emitter emit) {
    emit(
      TodosLoaded(todos: event.todos),
    );
  }

  void _onAddTodo(AddTodo event, Emitter emit) {
    final state = this.state; // making a copy of the bloc's state
    if (state is TodosLoaded) {
      emit(
        TodosLoaded(
          // Here, i'm grabbing the todos from the state, then adding the new todo from the event, technically from the UI.
          todos: List.from(state.todos)..add(event.todo),
        ),
      );
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter emit) {
    final state = this.state;

    if (state is TodosLoaded) {
      // Here, we'll use map, to loop through our todos, any todo that matches our current todo in the event, will get updated
      // With the data from the event, else the previous todo is retained...

      // List<Todo> todos = (state.todos.map((e) => null)).cast<Todo>().toList();
      List<Todo> todos = (state.todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      })).toList();
      // print(
      //     "This is the remaining data from the state in todos_block.dart::: $state");
      emit(
        TodosLoaded(todos: todos),
      );
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter emit) {
    final state = this.state;
    if (state is TodosLoaded) {
      List<Todo> todos = state.todos.where((todo) {
        return todo.id != event.todo.id;
      }).toList();

      emit(
        TodosLoaded(todos: todos),
      );
    }
  }
}
