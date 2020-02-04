import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart';

class RemoveGameObjectiveDialog extends StatelessWidget {
  final GameObjective gameObjective;

  const RemoveGameObjectiveDialog({this.gameObjective});

  @override
  Widget build(BuildContext context) {
    final db = AppDb.of(context);
    return AlertDialog(
      title: Text('Remove Objective'),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Hide'),
          onPressed: () async {
            await db.transaction(() async {
              await db.removePlayerObjectiveByObjectiveId(gameObjective.objectiveId);
              await db.hideGameObjective(gameObjective.id);
            });
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Remove'),
          onPressed: () async {
            await db.transaction(() async {
              await db.removePlayerObjectiveByObjectiveId(gameObjective.id);

              await db.removeGameObjective(gameObjective.id);
              final gameObjectiveList = await db.listGameObjective(gameObjective.gameId).get();
              for (final gameObjective in gameObjectiveList.asMap().entries) {
                await db.updateGameObjectivePosition(gameObjective.key, gameObjective.value.id);
              }
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
