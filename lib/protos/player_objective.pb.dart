///
//  Generated code. Do not modify.
//  source: protos/player_objective.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'action.pbenum.dart' as $0;

class PlayerObjectiveResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PlayerObjectiveResponse', createEmptyInstance: create)
    ..e<$0.Action>(1, 'action', $pb.PbFieldType.OE, defaultOrMaker: $0.Action.ADD, valueOf: $0.Action.valueOf, enumValues: $0.Action.values)
    ..aOS(2, 'playerId')
    ..aOS(3, 'objectiveId')
    ..hasRequiredFields = false
  ;

  PlayerObjectiveResponse._() : super();
  factory PlayerObjectiveResponse() => create();
  factory PlayerObjectiveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerObjectiveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PlayerObjectiveResponse clone() => PlayerObjectiveResponse()..mergeFromMessage(this);
  PlayerObjectiveResponse copyWith(void Function(PlayerObjectiveResponse) updates) => super.copyWith((message) => updates(message as PlayerObjectiveResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerObjectiveResponse create() => PlayerObjectiveResponse._();
  PlayerObjectiveResponse createEmptyInstance() => create();
  static $pb.PbList<PlayerObjectiveResponse> createRepeated() => $pb.PbList<PlayerObjectiveResponse>();
  @$core.pragma('dart2js:noInline')
  static PlayerObjectiveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerObjectiveResponse>(create);
  static PlayerObjectiveResponse _defaultInstance;

  @$pb.TagNumber(1)
  $0.Action get action => $_getN(0);
  @$pb.TagNumber(1)
  set action($0.Action v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get playerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set playerId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get objectiveId => $_getSZ(2);
  @$pb.TagNumber(3)
  set objectiveId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasObjectiveId() => $_has(2);
  @$pb.TagNumber(3)
  void clearObjectiveId() => clearField(3);
}

