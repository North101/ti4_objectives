import 'package:grpc/grpc.dart';
import 'package:ti4_objectives/protos/game_state.pbgrpc.dart';

class Client {
  void listen() async {
    ClientChannel channel;
    try {
      channel = ClientChannel(
        '127.0.0.1',
        port: 8080,
        options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
      );
      final stub = GameStateServiceClient(channel);

      final response = await stub.requestGameState(GameStateRequest());
      response.listen((event) {
        print(event.version);
        print(event.gameObjectiveMap);
        print(event.playerObjectiveMap);
      }, onError: (dynamic error) {
        print(error);
      }, onDone: () async {
        await response.cancel();
        await channel?.shutdown();
      }, cancelOnError: true);
    } catch (e) {
      print('Caught error: $e');
      await channel?.shutdown();
    }
  }
}

void main() {
  Client().listen();
}