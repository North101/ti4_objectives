///
//  Generated code. Do not modify.
//  source: protos/game_state.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'objective_type.pb.dart' as $1;
import 'objective.pb.dart' as $2;
import 'race.pb.dart' as $3;
import 'game.pb.dart' as $4;
import 'game_objective.pb.dart' as $5;
import 'player.pb.dart' as $6;
import 'player_objective.pb.dart' as $7;

class GameStateRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GameStateRequest', createEmptyInstance: create)
    ..a<$core.int>(1, 'version', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  GameStateRequest._() : super();
  factory GameStateRequest() => create();
  factory GameStateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GameStateRequest clone() => GameStateRequest()..mergeFromMessage(this);
  GameStateRequest copyWith(void Function(GameStateRequest) updates) => super.copyWith((message) => updates(message as GameStateRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameStateRequest create() => GameStateRequest._();
  GameStateRequest createEmptyInstance() => create();
  static $pb.PbList<GameStateRequest> createRepeated() => $pb.PbList<GameStateRequest>();
  @$core.pragma('dart2js:noInline')
  static GameStateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameStateRequest>(create);
  static GameStateRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);
}

class GameStateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GameStateResponse', createEmptyInstance: create)
    ..a<$core.int>(1, 'version', $pb.PbFieldType.OU3)
    ..aOB(2, 'resync')
    ..pc<$1.ObjectiveTypeResponse>(3, 'objectiveTypeMap', $pb.PbFieldType.PM, subBuilder: $1.ObjectiveTypeResponse.create)
    ..pc<$2.ObjectiveResponse>(4, 'objectiveMap', $pb.PbFieldType.PM, subBuilder: $2.ObjectiveResponse.create)
    ..pc<$3.RaceResponse>(5, 'raceMap', $pb.PbFieldType.PM, subBuilder: $3.RaceResponse.create)
    ..aOM<$4.GameResponse>(6, 'game', subBuilder: $4.GameResponse.create)
    ..pc<$5.GameObjectiveResponse>(7, 'gameObjectiveMap', $pb.PbFieldType.PM, subBuilder: $5.GameObjectiveResponse.create)
    ..pc<$6.PlayerResponse>(8, 'playerMap', $pb.PbFieldType.PM, subBuilder: $6.PlayerResponse.create)
    ..pc<$7.PlayerObjectiveResponse>(9, 'playerObjectiveMap', $pb.PbFieldType.PM, subBuilder: $7.PlayerObjectiveResponse.create)
    ..hasRequiredFields = false
  ;

  GameStateResponse._() : super();
  factory GameStateResponse() => create();
  factory GameStateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameStateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GameStateResponse clone() => GameStateResponse()..mergeFromMessage(this);
  GameStateResponse copyWith(void Function(GameStateResponse) updates) => super.copyWith((message) => updates(message as GameStateResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameStateResponse create() => GameStateResponse._();
  GameStateResponse createEmptyInstance() => create();
  static $pb.PbList<GameStateResponse> createRepeated() => $pb.PbList<GameStateResponse>();
  @$core.pragma('dart2js:noInline')
  static GameStateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameStateResponse>(create);
  static GameStateResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get resync => $_getBF(1);
  @$pb.TagNumber(2)
  set resync($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasResync() => $_has(1);
  @$pb.TagNumber(2)
  void clearResync() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$1.ObjectiveTypeResponse> get objectiveTypeMap => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$2.ObjectiveResponse> get objectiveMap => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$3.RaceResponse> get raceMap => $_getList(4);

  @$pb.TagNumber(6)
  $4.GameResponse get game => $_getN(5);
  @$pb.TagNumber(6)
  set game($4.GameResponse v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasGame() => $_has(5);
  @$pb.TagNumber(6)
  void clearGame() => clearField(6);
  @$pb.TagNumber(6)
  $4.GameResponse ensureGame() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.List<$5.GameObjectiveResponse> get gameObjectiveMap => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$6.PlayerResponse> get playerMap => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<$7.PlayerObjectiveResponse> get playerObjectiveMap => $_getList(8);
}

