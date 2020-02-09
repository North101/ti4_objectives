import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ti4_objectives/database.dart';
import 'package:ti4_objectives/protos/action.pbenum.dart';
import 'package:ti4_objectives/protos/game.pb.dart';
import 'package:ti4_objectives/protos/game_objective.pb.dart';
import 'package:ti4_objectives/protos/game_state.pbgrpc.dart';
import 'package:ti4_objectives/protos/objective.pb.dart';
import 'package:ti4_objectives/protos/objective_type.pb.dart';
import 'package:ti4_objectives/protos/player.pb.dart';
import 'package:ti4_objectives/protos/player_objective.pb.dart';
import 'package:ti4_objectives/protos/race.pb.dart';

class GameState {
  final Game game;
  final Set<GameObjective> gameObjectiveList;
  final Set<ObjectiveType> objectiveTypeList;
  final Set<Objective> objectiveList;
  final Set<PlayerObjective> playerObjectiveList;
  final Set<Player> playerList;
  final Set<Race> raceList;

  const GameState({
    this.game,
    this.gameObjectiveList,
    this.objectiveTypeList,
    this.objectiveList,
    this.playerObjectiveList,
    this.playerList,
    this.raceList,
  });

  GameStateResponse toResponse(int version, GameState oldGameState) {
    final response = GameStateResponse()
      ..resync = oldGameState == null
      ..version = version;

    if (oldGameState?.objectiveTypeList != this.objectiveTypeList) {
      response.objectiveTypeMap.addAll(this.objectiveTypeList.where((entry) {
        return oldGameState == null || !oldGameState.objectiveTypeList.contains(entry);
      }).map((entry) {
        final isNew = !(oldGameState?.objectiveTypeList?.any((element) {
              return element.id == entry.id;
            }) ??
            false);
        return ObjectiveTypeResponse()
          ..action = isNew ? Action.ADD : Action.UPDATE
          ..id = entry.id
          ..name = entry.name
          ..image = entry.image
          ..private = entry.private;
      }));
      if (oldGameState != null) {
        response.objectiveTypeMap.addAll(oldGameState.objectiveTypeList.where((entry) {
          return !this.objectiveTypeList.any((element) {
            return element.id == entry.id;
          });
        }).map((entry) {
          return ObjectiveTypeResponse()
            ..action = Action.REMOVE
            ..id = entry.id
            ..name = entry.name
            ..image = entry.image
            ..private = entry.private;
        }));
      }
    }

    if (oldGameState?.objectiveList != this.objectiveList) {
      response.objectiveMap.addAll(this.objectiveList.where((entry) {
        return oldGameState == null || !oldGameState.objectiveList.contains(entry);
      }).map((entry) {
        final isNew = !(oldGameState?.objectiveList?.any((element) {
              return element.id == entry.id;
            }) ??
            false);
        return ObjectiveResponse()
          ..action = isNew ? Action.ADD : Action.UPDATE
          ..id = entry.id
          ..name = entry.name
          ..objectiveTypeId = entry.objectiveTypeId
          ..value = entry.value
          ..image = entry.image
          ..toggle = entry.toggle;
      }));
      if (oldGameState != null) {
        response.objectiveMap.addAll(oldGameState.objectiveList.where((entry) {
          return !this.objectiveList.any((element) {
            return element.id == entry.id;
          });
        }).map((entry) {
          return ObjectiveResponse()
            ..action = Action.REMOVE
            ..id = entry.id
            ..name = entry.name
            ..objectiveTypeId = entry.objectiveTypeId
            ..value = entry.value
            ..image = entry.image
            ..toggle = entry.toggle;
        }));
      }
    }

    if (oldGameState?.raceList != this.raceList) {
      response.raceMap.addAll(this.raceList.where((entry) {
        return oldGameState == null || !oldGameState.raceList.contains(entry);
      }).map((entry) {
        final isNew = !(oldGameState?.raceList?.any((element) {
              return element.id == entry.id;
            }) ??
            false);
        return RaceResponse()
          ..action = isNew ? Action.ADD : Action.UPDATE
          ..id = entry.id
          ..name = entry.name
          ..image = entry.image;
      }));
      if (oldGameState != null) {
        response.raceMap.addAll(oldGameState.raceList.where((entry) {
          return !this.raceList.any((element) {
            return element.id == entry.id;
          });
        }).map((entry) {
          return RaceResponse()
            ..action = Action.REMOVE
            ..id = entry.id
            ..name = entry.name
            ..image = entry.image;
        }));
      }
    }

    if (oldGameState?.game != this.game) {
      response.game = GameResponse()
        ..id = this.game.id
        ..name = this.game.name;
    }

    if (oldGameState?.gameObjectiveList != this.gameObjectiveList) {
      response.gameObjectiveMap.addAll(this.gameObjectiveList.where((entry) {
        return oldGameState == null || !oldGameState.gameObjectiveList.contains(entry);
      }).map((entry) {
        final isNew = !(oldGameState?.gameObjectiveList?.any((element) {
              return element.id == entry.id;
            }) ??
            false);
        final resp = GameObjectiveResponse()
          ..action = isNew ? Action.ADD : Action.UPDATE
          ..id = entry.id
          ..gameId = entry.gameId
          ..position = entry.position
          ..objectiveTypeId = entry.objectiveTypeId;
        if (entry.objectiveId != null) {
          resp.objectiveId = entry.objectiveId;
        }
        return resp;
      }));
      if (oldGameState != null) {
        response.gameObjectiveMap.addAll(oldGameState.gameObjectiveList.where((entry) {
          return !this.gameObjectiveList.any((element) {
            return element.id == entry.id;
          });
        }).map((entry) {
          final resp = GameObjectiveResponse()
            ..action = Action.REMOVE
            ..id = entry.id
            ..gameId = entry.gameId
            ..position = entry.position
            ..objectiveTypeId = entry.objectiveTypeId;
          if (entry.objectiveId != null) {
            resp.objectiveId = entry.objectiveId;
          }
          return resp;
        }));
      }
    }

    if (oldGameState?.playerList != this.playerList) {
      response.playerMap.addAll(this.playerList.where((entry) {
        return oldGameState == null || !oldGameState.playerList.contains(entry);
      }).map((entry) {
        final isNew = !(oldGameState?.playerList?.any((element) {
              return element.id == entry.id;
            }) ??
            false);
        return PlayerResponse()
          ..action = isNew ? Action.ADD : Action.UPDATE
          ..id = entry.id
          ..gameId = entry.gameId
          ..name = entry.name
          ..raceId = entry.raceId;
      }));
      if (oldGameState != null) {
        response.playerMap.addAll(oldGameState.playerList.where((entry) {
          return !this.playerList.any((element) {
            return element.id == entry.id;
          });
        }).map((entry) {
          return PlayerResponse()
            ..action = Action.REMOVE
            ..id = entry.id
            ..name = entry.name;
        }));
      }
    }

    if (oldGameState?.playerObjectiveList != this.playerObjectiveList) {
      response.playerObjectiveMap.addAll(this.playerObjectiveList.where((entry) {
        return oldGameState == null || !oldGameState.playerObjectiveList.contains(entry);
      }).map((entry) {
        final isNew = !(oldGameState?.playerObjectiveList?.any((element) {
              return element.playerId == entry.playerId && element.objectiveId == entry.objectiveId;
            }) ??
            false);
        return PlayerObjectiveResponse()
          ..action = isNew ? Action.ADD : Action.UPDATE
          ..playerId = entry.playerId
          ..objectiveId = entry.objectiveId;
      }));
      if (oldGameState != null) {
        response.playerObjectiveMap.addAll(oldGameState.playerObjectiveList.where((entry) {
          return !this.playerObjectiveList.any((element) {
            return element.playerId == entry.playerId && element.objectiveId == entry.objectiveId;
          });
        }).map((entry) {
          return PlayerObjectiveResponse()
            ..action = Action.REMOVE
            ..playerId = entry.playerId
            ..objectiveId = entry.objectiveId;
        }));
      }
    }

    return response;
  }
}

