import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart';

class GameObjectiveWidget extends StatelessWidget {
  final ObjectiveWithType objective;
  final double height;
  final double width;
  final void Function() onTap;

  const GameObjectiveWidget({Key key, this.objective, this.height, this.width, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        child: objective.objectiveImage == null
            ? Image.asset(
                'assets/${objective.objectiveTypeImage}',
                key: ValueKey(objective.objectiveTypeImage),
                height: height,
                width: width,
              )
            : Image.asset(
                'assets/${objective.objectiveImage}',
                key: ValueKey(objective.objectiveImage),
                height: height,
                width: width,
              ),
      ),
      onTap: onTap,
    );
  }
}
