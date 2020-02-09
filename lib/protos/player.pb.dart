///
//  Generated code. Do not modify.
//  source: protos/player.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'action.pbenum.dart' as $0;

class PlayerResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PlayerResponse', createEmptyInstance: create)
    ..e<$0.Action>(1, 'action', $pb.PbFieldType.OE, defaultOrMaker: $0.Action.ADD, valueOf: $0.Action.valueOf, enumValues: $0.Action.values)
    ..aOS(2, 'id')
    ..aOS(3, 'gameId')
    ..aOS(4, 'raceId')
    ..aOS(5, 'name')
    ..hasRequiredFields = false
  ;

  PlayerResponse._() : super();
  factory PlayerResponse() => create();
  factory PlayerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PlayerResponse clone() => PlayerResponse()..mergeFromMessage(this);
  PlayerResponse copyWith(void Function(PlayerResponse) updates) => super.copyWith((message) => updates(message as PlayerResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayerResponse create() => PlayerResponse._();
  PlayerResponse createEmptyInstance() => create();
  static $pb.PbList<PlayerResponse> createRepeated() => $pb.PbList<PlayerResponse>();
  @$core.pragma('dart2js:noInline')
  static PlayerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerResponse>(create);
  static PlayerResponse _defaultInstance;

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
  $core.String get raceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set raceId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRaceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRaceId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => clearField(5);
}

