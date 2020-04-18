import 'package:flutter/material.dart';

class ScaleToRoute extends PageRouteBuilder {
  final Widget page;
  ScaleToRoute({this.page}): super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
    page,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
      ScaleTransition(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ),
        ),
        child: child,
      ),
  );
}

class SlideToRoute extends PageRouteBuilder {
  final Widget page;
  final String type;

  SlideToRoute({this.page, this.type})
  
  : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
        page,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: _offset(type),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );

  
}

Offset _offset(type){
    if(type == "top"){
      return const Offset(0, -1);
    }else if(type == "bottom"){
      return const Offset(0, 1);
    }else if(type == "left"){
      return const Offset(-1, 0);
    }else if(type == "right"){
      return const Offset(1, 0);
    }else{
      return const Offset(0, 0);
    }
  }