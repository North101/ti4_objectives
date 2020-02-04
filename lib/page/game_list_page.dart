import 'package:flutter/material.dart';
import 'package:ti4_objectives/database.dart';
import 'package:ti4_objectives/page/game_page.dart';
import 'package:ti4_objectives/page/new_game_page.dart';

class GameListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = AppDb.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Twilight Imperium 4')),
      body: StreamBuilder<List<Game>>(
        stream: db.listGame().watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final item = snapshot.data[index];
              return ListTile(
                title: Text(item.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    db.deleteGame(item.id);
                  },
                ),
                onTap: () {
                  Navigator.push<void>(context, MaterialPageRoute(builder: (context) {
                    return GamePage(gameId: item.id);
                  }));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push<void>(context, MaterialPageRoute(builder: (context) {
            return NewGameStep1Page();
          }));
        },
      ),
    );
  }
}
