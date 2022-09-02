import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  Todo({
    required this.id,
    required this.task,
    required this.description,
    this.isCompleted,
    this.isCancelled,
  }) {
    isCancelled = isCancelled ?? false;
    isCompleted = isCompleted ?? false;
  }
  final String id;
  final String task;
  final String description;
  bool? isCompleted;
  bool? isCancelled;

  Todo copyWith({
    String? id,
    String? task,
    String? description,
    bool? isCompleted,
    bool? isCancelled,
  }) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }

  @override
  List<Object?> get props => [id, task, description, isCompleted, isCancelled];

  static List<Todo> todos = [
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
  ];
}