class GameStateStream extends Stream<GameState> {
  final AppDb db;
  final String gameId;

  GameStateStream(this.db, this.gameId) : super();

  @override
  StreamSubscription<GameState> listen(
    void Function(GameState event) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) {
    return CombineLatestStream.combine7(
      db.listObjectiveType().watch(),
      db.listObjective().watch(),
      db.listRace().watch(),
      db.readGame(gameId).watchSingle(),
      db.listRawGameObjectiveByGameId(gameId).watch(),
      db.listRawPlayerObjectiveByGameId(gameId).watch(),
      db.listRawPlayerByGameId(gameId).watch(),
      (
        List<ObjectiveType> objectiveTypeList,
        List<Objective> objectiveList,
        List<Race> raceList,
        Game game,
        List<GameObjective> gameObjectiveList,
        List<PlayerObjective> playerObjectiveList,
        List<Player> playerList,
      ) {
        return GameState(
          objectiveTypeList: objectiveTypeList.toSet(),
          objectiveList: objectiveList.toSet(),
          raceList: raceList.toSet(),
          game: game,
          gameObjectiveList: gameObjectiveList.toSet(),
          playerObjectiveList: playerObjectiveList.toSet(),
          playerList: playerList.toSet(),
        );
      },
    ).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class GameStateService extends GameStateServiceBase {
  final BehaviorSubject<GameState> gameStateStream;

  GameStateService(this.gameStateStream);

  @override
  Stream<GameStateResponse> requestGameState(ServiceCall call, GameStateRequest request) {
    int version = 0;
    GameState oldGameState;
    return gameStateStream.throttleTime(Duration(milliseconds: 100), trailing: true).map((newGameState) {
      final response = newGameState.toResponse(++version, oldGameState);
      oldGameState = newGameState;
      return response;
    });
  }
}
