import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:grpc/grpc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ti4_objectives/database.dart';
import 'package:ti4_objectives/game_state.dart';

enum ServerStatus {
  Init,
  Serving,
  Closing,
  Closed,
}

class GameStateServer {
  final AppDb db;
  final String gameId;

  final _gameStateController = BehaviorSubject<GameState>();
  StreamSubscription<GameState> _gameStateSubscription;
  Server _server;

  final _status = ValueNotifier<ServerStatus>(ServerStatus.Closed);
  ValueListenable<ServerStatus> get status => _status;

  GameStateServer(this.db, this.gameId);

  void serve({int port = 8080}) async {
    if (_status.value != ServerStatus.Closed) return;
    _status.value = ServerStatus.Init;

    try {
      _server = Server([GameStateService(_gameStateController)]);
      await _server.serve(port: port);

      _status.value = ServerStatus.Serving;
    } catch (e) {
      print(e);

      _server = null;
      _status.value = ServerStatus.Closed;
      throw e;
    }

    try {
      _gameStateSubscription ??= GameStateStream(db, gameId).listen((value) {
        _gameStateController.add(value);
      }, onError: (dynamic error) {
        print(error);
      });
    } catch (e) {
      print(e);

      await shutdown();
      throw e;
    }
  }

  void shutdown() async {
    if (_status.value != ServerStatus.Serving) return;
    _status.value = ServerStatus.Closing;

    await _gameStateSubscription?.cancel();
    _gameStateSubscription = null;

    await _server?.terminate();
    _server = null;

    _status.value = ServerStatus.Closed;
  }

  void close() async {
    await shutdown();
    await _gameStateController.close();
  }
}
