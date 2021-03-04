import 'package:app/bloc/todo_bloc.dart';
import 'package:app/dao/todo_dao.dart';
import 'package:app/model/todo.dart';
import 'package:flutter/material.dart';

class AllScreen extends StatelessWidget {
  final todoBloc = TodoBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo List",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: getTodosWidget(),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            elevation: 5.0,
            onPressed: () {
              _showAddTodoSheet(context);
            },
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.add,
              size: 32,
              color: Colors.white,
            ),
          ),
        ));
  }

  Widget getTodosWidget() {
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  void _showAddTodoSheet(BuildContext context) {
    final _todoDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _todoDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'I have to...',
                                  labelText: 'New Todo',
                                  labelStyle: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500)),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newTodo = Todo(
                                      description:
                                          _todoDescriptionFormController
                                              .value.text);
                                  if (newTodo.description.isNotEmpty) {
                                    todoBloc.addTodo(newTodo);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Todo todo = snapshot.data[index];
                return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey[200], width: 0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Colors.white,
                    child: ListTile(
                        trailing: InkWell(
                          onTap: () {
                            todo.isDone = !todo.isDone;
                            todoBloc.updateTodo(todo);
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: todo.isDone
                                  ? Icon(Icons.done,
                                      size: 26.0, color: Colors.red)
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      size: 26.0,
                                      color: Colors.blue,
                                    ),
                            ),
                          ),
                        ),
                        title: Text(todo.description,
                            style: TextStyle(
                              fontSize: 16.5,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.w500,
                            ))));
              },
            )
          : Container(
              child: Center(
              child: noTodoMessageWidget(),
            ));
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    todoBloc.getTodos(type: Type.ALL);
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        "Start adding Todo...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }
}
