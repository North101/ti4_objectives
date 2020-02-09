///
//  Generated code. Do not modify.
//  source: protos/action.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Action extends $pb.ProtobufEnum {
  static const Action ADD = Action._(0, 'ADD');
  static const Action UPDATE = Action._(1, 'UPDATE');
  static const Action REMOVE = Action._(2, 'REMOVE');

  static const $core.List<Action> values = <Action> [
    ADD,
    UPDATE,
    REMOVE,
  ];

  static final $core.Map<$core.int, Action> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Action valueOf($core.int value) => _byValue[value];

  const Action._($core.int v, $core.String n) : super(v, n);
}

