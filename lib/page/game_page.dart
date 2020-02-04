import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:reorderables/reorderables.dart';
import 'package:ti4_objectives/database.dart';
import 'package:ti4_objectives/main.dart';
import 'package:ti4_objectives/page/add_objective.dart';
import 'package:ti4_objectives/page/player_page.dart';
import 'package:ti4_objectives/page/remove_game_objective.dart';
import 'package:ti4_objectives/widget/game_objective.dart';
import 'package:ti4_objectives/widget/player_score.dart';
import 'package:uuid/uuid.dart';

class GamePage extends StatelessWidget {
  final String gameId;

  GamePage({Key key, this.gameId}) : super(key: key);

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
                      return PlayerPage(player: player);
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

  Widget buildObjectivePlayerIcon(BuildContext context, ListPlayerObjectiveByGameIdResult playerObjective) {
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
      onTap: playerObjective.objectiveId != null
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

  Widget buildObjectiveImage(BuildContext context, ListGameObjectiveResult objective) {
    final db = AppDb.of(context);
    return GameObjectiveWidget(
      objective: objective.toGameObjective(),
      height: OBJECTIVE_IMAGE_HEIGHT,
      width: OBJECTIVE_IMAGE_WIDTH,
      onTap: () async {
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
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildObjective(
    BuildContext context,
    ListGameObjectiveResult objective,
    List<ListPlayerObjectiveByGameIdResult> playerObjectiveList,
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

  Widget buildObjectiveList(BuildContext context, List<ListGameObjectiveResult> gameObjectiveList) {
    final db = AppDb.of(context);
    return StreamBuilder<List<ListPlayerObjectiveByGameIdResult>>(
      stream: db.listPlayerObjectiveByGameId(gameId).watch(),
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
    final gameObjectiveList = db.listGameObjective(gameId).watch();
    return StreamBuilder(
      stream: CombineLatestStream.list([game, gameObjectiveList]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final game = snapshot.data[0] as Game;
        final gameObjectiveList = snapshot.data[1] as List<ListGameObjectiveResult>;
        final gameObjectiveIdList = gameObjectiveList.where((objective) {
          return objective.objectiveId != null;
        }).map((objective) {
          return objective.objectiveId;
        });
        return Scaffold(
          appBar: AppBar(title: Text(game.name)),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildPlayerScore(context),
              Expanded(child: buildObjectiveList(context, gameObjectiveList)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
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
          ),
        );
      },
    );
  }
}
