import 'package:flutter/material.dart';
import './login.dart';
import './details.dart';
import './widgets/state_widget.dart';
import './widgets/gardener_listview.dart';
import './models/state.dart';
import './widgets/loading_screen.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StateModel appState;
  bool _loadingVisible = false;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading && appState.jwt == null) {
      return Login();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }

      return Scaffold(
        appBar: _buildBar(context),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LoadingScreen(
            child: GardenerListView(
              jwt: appState.jwt,
              itemTapCallback: (gardener) {
                Navigator.push(
                context, MaterialPageRoute(builder: (context) => new Details(gardener: gardener)));
              },
            ),
            inAsyncCall: _loadingVisible),
      );
    }
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.1,
      centerTitle: true,
      title: new Text("Jardiniers disponibles"),
      leading: new IconButton(
        icon: new Icon(Icons.logout),
        onPressed: () {
          StateWidget.of(context).logOutUser();
        }
      )
    );
  }

}