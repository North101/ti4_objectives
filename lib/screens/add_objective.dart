import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart' hide Player;

class AddObjectiveResult {
  final String objectiveTypeId;
  final String objectiveId;

  AddObjectiveResult(this.objectiveTypeId, this.objectiveId);
}

class AddObjectiveDialog extends StatefulWidget {
  final bool showHidden;
  final bool Function(ObjectiveType objectiveType) filterObjectiveType;
  final bool Function(Objective objective) filterObjective;

  const AddObjectiveDialog({
    Key key,
    this.filterObjectiveType,
    this.filterObjective,
    this.showHidden = true,
  }) : super(key: key);

  @override
  _AddObjectiveDialogState createState() => _AddObjectiveDialogState();
}

class _AddObjectiveDialogState extends State<AddObjectiveDialog> {
  ObjectiveType _selectedObjectiveType;
  Objective _selectedObjective;

  bool Function(ObjectiveType objectiveType) get filterObjectiveType {
    return widget.filterObjectiveType ?? (t) => true;
  }

  bool Function(Objective objective) get filterObjective {
    return widget.filterObjective ?? (t) => true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Objective'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StreamBuilder<List<ObjectiveType>>(
            stream: AppDb.of(context).listObjectiveType().watch(),
            builder: (context, snapshot) {
              return DropdownButton<ObjectiveType>(
                hint: Text('Objective Type'),
                isExpanded: true,
                value: _selectedObjectiveType,
                items: snapshot?.data?.where(filterObjectiveType)?.map((objectiveType) {
                      return DropdownMenuItem(
                        value: objectiveType,
                        child: Text(objectiveType.name),
                      );
                    })?.toList() ??
                    [],
                onChanged: (value) {
                  setState(() {
                    _selectedObjectiveType = value;
                    _selectedObjective = null;
                  });
                },
              );
            },
          ),
          StreamBuilder<List<Objective>>(
              stream: AppDb.of(context).listObjectiveByObjectiveTypeId(_selectedObjectiveType?.id).watch(),
              builder: (context, snapshot) {
                return DropdownButton<Objective>(
                  hint: Text('Objective'),
                  isExpanded: true,
                  value: _selectedObjective,
                  items: [
                    if (widget.showHidden && _selectedObjectiveType != null)
                      DropdownMenuItem<Objective>(
                        value: null,
                        child: Text('Random (Hidden)'),
                      ),
                    ...(snapshot?.data?.where(filterObjective)?.map((objective) {
                          return DropdownMenuItem<Objective>(
                            value: objective,
                            child: Text(objective.name),
                          );
                        }) ??
                        []),
                  ],
                  onChanged: (Objective value) {
                    setState(() {
                      _selectedObjective = value;
                    });
                  },
                );
              }),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop<AddObjectiveResult>(
              context,
              AddObjectiveResult(
                _selectedObjectiveType.id,
                _selectedObjective?.id,
              ),
            );
          },
        ),
      ],
    );
  }
}
