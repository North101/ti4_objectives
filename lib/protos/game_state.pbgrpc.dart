///
//  Generated code. Do not modify.
//  source: protos/game_state.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'game_state.pb.dart' as $0;
export 'game_state.pb.dart';

class GameStateServiceClient extends $grpc.Client {
  static final _$requestGameState =
      $grpc.ClientMethod<$0.GameStateRequest, $0.GameStateResponse>(
          '/GameStateService/RequestGameState',
          ($0.GameStateRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GameStateResponse.fromBuffer(value));

  GameStateServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseStream<$0.GameStateResponse> requestGameState(
      $0.GameStateRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$requestGameState, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseStream(call);
  }
}

abstract class GameStateServiceBase extends $grpc.Service {
  $core.String get $name => 'GameStateService';

  GameStateServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GameStateRequest, $0.GameStateResponse>(
        'RequestGameState',
        requestGameState_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.GameStateRequest.fromBuffer(value),
        ($0.GameStateResponse value) => value.writeToBuffer()));
  }

  $async.Stream<$0.GameStateResponse> requestGameState_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GameStateRequest> request) async* {
    yield* requestGameState(call, await request);
  }

  $async.Stream<$0.GameStateResponse> requestGameState(
      $grpc.ServiceCall call, $0.GameStateRequest request);
}
