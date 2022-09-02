import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_pattern/blocs/todos/todos_bloc.dart';
import 'package:bloc_pattern/models/todos_filter_model.dart';
import 'package:bloc_pattern/models/todos_models.dart';
import 'package:equatable/equatable.dart';

part 'todos_filter_event.dart';
part 'todos_filter_state.dart';

class TodosFilterBloc extends Bloc<TodosFilterEvent, TodosFilterState> {
  // This is where we get to link the other todos bloc to the filter todos bloc, and it'll be a required feature in this todos filter bloc
  final TodosBloc _todosBloc;
  late StreamSubscription _todosSubscription;
  // here i'm setting up a subscription between the todosFilter and the todosBloc, so that the second bloc (todosFilterBloc)
  // can listen to the state changes of the first bloc (todosBloc), so that we can use the data from the first bloc in the second bloc...

  TodosFilterBloc({required TodosBloc todosBloc})
      : _todosBloc = todosBloc,
        super(TodosFilterLoading()) {
    // on<TodosFilterEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
    on<UpdateFilter>(_onUpdateFilter);
    on<UpdateTodos>(_onUpdateTodos);
    // Adding the streamSubscription to the TodosFilterBloc constructor...So that we basically listen to each change coming from the first bloc (todosBloc)
    _todosSubscription = todosBloc.stream.listen((state) {
      // Whilst listening for any change from the todosBloc, i.e adding, removing or updating a new todo, i'll add the 'updateTodos' method below to run my code in the second bloc
      add(
        const UpdateFilter(), // This updates the data asap
      );
    });
  }

  void _onUpdateFilter(UpdateFilter event, Emitter<TodosFilterState> emit) {
    // This particular state is coming form the 'StateStreamable' we are listening to...
    if (state is TodosFilterLoading) {
      // Meaning, we listen for case where the TodosFilterLoading is active, then we call the
      // UpdateTodos and pass the TodosFilter.pending status to it...
      // Remember the defualt value passed to the UpdateTodos' constructor is TodosFilter.all from when it was declared...
      add(
        const UpdateTodos(
          todosFilter: TodosFilter.pending,
        ),
      );
      //I don't need to emit anything here, just updating the status of the TodoFilter, from pending
    }

    if (state is TodosFilterLoaded) {
      // Casting the below state as "class TodosFilterLoaded extends TodosFilterState"
      final state = this.state as TodosFilterLoaded;
      add(
        UpdateTodos(
          todosFilter: state
              .todosFilter, // Taking the status from the state's todosFilter block

          // After the above line, we'll need to go to the main.dart, and create an instance of the todoFilterBloc...
        ),
      );
    }
  }

  void _onUpdateTodos(UpdateTodos event, Emitter<TodosFilterState> emit) {
    final state = _todosBloc.state;
    if (state is TodosLoaded) {
      /**
       * Here we will use the switch statement to loop through the state.todos, and check which
       * one we will be showing, 
       * 1. In the case of all, we show all the todos.
       * 2. In the case of completed, we will return todos with isCompleted set to true...
       * 3. In the case of cancelled, we will return todos with isCancelled set to true...
       * 4. In the case of pending, we will return todos whose isCompleted and isCancelled are set to false... as the ! in front, changes it to true...
       */
      List<Todo> todos = state.todos.where((todo) {
        switch (event.todosFilter) {
          case TodosFilter.all:
            return true;
          case TodosFilter.completed:
            return todo.isCompleted!;
          case TodosFilter.cancelled:
            return todo.isCancelled!;
          case TodosFilter.pending:
            return !(todo.isCancelled! || todo.isCompleted!);
        }
      }).toList();
      emit(TodosFilterLoaded(filteredTodos: todos));
    }
  }
}
