import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_StateDataWidget>()).data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  //GoogleSignInAccount googleAccount;
  //final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<void> setJWT(String jwt) async {
    await storage.write(key: "jwt", value: jwt);
    await initUser();
  }

  Future<Null> initUser() async {
    var jwt = await storage.read(key: "jwt");
    if(jwt!=null){
      setState(() {
        state.isLoading = false;
        state.jwt = jwt;
      });
    }else{
      setState(() {
        state.isLoading = false;
        state.jwt = null;
      });
    }
  }

  Future<void> logOutUser() async {
    await storage.delete(key: "jwt");
    setState(() {
      state.jwt = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}