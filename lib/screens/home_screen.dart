import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_noise/models/sound.dart';
import 'package:pure_noise/providers/sound_provider.dart';

class HomeScreen extends StatelessWidget {
  final List<Sound> sounds = [
    Sound(id: '1', title: 'Rain', fileUrl: 'https://example.com/rain.mp3'),
    Sound(id: '2', title: 'Ocean Waves', fileUrl: 'https://example.com/ocean.mp3'),
    Sound(id: '3', title: 'Forest', fileUrl: 'https://example.com/forest.mp3'),
    Sound(id: '4', title: 'Wind', fileUrl: 'https://example.com/wind.mp3'),
    Sound(id: '5', title: 'Fireplace', fileUrl: 'https://example.com/fireplace.mp3'),
    Sound(id: '6', title: 'Night Ambience', fileUrl: 'https://example.com/night.mp3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('White Noise'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: sounds.length,
        itemBuilder: (context, index) {
          final sound = sounds[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.music_note, color: Colors.blue),
              title: Text(
                sound.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
              onTap: () {
                // 선택된 사운드 상태 저장 후 이동
                Provider.of<SoundProvider>(context, listen: false).selectSound(sound);
                Navigator.pushNamed(context, '/player');
              },
            ),
          );
        },
      ),
    );
  }
}
