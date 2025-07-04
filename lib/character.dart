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
  bool usedItem = false;
  bool itemActive = false;
  int maxHealth;

  Character(String name, int health, int attack, int defense)
      : maxHealth = health,
        super(name, health, attack, defense);

  void useItem() {
    if (usedItem) {
      print('\n아이템은 이미 사용하였습니다.');
      return;
    }
    usedItem = true;
    itemActive = true;
    print('\n아이템을 사용했습니다! 이번 턴 ATK이 2배가 됩니다.');
  }

  @override
  void attack(Entity target) {
    int effectiveAttack = attackPower;
    if (itemActive) {
      effectiveAttack *= 2;
      itemActive = false; // 한 턴만 효과 지속
    }

    if (target is Monster) {
      target.health -= effectiveAttack;
      if (target.health < 0) target.health = 0;
      print('[$name]이(가) [${target.name}]을 공격했습니다. ATK: $effectiveAttack');
      print('[${target.name}]의 남은 HP: ${target.health}');
    }
  }

  void attackMonster(Monster monster) {
    monster.health -= attackPower;
    if (monster.health < 0) monster.health = 0;
    print('[$name]이(가) \n [${monster.name}]을 공격했습니다.'
        '\n[${monster.name}]의 남은 HP: ${monster.health}');
  }

  @override
  void showStatus() {
    print('\n [$name] HP: $health, ATK: $attackPower, DEP: $defense');
  }

  bool isDefending = false;

  void defend() {
    isDefending = true;
    int healAmount = 5;
    health += healAmount;

    if (health > maxHealth) {
      health = maxHealth;
    }

    print('$name이(가) 절대 방어 자세를 취했습니다! 이번 턴은 피해를 받지 않습니다.');
    print('💚 방어하면서 체력을 $healAmount 회복했습니다. 현재 체력: $health');
  }
}
