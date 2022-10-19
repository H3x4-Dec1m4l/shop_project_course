import 'package:flutter/material.dart';

class CustomRout<T> extends MaterialPageRoute<T> {
  CustomRout({
    @required WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
        
      }
}
