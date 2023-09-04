import 'package:flutter/material.dart';

import './stories_bloc.dart';
//  export : StoriesProvider를 사용하는 곳에서 StoriesBloc 을 사용할 수 있도록 함.
export './stories_bloc.dart';

///
/// Bloc 를 화면과 연결시키기 위한 Provider
/// - InheritedWidget 을 상속받아서 사용
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
