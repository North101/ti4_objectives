import 'package:flutter/material.dart' hide Action;
import 'package:grpc/grpc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:reorderables/reorderables.dart';
import 'package:ti4_objectives/database.dart';
import 'package:ti4_objectives/main.dart';
import 'package:ti4_objectives/screens/add_objective.dart';
import 'package:ti4_objectives/screens/host_game_dialog.dart';
import 'package:ti4_objectives/screens/player_page.dart';
import 'package:ti4_objectives/screens/remove_game_objective.dart';
import 'package:ti4_objectives/protos/action.pbenum.dart';
import 'package:ti4_objectives/protos/game_state.pbgrpc.dart';
import 'package:ti4_objectives/server.dart';
import 'package:ti4_objectives/widgets/game_objective.dart';
import 'package:ti4_objectives/widgets/player_score.dart';
import 'package:uuid/uuid.dart';

class GameServerPage extends StatelessWidget {
  final String gameId;

  const GameServerPage({Key key, this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<GameStateServer>(
      create: (BuildContext context) {
        return GameStateServer(AppDb.of(context), gameId);
      },
      dispose: (BuildContext context, GameStateServer value) {
        value.close();
      },
      child: _GamePage(gameId: gameId, local: true),
    );
  }
}

class GameClientPage extends StatefulWidget {
  final String host;
  final int port;

  const GameClientPage({Key key, this.host, this.port}) : super(key: key);

  @override
  _GameClientPageState createState() => _GameClientPageState();
}

class _GameClientPageState extends State<GameClientPage> {
  final gameIdNotifier = ValueNotifier<String>(null);
  int nextVersion;

  void updateGameState(BuildContext context, GameStateResponse data) async {
    if (data.resync && nextVersion != null) {
      throw ('Expected resync before 1st response');
    } else if (!data.resync && nextVersion != data.version) {
      throw ('Expected version $nextVersion. Got version ${data.version}');
    }
    print(data.version);
    nextVersion = data.version + 1;

    final db = AppDb.of(context);
    await db.transaction(() async {
      if (data.resync) {
        final game = data.game;
        await db.createGame(game.id, game.name, false);
        await db.removeGameObjectiveByGameId(game.id);
        await db.removePlayerObjectiveByGameId(game.id);
        await db.deletePlayerByGameId(game.id);
      }
      for (final player in data.playerMap) {
        if (player.action == Action.ADD || player.action == Action.UPDATE) {
          await db.createPlayer(
            player.id,
            player.gameId,
            player.raceId,
            player.name,
          );
        } else if (player.action == Action.REMOVE) {
          await db.deletePlayerById(player.id);
        }
      }
      for (final playerObjective in data.playerObjectiveMap) {
        if (playerObjective.action == Action.ADD || playerObjective.action == Action.UPDATE) {
          await db.addPlayerObjective(
            playerObjective.playerId,
            playerObjective.objectiveId,
          );
        } else if (playerObjective.action == Action.REMOVE) {
          await db.removePlayerObjective(playerObjective.playerId, playerObjective.objectiveId);
        }
      }
      for (final gameObjective in data.gameObjectiveMap) {
        if (gameObjective.action == Action.ADD || gameObjective.action == Action.UPDATE) {
          await db.addGameObjective(
            gameObjective.id,
            gameObjective.gameId,
            gameObjective.position,
            gameObjective.objectiveTypeId,
            gameObjective.objectiveId,
          );
        } else if (gameObjective.action == Action.REMOVE) {
          await db.removeGameObjective(gameObjective.id);
        }
      }
    });

    if (data.hasGame()) {
      gameIdNotifier.value = data.game.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ClientChannel>(
          lazy: false,
          create: (BuildContext context) {
            final channel = ClientChannel(
              widget.host,
              port: widget.port,
              options: const ChannelOptions(
                credentials: ChannelCredentials.insecure(),
                connectionTimeout: Duration(seconds: 10),
              ),
            );
            final stub = GameStateServiceClient(channel);
            final stream = stub.requestGameState(GameStateRequest());
            stream.listen((value) {
              updateGameState(context, value);
            }, onError: (dynamic error) {
              print(error);
              channel.shutdown();
              if (mounted) {
                Navigator.pop<dynamic>(context, error);
              }
            }, onDone: () {
              print('shutdown');
              channel.shutdown();
              if (mounted) {
                Navigator.pop(context);
              }
            }, cancelOnError: true);

            return channel;
          },
          dispose: (BuildContext context, ClientChannel value) {
            value.shutdown();
          },
        ),
      ],
      child: ValueListenableBuilder<String>(
        valueListenable: gameIdNotifier,
        builder: (context, value, widget) {
          if (value == null) {
            return Scaffold(
              appBar: AppBar(title: Text('Loading')),
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return _GamePage(gameId: value, local: false);
        },
      ),
    );
  }
}

class _GamePage extends StatelessWidget {
  final String gameId;
  final bool local;

  const _GamePage({
    Key key,
    this.gameId,
    this.local,
  }) : super(key: key);

