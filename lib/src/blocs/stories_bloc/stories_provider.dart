import 'package:flutter/material.dart';

import './stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({Key? key, required Widget child})
      : bloc = StoriesBloc(),
        super(key: key, child: child);

  @override
  // bool updateShouldNotify(covariant InheritedWidget oldWidget) {
  bool updateShouldNotify(_) {
    // param 을 이용하지 않은 것이므로 _ 로 표시
    return true;
  }

  static StoriesBloc of(BuildContext context) {
    // old version : v2.12에서 deprecated 되었고, v3.0 에서는 사용 불가
    // return (context.InheritedFromWidgetOfExactType(StoriesProvider)
    //         as StoriesProvider)
    //     .bloc;

    // new version
    return (context.dependOnInheritedWidgetOfExactType<StoriesProvider>()
            as StoriesProvider) // as : null 대응
        .bloc;
  }
}
