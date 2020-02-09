import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart';

class PlayerScore extends StatelessWidget {
  final ListPlayerScoreByGameIdResult player;
  final void Function() onTap;

  const PlayerScore({Key key, this.player, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Padding(
              key: ValueKey('${player.id}'),
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/${player.raceImage}',
                  height: 32, width: 32, fit: BoxFit.contain, gaplessPlayback: true),
            ),
          ),
          ConstrainedBox(
            key: ValueKey('${player.score}'),
            constraints: const BoxConstraints(minWidth: 32),
            child: Text('${player.score}', style: Theme.of(context).textTheme.headline4),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
