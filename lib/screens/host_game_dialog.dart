import 'package:flutter/material.dart';

class HostGameDialog extends StatefulWidget {
  @override
  _HostGameDialogState createState() => _HostGameDialogState();
}

class _HostGameDialogState extends State<HostGameDialog> {
  final _hostController = TextEditingController(text: '10.0.0.6');
  final _portController = TextEditingController(text: '8080');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Host Game'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _hostController,
            decoration: InputDecoration(labelText: 'Host'),
            enabled: false,
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
        FlatButton(child: Text('Host'), onPressed: () {
          Navigator.pop(context, true);
        }),
      ],
    );
  }
}
