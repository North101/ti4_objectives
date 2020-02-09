///
//  Generated code. Do not modify.
//  source: protos/objective.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'action.pbenum.dart' as $0;

class ObjectiveResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ObjectiveResponse', createEmptyInstance: create)
    ..e<$0.Action>(1, 'action', $pb.PbFieldType.OE, defaultOrMaker: $0.Action.ADD, valueOf: $0.Action.valueOf, enumValues: $0.Action.values)
    ..aOS(2, 'id')
    ..aOS(3, 'name')
    ..aOS(4, 'objectiveTypeId')
    ..a<$core.int>(5, 'value', $pb.PbFieldType.O3)
    ..aOS(6, 'image')
    ..aOB(7, 'toggle')
    ..hasRequiredFields = false
  ;

  ObjectiveResponse._() : super();
  factory ObjectiveResponse() => create();
  factory ObjectiveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObjectiveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ObjectiveResponse clone() => ObjectiveResponse()..mergeFromMessage(this);
  ObjectiveResponse copyWith(void Function(ObjectiveResponse) updates) => super.copyWith((message) => updates(message as ObjectiveResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ObjectiveResponse create() => ObjectiveResponse._();
  ObjectiveResponse createEmptyInstance() => create();
  static $pb.PbList<ObjectiveResponse> createRepeated() => $pb.PbList<ObjectiveResponse>();
  @$core.pragma('dart2js:noInline')
  static ObjectiveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObjectiveResponse>(create);
  static ObjectiveResponse _defaultInstance;

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
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get objectiveTypeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set objectiveTypeId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasObjectiveTypeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearObjectiveTypeId() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get value => $_getIZ(4);
  @$pb.TagNumber(5)
  set value($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get image => $_getSZ(5);
  @$pb.TagNumber(6)
  set image($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasImage() => $_has(5);
  @$pb.TagNumber(6)
  void clearImage() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get toggle => $_getBF(6);
  @$pb.TagNumber(7)
  set toggle($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasToggle() => $_has(6);
  @$pb.TagNumber(7)
  void clearToggle() => clearField(7);
}

