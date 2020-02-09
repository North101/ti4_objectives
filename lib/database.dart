import 'dart:io';

import 'package:flutter/material.dart' show BuildContext;
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

part 'database.g.dart';

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(
  include: {
    'sql/game_objective.moor',
    'sql/game.moor',
    'sql/objective_type.moor',
    'sql/objective.moor',
    'sql/player_objective.moor',
    'sql/player.moor',
    'sql/race.moor',
    'sql/test.moor',
  },
)
class AppDb extends _$AppDb {
  AppDb() : super(VmDatabase.memory());
  AppDb.memory() : super(VmDatabase.memory());

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

extension ListGameObjectiveResultExt on ListGameObjectiveByGameIdResult {
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
