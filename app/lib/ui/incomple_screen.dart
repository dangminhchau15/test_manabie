import 'package:app/bloc/todo_bloc.dart';
import 'package:app/dao/todo_dao.dart';
import 'package:app/model/todo.dart';
import 'package:flutter/material.dart';

class IncompleteScreen extends StatelessWidget {
  final todoBloc = TodoBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incomplete Lists"),
      ),
      body: getTodosWidget()
    );
  }

  Widget getTodosWidget() {
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
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
    todoBloc.getTodos(type: Type.Incomplete);
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
        "No Data Available",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }
}