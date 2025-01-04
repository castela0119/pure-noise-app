import 'package:flutter/material.dart';
import '../models/sound.dart';

class SoundProvider with ChangeNotifier {
  Sound? _selectedSound; // 현재 선택된 사운드
  bool _isPlaying = false; // 재생 상태
  Duration _playDuration = const Duration(hours: 0); // 재생 시간

  Sound? get selectedSound => _selectedSound;
  bool get isPlaying => _isPlaying;
  Duration get playDuration => _playDuration;

  // 사운드 선택
  void selectSound(Sound? sound) {
    if (sound == null && _selectedSound == null) {
      // 선택된 Sound가 없을 경우 기본값 설정 (id: 1)
      _selectedSound = Sound(id: '1', title: 'Rain', fileUrl: 'https://example.com/rain.mp3');
    } else if (_selectedSound == sound && _isPlaying) {
      return; // 이미 선택된 Sound가 재생 중이면 아무 작업도 하지 않음
    } else {
      _selectedSound = sound;
    }
    _isPlaying = true;
    notifyListeners();
  }

  // 사운드 재생
  void playSound() {
    if (_selectedSound != null) {
      _isPlaying = true;
      notifyListeners();
    }
  }

  // 사운드 일시정지
  void pauseSound() {
    _isPlaying = false;
    notifyListeners();
  }

  // 재생 시간 설정
  void setPlayDuration(Duration duration) {
    _playDuration = duration;
    notifyListeners();
  }

  // 재생 시간 초기화
  void clearPlayDuration() {
    _playDuration = const Duration(hours: 0);
    notifyListeners();
  }

  // 사운드 초기화 (선택 해제)
  void clearSelectedSound() {
    _selectedSound = null;
    _isPlaying = false;
    clearPlayDuration();
    notifyListeners();
  }
}
