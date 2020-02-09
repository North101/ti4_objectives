///
//  Generated code. Do not modify.
//  source: protos/game_objective.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'action.pbenum.dart' as $0;

class GameObjectiveResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GameObjectiveResponse', createEmptyInstance: create)
    ..e<$0.Action>(1, 'action', $pb.PbFieldType.OE, defaultOrMaker: $0.Action.ADD, valueOf: $0.Action.valueOf, enumValues: $0.Action.values)
    ..aOS(2, 'id')
    ..aOS(3, 'gameId')
    ..a<$core.int>(4, 'position', $pb.PbFieldType.OU3)
    ..aOS(5, 'objectiveTypeId')
    ..aOS(6, 'objectiveId')
    ..hasRequiredFields = false
  ;

  GameObjectiveResponse._() : super();
  factory GameObjectiveResponse() => create();
  factory GameObjectiveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameObjectiveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GameObjectiveResponse clone() => GameObjectiveResponse()..mergeFromMessage(this);
  GameObjectiveResponse copyWith(void Function(GameObjectiveResponse) updates) => super.copyWith((message) => updates(message as GameObjectiveResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameObjectiveResponse create() => GameObjectiveResponse._();
  GameObjectiveResponse createEmptyInstance() => create();
  static $pb.PbList<GameObjectiveResponse> createRepeated() => $pb.PbList<GameObjectiveResponse>();
  @$core.pragma('dart2js:noInline')
  static GameObjectiveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameObjectiveResponse>(create);
  static GameObjectiveResponse _defaultInstance;

  @$pb.TagNumber(1)
  $0.Action get action => $_getN(0);
  @$pb.TagNumber(1)
  set action($0.Action v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get gameId => $_getSZ(2);
  @$pb.TagNumber(3)
  set gameId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGameId() => $_has(2);
  @$pb.TagNumber(3)
  void clearGameId() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get position => $_getIZ(3);
  @$pb.TagNumber(4)
  set position($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearPosition() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get objectiveTypeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set objectiveTypeId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasObjectiveTypeId() => $_has(4);
  @$pb.TagNumber(5)
  void clearObjectiveTypeId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get objectiveId => $_getSZ(5);
  @$pb.TagNumber(6)
  set objectiveId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasObjectiveId() => $_has(5);
  @$pb.TagNumber(6)
  void clearObjectiveId() => clearField(6);
}

