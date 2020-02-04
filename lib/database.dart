import 'package:flutter/material.dart' show BuildContext;
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';

part 'database.g.dart';

@UseMoor(
  include: {
    'sql/game_objective.moor',
    'sql/game.moor',
    'sql/objective_type.moor',
    'sql/objective.moor',
    'sql/player_objective.moor',
    'sql/player.moor',
    'sql/race.moor',
  },
)
class AppDb extends _$AppDb {
  AppDb() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'app.db'));

  @override
  int get schemaVersion => 1;

  static AppDb of(BuildContext context, {bool listen = false}) {
    return Provider.of<AppDb>(context, listen: listen);
  }
}

class ObjectiveWithType {
  final String objectiveId;
  final String objectiveName;
  final String objectiveTypeId;
  final String objectiveTypeImage;
  final int objectiveValue;
  final String objectiveImage;
  final bool objectiveToggle;

  const ObjectiveWithType(
    this.objectiveId,
    this.objectiveName,
    this.objectiveTypeId,
    this.objectiveTypeImage,
    this.objectiveValue,
    this.objectiveImage,
    this.objectiveToggle,
  );
}

extension ListGameObjectiveResultExt on ListGameObjectiveResult {
  ObjectiveWithType toGameObjective() {
    return ObjectiveWithType(
      objectiveId,
      objectiveName,
      objectiveTypeId,
      objectiveTypeImage,
      objectiveValue,
      objectiveImage,
      objectiveToggle,
    );
  }
}

extension ListPlayerObjectiveByPlayerIdResultExt on ListPlayerObjectiveByPlayerIdResult {
  ObjectiveWithType toGameObjective() {
    return ObjectiveWithType(
      objectiveId,
      objectiveName,
      objectiveTypeId,
      objectiveTypeImage,
      objectiveValue,
      objectiveImage,
      objectiveToggle,
    );
  }
}
