import 'package:flutter/material.dart';

import './comment_bloc.dart';
export './comment_bloc.dart'; // export : CommentsProvider를 사용하는 곳에서 CommentsBloc 을 사용할 수 있도록 함.

class CommentsProvider extends InheritedWidget {
  final CommentsBloc bloc;

  CommentsProvider({Key? key, required Widget child})
      : bloc = CommentsBloc(),
        super(key: key, child: child);

  @override
  // bool updateShouldNotify(covariant InheritedWidget oldWidget) { }
  bool updateShouldNotify(_) => true;

  // Provider 를 통해서 Bloc 를 사용할 수 있도록 만듬.
  static CommentsBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CommentsProvider>()
            as CommentsProvider)
        .bloc;
  }
}
