import 'dart:async';

import 'package:app/dao/todo_dao.dart';
import 'package:app/model/todo.dart';
import 'package:app/repository/todo_repository.dart';

class TodoBloc {
  final _todoRepository = TodoRepository();
  final _todoController = StreamController<List<Todo>>.broadcast();

  get todos => _todoController.stream;

  TodoBloc() {
    getTodos();
  }

  getTodos({String query, Type type}) async {
    _todoController.sink.add(await _todoRepository.getAllTodos(query: query, type: type));
  }

  addTodo(Todo todo) async {
    await _todoRepository.insertTodo(todo);
    getTodos();
  }

  updateTodo(Todo todo) async {
    await _todoRepository.updateTodo(todo);
    getTodos();
  }

  dispose() {
    _todoController.close();
  }
}