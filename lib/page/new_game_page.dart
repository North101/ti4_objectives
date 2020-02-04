import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart';
import 'package:ti4_objectives/page/game_page.dart';
import 'package:ti4_objectives/page/new_player_dialog.dart';
import 'package:uuid/uuid.dart';

class PlayerValue {
  final String name;
  final Race race;

  PlayerValue(this.name, this.race);
}

class NewGameStep1Page extends StatefulWidget {
  @override
  _NewGameStep1PageState createState() => _NewGameStep1PageState();
}

class _NewGameStep1PageState extends State<NewGameStep1Page> {
  final _nameController = TextEditingController();
  String _nameError = 'Name is empty';
  List<PlayerValue> _playerList;

  bool get hasError {
    return _nameError != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Game')),
      body: Step(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Game name',
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
              ],
            ),
          ),
        ),
        backChild: FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        nextChild: FlatButton(
          child: Text('Next'),
          color: Colors.blue,
          textColor: Colors.white,
          splashColor: Colors.blueAccent,
          disabledColor: Colors.grey[300],
          onPressed: hasError
              ? null
              : () async {
                  _playerList = await Navigator.push<List<PlayerValue>>(context, MaterialPageRoute(builder: (context) {
                    return NewGameStep2Page(name: _nameController.text, playerList: _playerList);
                  }));
                },
        ),
      ),
    );
  }
}

class NewGameStep2Page extends StatefulWidget {
  final String name;
  final List<PlayerValue> playerList;

  const NewGameStep2Page({Key key, this.name, this.playerList}) : super(key: key);

  @override
  _NewGameStep2PageState createState() => _NewGameStep2PageState();
}

class _NewGameStep2PageState extends State<NewGameStep2Page> {
  final List<PlayerValue> _playerList = [];

  @override
  void initState() {
    super.initState();

    if (widget.playerList != null) {
      _playerList.addAll(widget.playerList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Players')),
      body: Step(
        child: ListView.builder(
          itemCount: _playerList.length,
          itemBuilder: (context, index) {
            final item = _playerList[index];
            return ListTile(
              leading: Image.asset('assets/${item.race.image}', height: 24, width: 24),
              title: Text(item.name),
              subtitle: Text(item.race.name),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _playerList.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
        backChild: FlatButton(
          child: Text('Back'),
          onPressed: () {
            Navigator.pop(context, _playerList);
          },
        ),
        nextChild: FlatButton(
          child: Text('Save'),
          color: Colors.blue,
          textColor: Colors.white,
          splashColor: Colors.blueAccent,
          onPressed: () async {
            final db = AppDb.of(context);

            final gameId = Uuid().v4();
            await db.transaction<void>(() async {
              await db.createGame(gameId, widget.name);
              for (final player in _playerList) {
                await db.createPlayer(Uuid().v4(), gameId, player.race.id, player.name);
              }
              for (var i = 0; i < 5; i++) {
                await db.addGameObjective(Uuid().v4(), gameId, i, 'phase_1', null);
              }
              for (var i = 5; i < 10; i++) {
                await db.addGameObjective(Uuid().v4(), gameId, i, 'phase_2', null);
              }
            });

            await Navigator.pushAndRemoveUntil(context, MaterialPageRoute<GamePage>(builder: (context) {
              return GamePage(gameId: gameId);
            }), (route) {
              return route.isFirst;
            });
          },
        ),
      ),
      floatingActionButton: Padding(
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final playerResult = await showDialog<PlayerValue>(
              context: context,
              builder: (context) {
                final raceIds = _playerList.map((player) => player.race.id);
                return NewPlayerDialog(filterRaceItems: (race) {
                  return !raceIds.contains(race.id);
                });
              },
            );
            if (playerResult == null) return;

            setState(() {
              _playerList.add(playerResult);
            });
          },
        ),
        padding: const EdgeInsets.only(bottom: 64.0),
      ),
    );
  }
}

class Step extends StatelessWidget {
  final Widget child;
  final Widget nextChild;
  final Widget backChild;

  const Step({Key key, this.child, this.nextChild, this.backChild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Expanded(child: child),
          Divider(height: 8),
          Row(children: [
            backChild,
            Spacer(),
            nextChild,
          ]),
        ],
      ),
    );
  }
}
