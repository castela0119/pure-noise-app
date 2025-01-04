import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sound.dart';
import '../providers/sound_provider.dart';
import './time_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Sound> sounds = [
    Sound(id: '1', title: 'Rain', fileUrl: 'https://example.com/rain.mp3'),
    Sound(id: '2', title: 'Ocean Waves', fileUrl: 'https://example.com/ocean.mp3'),
    Sound(id: '3', title: 'Forest', fileUrl: 'https://example.com/forest.mp3'),
    Sound(id: '4', title: 'Wind', fileUrl: 'https://example.com/wind.mp3'),
    Sound(id: '5', title: 'Fireplace', fileUrl: 'https://example.com/fireplace.mp3'),
    Sound(id: '6', title: 'Night Ambience', fileUrl: 'https://example.com/night.mp3'),
  ];

  Timer? _countdownTimer;
  Duration _remainingDuration = Duration.zero;

  void _startTimer() {
    if (_countdownTimer != null) {
      _countdownTimer?.cancel();
    }

    if (_remainingDuration > Duration.zero) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingDuration > const Duration(seconds: 1)) {
          setState(() {
            _remainingDuration -= const Duration(seconds: 1);
          });
        } else {
          timer.cancel();
          _stopPlayback();
        }
      });
    }
  }

  void _stopPlayback() {
    Provider.of<SoundProvider>(context, listen: false).pauseSound();
    setState(() {
      _remainingDuration = Duration.zero;
    });
  }

  void _updateTimer(Duration duration) {
    setState(() {
      _remainingDuration = duration;
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context);
    final selectedSound = soundProvider.selectedSound;
    final isPlaying = soundProvider.isPlaying;

    return Scaffold(
      appBar: AppBar(
        title: const Text('백색소음 플레이어'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: sounds.length,
        itemBuilder: (context, index) {
          final sound = sounds[index];
          final isSelected = selectedSound == sound;
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.music_note, color: Colors.blue),
              title: Text(
                sound.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: Icon(
                isSelected && isPlaying ? Icons.pause : Icons.play_arrow,
                color: isSelected ? Colors.green : Colors.grey,
              ),
              onTap: () {
                if (isSelected && isPlaying) {
                  soundProvider.pauseSound();
                  _countdownTimer?.cancel();
                  print('Paused sound: ${sound.title}');
                } else {
                  soundProvider.selectSound(sound);
                  soundProvider.playSound();
                  if (_remainingDuration > Duration.zero) {
                    _startTimer();
                  }
                  print('Playing sound: ${sound.title}');
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                if (selectedSound == null) {
                  final firstSound = sounds.first;
                  soundProvider.selectSound(firstSound);
                  soundProvider.playSound();
                  if (_remainingDuration > Duration.zero) {
                    _startTimer();
                  }
                  print('Playing first sound: ${firstSound.title}');
                } else {
                  if (isPlaying) {
                    soundProvider.pauseSound();
                    _countdownTimer?.cancel();
                    print('Paused sound: ${selectedSound?.title}');
                  } else {
                    soundProvider.playSound();
                    if (_remainingDuration > Duration.zero) {
                      _startTimer();
                    }
                    print('Playing sound: ${selectedSound?.title}');
                  }
                }
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.timer, color: Colors.white),
              label: Text(
                _remainingDuration > Duration.zero
                    ? "${_remainingDuration.inHours}시간 ${_remainingDuration.inMinutes % 60}분 ${_remainingDuration.inSeconds % 60}초"
                    : "타이머",
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerScreen(
                      initialDuration: _remainingDuration,
                      onDurationSelected: (duration) {
                        _updateTimer(duration);
                        print('Timer set for: ${duration.inHours}시간 ${duration.inMinutes % 60}분');
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
