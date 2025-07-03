import 'monster.dart';

abstract class Entity {
  String name;
  int health;
  int attackPower;
  int defense;

  Entity(this.name, this.health, this.attackPower, this.defense);

  void showStatus();

  void attack(Entity target);
}

class Character extends Entity {
  Character(String name, int health, int attack, int defense)
      : super(name, health, attack, defense);

  @override
  void attack(Entity target) {
    if (target is Monster) {
      attackMonster(target as Monster);
    }
  }

  void attackMonster(Monster monster) {
    monster.health -= attackPower;
    if (monster.health < 0) monster.health = 0;
    print('$name이(가) \n ${monster.name}을 공격했습니다.');
    ('\n${monster.name}의 남은 체력: ${monster.health}');
    ('');
  }

  @override
  void showStatus() {
    print(
        '\n캐릭터 상태 - 이름: $name, 체력: $health, 공격력: $attackPower, 방어력: $defense');
  }

  void defend(int attackPower) {}
}
