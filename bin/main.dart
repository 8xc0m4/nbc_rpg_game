import 'dart:async';
import 'dart:io';
import '../lib/character.dart';
import '../lib/game.dart';
import '../lib/monster.dart';
import '../lib/game_util.dart';

Future<void> main() async {
  print('\n================================================================'
      '\n=========================NBC RPG ONLINE========================='
      '\n================================================================');
  String name = inputCharacterName()!;

  List<int>? charStats = await loadCharacterStats();
  if (charStats == null) {
    print('캐릭터 데이터를 불러오지 못해 게임을 시작할 수 없습니다.');
    exit(1);
  }

  Character character =
      Character(name, charStats[0], charStats[1], charStats[2]);

  List<List<String>>? monsterData = await loadMonsterStats();

  if (monsterData == null || monsterData.isEmpty) {
    print('몬스터 데이터를 불러오지 못해 게임을 시작할 수 없습니다.');
    exit(1);
  }

  List<Monster> monsters = monsterData.map((data) {
    String mName = data[0];
    int health = int.tryParse(data[1]) ?? 10;
    int maxAttack = int.tryParse(data[2]) ?? 5;
    String introMessage = data.length >= 4 ? data[3] : '...';
    return Monster(mName, health, maxAttack, introMessage);
  }).toList();

  Game game = Game(character, monsters);
  game.startGame();
}
