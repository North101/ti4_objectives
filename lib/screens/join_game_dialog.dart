import 'package:flutter/material.dart';
import 'package:ti4_objectives/screens/game_page.dart';

class JoinGameDialog extends StatefulWidget {
  @override
  _JoinGameDialogState createState() => _JoinGameDialogState();
}

class _JoinGameDialogState extends State<JoinGameDialog> {
  final _hostController = TextEditingController(text: '10.0.0.6');
  final _portController = TextEditingController(text: '8080');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Join Game'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _hostController,
            decoration: InputDecoration(labelText: 'Host'),
          ),
          TextField(
            controller: _portController,
            decoration: InputDecoration(labelText: 'Port'),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(child: Text('Cancel'), onPressed: () {
          Navigator.pop(context);
        }),
        FlatButton(child: Text('Join'), onPressed: () async {
          final dynamic result = await Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) {
            return GameClientPage(
              host: _hostController.text.trim(),
              port: int.tryParse(_portController.text.trim()),
            );
          }));
          if (result == null) return;

          await showDialog<void>(context: context, builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(result.toString()),
              actions: <Widget>[
                FlatButton(child: Text('Ok'), onPressed: () {
                  Navigator.pop(context);
                })
              ],
            );
          });
        }),
      ],
    );
  }
}
