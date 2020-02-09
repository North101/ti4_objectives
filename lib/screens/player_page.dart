import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart';
import 'package:ti4_objectives/main.dart';
import 'package:ti4_objectives/screens/add_objective.dart';
import 'package:ti4_objectives/screens/remove_player_objective.dart';
import 'package:ti4_objectives/widgets/game_objective.dart';
import 'package:ti4_objectives/widgets/player_score.dart';

class PlayerPage extends StatelessWidget {
  final ListPlayerScoreByGameIdResult player;
  final bool local;

  const PlayerPage({
    Key key,
    this.player,
    this.local,
  }) : super(key: key);

  Widget buildObjective(BuildContext context, ListPlayerObjectiveByPlayerIdResult objective) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: GameObjectiveWidget(
        objective: objective.toGameObjective(),
        height: OBJECTIVE_IMAGE_HEIGHT,
        width: OBJECTIVE_IMAGE_WIDTH,
        onTap: local
            ? () {
                showDialog<void>(
                  context: context,
                  builder: (context) => RemovePlayerObjectiveDialog(
                    playerId: player.id,
                    objectiveId: objective.objectiveId,
                  ),
                );
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = AppDb.of(context);
    return StreamBuilder<List<ListPlayerObjectiveByPlayerIdResult>>(
      stream: db.listPlayerObjectiveByPlayerId(player.id).watch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(title: Text(player.name)),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                child: Center(
                  child: StreamBuilder<ReadPlayerScoreResult>(
                    stream: db.readPlayerScore(player.id).watchSingle(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();

                      final player = snapshot.data;
                      return PlayerScore(
                        player: ListPlayerScoreByGameIdResult(
                            id: player.id,
                            gameId: player.gameId,
                            raceId: player.raceId,
                            raceImage: player.raceImage,
                            score: player.score),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: snapshot.data.map((objective) {
                      return buildObjective(context, objective);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: local
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () async {
                    final objectiveIds = await db.listAvailablePlayerObjective(player.id).get();
                    final objectiveResult = await showDialog<AddObjectiveResult>(
                      context: context,
                      builder: (context) {
                        return AddObjectiveDialog(
                          showHidden: false,
                          filterObjectiveType: (objectiveType) {
                            return objectiveType.private;
                          },
                          filterObjective: (objective) {
                            return objectiveIds.contains(objective.id);
                          },
                        );
                      },
                    );
                    if (objectiveResult == null || objectiveResult.objectiveId == null) return;

                    await db.addPlayerObjective(player.id, objectiveResult.objectiveId);
                  },
                )
              : null,
        );
      },
    );
  }
}
