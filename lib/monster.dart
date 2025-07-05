import 'dart:math'; // 난수 생성용 라이브러리
import 'character.dart'; // Character 클래스 참조를 위해 import
import 'dart:io'; // 파일 읽기용 라이브러리

class Monster extends Entity {
  // 몬스터 클래스: Entity를 상속받아 몬스터 고유 기능 추가
  int maxAttackPower; // 최대 공격력
  String introMessage; // 몬스터가 소개 멘트
  int turnCounter = 0; // 턴 수 세기용 카운터

  String? asciiArt; // 도트 이미지 텍스트 저장용 변수

  Monster(String name, int health, this.maxAttackPower,
      this.introMessage) // 생성자: 이름, 체력, 최대 공격력, 소개 멘트 입력받음
      : super(name, health, 0, 0) {
    // Entity 생성자 호출, 공격력/방어력 0으로 초기화
    attackPower = maxAttackPower; // 초기 공격력은 최대 공격력과 동일
    defense = 0; // 방어력은 0으로 초기화
    loadAsciiArt(); // 도트 이미지 파일 불러오기 시도
  }

  void loadAsciiArt() {
    // 도트 이미지 텍스트 파일 읽기 함수
    try {
      final path = 'data/monster_art/$name.txt'; // 파일 경로는 이름 기준
      asciiArt = File(path).readAsStringSync(); // 도트 텍스트 파일 읽기
    } catch (e) {
      asciiArt = '[도트 이미지 없음]'; // 에러 발생 시 기본 메시지
    }
  }

  void showAsciiArt() {
    // 불러온 도트 이미지 출력 함수
    if (asciiArt != null) {
      print(asciiArt); // null이 아니면 출력
    }
  }

  void increaseDefenseIfNeeded() {
    // 매 3턴마다 방어력 2 증가시키는 함수
    turnCounter++; // 턴 수 증가
    if (turnCounter >= 3) {
      // 3턴 도달 시
      defense += 2; // 방어력 증가
      turnCounter = 0; // 카운터 초기화
      print('$name의 DEP이 증가했습니다! 현재 DEP: $defense');
    }
  }

  void assignAttackPower(int characterDefense) {
    // 캐릭터 방어력을 기준으로 공격력 재설정 (랜덤)
    int minAttack = characterDefense;
    int maxAttack = maxAttackPower;
    var rand = Random();
    attackPower =
        (maxAttack <= minAttack) // 최대 공격력이 최소 공격력 이하면 최소 공격력 고정, 아니면 랜덤 범위 내 할당
            ? minAttack
            : minAttack + rand.nextInt(maxAttack - minAttack + 1);
  }

  void attackCharacter(Character character) {
    // 캐릭터를 공격하는 함수
    if (character.isDefending) {
      // 캐릭터가 방어 중이면
      print('\n${character.name}이(가) 절대 방어로 공격을 무효화했습니다!');
      character.isDefending = false; // 방어 상태 해제
      return; // 공격 무효화
    }
    int damage = attackPower - character.defense; // 데미지 계산
    if (damage < 0) damage = 0; // 데미지가 음수면 0으로 수정
    character.health -= damage; // 캐릭터 체력 감소
    if (character.health < 0) character.health = 0; // 체력 음수 방지
    print('\n[$name]이(가) ${character.name}을(를) 공격했습니다. DMG: $damage'
        '\n남은 HP: ${character.health}');
  }

  @override // Entity 클래스의 attack 메서드 오버라이드
  void attack(Entity target) {
    if (target is Character) {
      attackCharacter(target); // 대상이 캐릭터면 공격 함수 호출
    }
  }

  @override // 몬스터 상태 출력 함수 오버라이드
  void showStatus() {
    print('\n[$name] HP: $health, ATK: $attackPower, DEF: $defense\n');
  }

  void sayIntro() {
    // 몬스터가 전투 시작 시 말하는 인사말 출력 함수
    print('$name: "$introMessage"');
  }
}
