///
//  Generated code. Do not modify.
//  source: protos/objective_type.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'action.pbenum.dart' as $0;

class ObjectiveTypeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ObjectiveTypeResponse', createEmptyInstance: create)
    ..e<$0.Action>(1, 'action', $pb.PbFieldType.OE, defaultOrMaker: $0.Action.ADD, valueOf: $0.Action.valueOf, enumValues: $0.Action.values)
    ..aOS(2, 'id')
    ..aOS(3, 'name')
    ..aOS(4, 'image')
    ..aOB(5, 'private')
    ..hasRequiredFields = false
  ;

  ObjectiveTypeResponse._() : super();
  factory ObjectiveTypeResponse() => create();
  factory ObjectiveTypeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObjectiveTypeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ObjectiveTypeResponse clone() => ObjectiveTypeResponse()..mergeFromMessage(this);
  ObjectiveTypeResponse copyWith(void Function(ObjectiveTypeResponse) updates) => super.copyWith((message) => updates(message as ObjectiveTypeResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ObjectiveTypeResponse create() => ObjectiveTypeResponse._();
  ObjectiveTypeResponse createEmptyInstance() => create();
  static $pb.PbList<ObjectiveTypeResponse> createRepeated() => $pb.PbList<ObjectiveTypeResponse>();
  @$core.pragma('dart2js:noInline')
  static ObjectiveTypeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObjectiveTypeResponse>(create);
  static ObjectiveTypeResponse _defaultInstance;

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
  $core.String get image => $_getSZ(3);
  @$pb.TagNumber(4)
  set image($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasImage() => $_has(3);
  @$pb.TagNumber(4)
  void clearImage() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get private => $_getBF(4);
  @$pb.TagNumber(5)
  set private($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrivate() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrivate() => clearField(5);
}

