import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../providers/sound_provider.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // AudioPlayer 초기화
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // 리소스 해제
    super.dispose();
  }

  Future<void> _togglePlayPause(String url) async {
    if (_isPlaying) {
      await _audioPlayer.pause(); // 재생 중이면 일시 정지
    } else {
      await _audioPlayer.play(UrlSource(url)); // 일시 정지 상태면 재생
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop(); // 재생 중지
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sound = Provider.of<SoundProvider>(context).selectedSound;

    if (sound == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Player'),
        ),
        body: const Center(
          child: Text('No sound selected.', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(sound.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Now Playing: ${sound.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _togglePlayPause(sound.fileUrl),
              child: Text(_isPlaying ? 'Pause' : 'Play'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _stopAudio();
                Navigator.pop(context); // 이전 화면으로 이동
              },
              child: const Text('Stop and Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
