import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart' hide Player;
import 'package:ti4_objectives/screens/new_game_page.dart';
import 'package:uuid/uuid.dart';

class NewPlayerDialog extends StatefulWidget {
  final bool Function(Race race) filterRaceItems;

  const NewPlayerDialog({Key key, this.filterRaceItems}) : super(key: key);

  @override
  _NewPlayerDialogState createState() => _NewPlayerDialogState();
}

class _NewPlayerDialogState extends State<NewPlayerDialog> {
  final _nameController = TextEditingController();
  String _nameError;
  Race _selectedRace;

  bool hasError() {
    return _nameError != null || _selectedRace == null;
  }

  @override
  Widget build(BuildContext context) {
    final db = AppDb.of(context);
    return AlertDialog(
      title: Text('New Player'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Player name',
              errorText: _nameError,
            ),
            onChanged: (value) {
              String nameError;
              if (value.trim().isEmpty) {
                nameError = 'Name is empty';
              }
              setState(() {
                _nameError = nameError;
              });
            },
          ),
          StreamBuilder<List<Race>>(
            stream: db.listRace().watch(),
            builder: (context, snapshot) {
              final raceList = snapshot.data ?? [];
              return DropdownButton<Race>(
                hint: Text('Select Race'),
                isExpanded: true,
                itemHeight: 64,
                value: _selectedRace,
                items: raceList.where(widget.filterRaceItems).map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: ListTile(
                      leading: Image.asset('assets/${item.image}', height: 24),
                      title: Text(item.name),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRace = value;
                  });
                },
              );
            },
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: hasError()
              ? null
              : () {
                  Navigator.pop(
                    context,
                    PlayerValue(
                      Uuid().v4(),
                      _nameController.text,
                      _selectedRace,
                    ),
                  );
                },
        ),
      ],
    );
  }
}
