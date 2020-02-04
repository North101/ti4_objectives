import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart';

class RemovePlayerObjectiveDialog extends StatelessWidget {
  final String playerId;
  final String objectiveId;

  const RemovePlayerObjectiveDialog({this.playerId, this.objectiveId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove Objective'),
      actions: <Widget>[
        FlatButton(child: Text('Cancel'), onPressed: () {
          Navigator.pop(context);
        }),
        FlatButton(child: Text('Remove'), onPressed: () async {
          await AppDb.of(context).removePlayerObjective(playerId, objectiveId);
          Navigator.pop(context);
        }),
      ],
    );
  }
}