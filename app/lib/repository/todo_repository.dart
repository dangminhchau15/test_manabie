import 'package:app/dao/todo_dao.dart';
import 'package:app/model/todo.dart';

class TodoRepository {
  final todoDao = TodoDao();

  Future getAllTodos({String query, Type type}) => todoDao.getTodos(query: query, type: type);

  Future insertTodo(Todo todo) => todoDao.createTodo(todo);

  Future updateTodo(Todo todo) => todoDao.updateTodo(todo);
}
