// lib/core/enums/pet_state.dart
enum PetState { normal, sick, fainted, sleeping, eating }

enum PouAnimation {
  idle,
  happy,
  sad,
  eating,
  bathing,
  sleeping,
  drinking,
  playing,
}

enum PouExpression {
  neutral,
  happy,
  sad,
  surprised,
  tired,
  hungry,
  dirty,
  sick,  // NEW for sick state
}

enum EvolutionLevel {
  baby,
  child,
  adult,
  royal,
  alien,
}

extension PouAnimationExtension on PouAnimation {
  String get assetName {
    switch (this) {
      case PouAnimation.idle:
        return 'pou_idle';
      case PouAnimation.happy:
        return 'pou_happy';
      case PouAnimation.sad:
        return 'pou_sad';
      case PouAnimation.eating:
        return 'pou_eating';
      case PouAnimation.bathing:
        return 'pou_bathing';
      case PouAnimation.sleeping:
        return 'pou_sleeping';
      case PouAnimation.drinking:
        return 'pou_drinking';
      case PouAnimation.playing:
        return 'pou_playing';
    }
  }
}
