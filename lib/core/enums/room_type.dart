// lib/core/enums/room_type.dart
enum RoomType {
  livingRoom,
  kitchen,
  bathroom,
  lab,
  gameRoom,
  closet,
  shop,
}

extension RoomTypeExtension on RoomType {
  String get name {
    switch (this) {
      case RoomType.livingRoom:
        return 'Living Room';
      case RoomType.kitchen:
        return 'Kitchen';
      case RoomType.bathroom:
        return 'Bathroom';
      case RoomType.lab:
        return 'Lab';
      case RoomType.gameRoom:
        return 'Game Room';
      case RoomType.closet:
        return 'Closet';
      case RoomType.shop:
        return 'Shop';
    }
  }
  
  String get emoji {
    switch (this) {
      case RoomType.livingRoom:
        return '🏠';
      case RoomType.kitchen:
        return '🍳';
      case RoomType.bathroom:
        return '🛁';
      case RoomType.lab:
        return '🧪';
      case RoomType.gameRoom:
        return '🎮';
      case RoomType.closet:
        return '👗';
      case RoomType.shop:
        return '🛒';
    }
  }
  
  String get route {
    switch (this) {
      case RoomType.livingRoom:
        return '/living-room';
      case RoomType.kitchen:
        return '/kitchen';
      case RoomType.bathroom:
        return '/bathroom';
      case RoomType.lab:
        return '/lab';
      case RoomType.gameRoom:
        return '/game-room';
      case RoomType.closet:
        return '/closet';
      case RoomType.shop:
        return '/shop';
    }
  }
}