  Widget buildPlayerScore(BuildContext context) {
    return StreamBuilder<List<ListPlayerScoreByGameIdResult>>(
      stream: AppDb.of(context).listPlayerScoreByGameId(gameId).watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final playerList = snapshot.data..sort((a, b) => b.score.compareTo(a.score));
        return Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(4),
            child: Row(
              children: playerList.map((player) {
                return PlayerScore(
                  player: player,
                  onTap: () {
                    Navigator.push<void>(context, MaterialPageRoute(builder: (context) {
                      return PlayerPage(player: player, local: local);
                    }));
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget buildObjectivePlayerIcon(BuildContext context, ListGameObjectiveResultsByGameIdResult playerObjective) {
    final db = AppDb.of(context);
    return InkWell(
      child: Padding(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: Opacity(
            key: ValueKey(playerObjective.done),
            child: Image.asset('assets/${playerObjective.raceImage}', height: 20),
            opacity: playerObjective.done ? 1.0 : 0.4,
          ),
        ),
        padding: EdgeInsets.all(1),
      ),
      onTap: local && playerObjective.objectiveId != null
          ? () async {
              if (playerObjective.done) {
                await db.removePlayerObjective(playerObjective.playerId, playerObjective.objectiveId);
              } else if (playerObjective.toggle) {
                await db.transaction(() async {
                  await db.removePlayerObjectiveByObjectiveId(playerObjective.objectiveId);
                  await db.addPlayerObjective(playerObjective.playerId, playerObjective.objectiveId);
                });
              } else {
                await db.addPlayerObjective(playerObjective.playerId, playerObjective.objectiveId);
              }
            }
          : null,
    );
  }

  Widget buildObjectiveImage(BuildContext context, ListGameObjectiveByGameIdResult objective) {
    final db = AppDb.of(context);
    return GameObjectiveWidget(
      objective: objective.toGameObjective(),
      height: OBJECTIVE_IMAGE_HEIGHT,
      width: OBJECTIVE_IMAGE_WIDTH,
      onTap: local
          ? () async {
              if (objective.objectiveId == null) {
                await db.revealGameObjective(gameId, objective.id);
              } else {
                await showDialog<Objective>(
                  context: context,
                  builder: (context) => RemoveGameObjectiveDialog(
                    gameObjective: GameObjective(
                      id: objective.id,
                      gameId: objective.gameId,
                      position: objective.position,
                      objectiveTypeId: objective.objectiveTypeId,
                      objectiveId: objective.objectiveId,
                    ),
                  ),
                );
              }
            }
          : null,
    );
  }

  Widget buildObjective(
    BuildContext context,
    ListGameObjectiveByGameIdResult objective,
    List<ListGameObjectiveResultsByGameIdResult> playerObjectiveList,
  ) {
    return Padding(
      key: ValueKey(objective.id),
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: playerObjectiveList.map((playerObjective) {
              return buildObjectivePlayerIcon(context, playerObjective);
            }).toList(),
          ),
          buildObjectiveImage(context, objective),
        ],
      ),
    );
  }

  Widget buildObjectiveList(BuildContext context, List<ListGameObjectiveByGameIdResult> gameObjectiveList) {
    final db = AppDb.of(context);
    return StreamBuilder<List<ListGameObjectiveResultsByGameIdResult>>(
      stream: db.listGameObjectiveResultsByGameId(gameId).watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final playerObjectiveResult = snapshot.data;
        return ReorderableWrap(
          children: gameObjectiveList.map((item) {
            return buildObjective(
              context,
              item,
              playerObjectiveResult.where((value) {
                return value.id == item.id;
              }).toList(),
            );
          }).toList(),
          onReorder: (oldIndex, newIndex) async {
            final objectiveList = gameObjectiveList;
            objectiveList.insert(newIndex, objectiveList.removeAt(oldIndex));

            await db.transaction(() async {
              for (final entry in objectiveList.asMap().entries) {
                await db.updateGameObjectivePosition(entry.key, entry.value.id);
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = AppDb.of(context);
    final game = db.readGame(gameId).watchSingle();
    final gameObjectiveList = db.listGameObjectiveByGameId(gameId).watch();
    return StreamBuilder(
      stream: CombineLatestStream.list([game, gameObjectiveList]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final game = snapshot.data[0] as Game;
        final gameObjectiveList = snapshot.data[1] as List<ListGameObjectiveByGameIdResult>;
        final gameObjectiveIdList = gameObjectiveList.where((objective) {
          return objective.objectiveId != null;
        }).map((objective) {
          return objective.objectiveId;
        });
        return Scaffold(
          appBar: AppBar(
            title: Text(game.name),
            actions: <Widget>[
              if (this.local)
                Consumer<GameStateServer>(builder: (context, gameStateServer, widget) {
                  return ValueListenableBuilder<ServerStatus>(
                    valueListenable: gameStateServer.status,
                    builder: (context, status, widget) {
                      return IconButton(
                        icon: Icon(status == ServerStatus.Serving ? Icons.cast_connected : Icons.cast),
                        onPressed: () async {
                          if (status == ServerStatus.Serving) {
                            await gameStateServer.shutdown();
                          } else {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return HostGameDialog();
                              },
                            );
                            if (result != true) return;

                            await gameStateServer.serve();
                          }
                        },
                      );
                    },
                  );
                }),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildPlayerScore(context),
              Expanded(child: buildObjectiveList(context, gameObjectiveList)),
            ],
          ),
          floatingActionButton: local
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () async {
                    final objectiveResult = await showDialog<AddObjectiveResult>(
                      context: context,
                      builder: (context) {
                        return AddObjectiveDialog(
                          filterObjective: (objective) {
                            return !gameObjectiveIdList.contains(objective.id);
                          },
                        );
                      },
                    );
                    if (objectiveResult == null) return;

                    await db.addGameObjective(
                      Uuid().v4(),
                      gameId,
                      gameObjectiveList.length,
                      objectiveResult.objectiveTypeId,
                      objectiveResult.objectiveId,
                    );
                  },
                )
              : null,
        );
      },
    );
  }
}
