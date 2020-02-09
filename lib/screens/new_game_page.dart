import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart';
import 'package:ti4_objectives/screens/game_page.dart';
import 'package:ti4_objectives/screens/new_player_dialog.dart';
import 'package:uuid/uuid.dart';

class PlayerValue {
  final String id;
  final String name;
  final Race race;

  PlayerValue(this.id, this.name, this.race);
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

class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final Widget Function(BuildContext context, E removedItem, Animation<double> animation) removedItemBuilder;
  final List<E> _items;

  SliverAnimatedListState get _animatedList => listKey.currentState;

  void add(E item) {
    insert(length, item);
  }

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  void move(int oldIndex, int newIndex) {
    insert(newIndex, removeAt(oldIndex));
  }

  E removeAt(int index) {
    final removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(index, (BuildContext context, Animation<double> animation) {
        return removedItemBuilder(context, removedItem, animation);
      });
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class NewGameStep2Page extends StatefulWidget {
  final String name;
  final List<PlayerValue> playerList;

  const NewGameStep2Page({Key key, this.name, this.playerList}) : super(key: key);

  @override
  _NewGameStep2PageState createState() => _NewGameStep2PageState();
}

class _NewGameStep2PageState extends State<NewGameStep2Page> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();
  ListModel<PlayerValue> _playerList;

  @override
  void initState() {
    super.initState();

    _playerList = ListModel(
      listKey: _listKey,
      initialItems: widget.playerList,
      removedItemBuilder: _buildRemovedItem,
    );
  }

  Widget buildItem(BuildContext context, int index, PlayerValue item, Animation<double> animation) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: ListTile(
        leading: Image.asset('assets/${item.race.image}', height: 24, width: 24),
        title: Text(item.name),
        subtitle: Text(item.race.name),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: index != null
              ? () {
                  setState(() {
                    _playerList.removeAt(index);
                  });
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildRemovedItem(BuildContext context, PlayerValue item, Animation<double> animation) {
    return buildItem(context, null, item, animation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Players')),
      body: Step(
        child: CustomScrollView(slivers: [
          SliverAnimatedList(
            key: _listKey,
            initialItemCount: _playerList.length,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              final item = _playerList[index];
              return buildItem(context, index, item, animation);
            },
          ),
        ]),
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
              await db.createGame(gameId, widget.name, true);
              for (final player in _playerList._items) {
                await db.createPlayer(player.id, gameId, player.race.id, player.name);
              }
              for (var i = 0; i < 5; i++) {
                await db.addGameObjective(Uuid().v4(), gameId, i, 'phase_1', null);
              }
              for (var i = 5; i < 10; i++) {
                await db.addGameObjective(Uuid().v4(), gameId, i, 'phase_2', null);
              }
            });

            await Navigator.pushAndRemoveUntil(context, MaterialPageRoute<GameServerPage>(builder: (context) {
              return GameServerPage(gameId: gameId);
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
                final raceIds = _playerList._items.map((player) => player.race.id);
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
