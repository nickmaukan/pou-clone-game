// lib/presentation/providers/navigation_provider.dart
import 'package:flutter/material.dart';
import '../../core/enums/room_type.dart';

class NavigationProvider extends ChangeNotifier {
  RoomType _currentRoom = RoomType.livingRoom;

  RoomType get currentRoom => _currentRoom;

  String get roomName {
    switch (_currentRoom) {
      case RoomType.livingRoom:
        return '🏠 Living Room';
      case RoomType.kitchen:
        return '🍳 Kitchen';
      case RoomType.bathroom:
        return '🛁 Bathroom';
      case RoomType.lab:
        return '🧪 Laboratory';
      case RoomType.gameRoom:
        return '🎮 Game Room';
      case RoomType.closet:
        return '👗 Closet';
      case RoomType.shop:
        return '🛒 Shop';
    }
  }

  void setRoom(RoomType room) {
    if (_currentRoom != room) {
      _currentRoom = room;
      notifyListeners();
    }
  }
}