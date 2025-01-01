import 'package:flutter/material.dart';
import '../models/sound.dart';

class SoundProvider with ChangeNotifier {
  Sound? _selectedSound;  // 현재 선택된 사운드

  Sound? get selectedSound => _selectedSound;

  // 사운드 선택
  void selectSound(Sound sound) {
    _selectedSound = sound;
    notifyListeners();
  }

  // 사운드 초기화 (선택 해제)
  void clearSelectedSound() {
    _selectedSound = null;
    notifyListeners();
  }
}
