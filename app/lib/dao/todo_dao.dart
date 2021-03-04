import 'package:app/database/database.dart';
import 'package:app/model/todo.dart';

enum Type { ALL, Complete, Incomplete }

class TodoDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createTodo(Todo todo) async {
    final db = await dbProvider.database;
    var result = db.insert(todoTABLE, todo.toDatabaseJson());
    return result;
  }

  Future<List<Todo>> getTodos({List<String> columns, String query, Type type}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(todoTABLE,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(todoTABLE, columns: columns);
    }

    List<Todo> todos = result.isNotEmpty
        ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
        : [];

    switch (type) {
      case Type.Complete:
        return todos.where((element) => element.isDone).toList();
        break;
      case Type.Incomplete:
        return todos.where((element) => !element.isDone).toList();
        break;
      default:
        return todos;
    }
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await dbProvider.database;
    var result = await db.update(todoTABLE, todo.toDatabaseJson(),
        where: "id = ?", whereArgs: [todo.id]);

    return result;
  }
}
