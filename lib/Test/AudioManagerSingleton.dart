import 'package:audio_manager/audio_manager.dart';

class AudioManagerSingleton {
  static final AudioManagerSingleton _singleton = AudioManagerSingleton._internal();
  AudioManager _audioManager;

  factory AudioManagerSingleton() {
    return _singleton;
  }

  AudioManagerSingleton._internal() {
    // Initialize AudioManager instance
    _audioManager = AudioManager.instance;
    // Setup audio list
    List<AudioInfo> audioList = [
      AudioInfo(
        'https://example.com/audio1.mp3',
        title: 'Audio 1',
        desc: 'Artist 1',
        coverUrl: 'https://example.com/audio1_cover.jpg',
      ),
      AudioInfo(
        'https://example.com/audio2.mp3',
        title: 'Audio 2',
        desc: 'Artist 2',
        coverUrl: 'https://example.com/audio2_cover.jpg',
      ),
      AudioInfo(
        'https://example.com/audio3.mp3',
        title: 'Audio 3',
        desc: 'Artist 3',
        coverUrl: 'https://example.com/audio3_cover.jpg',
      ),
    ];
    _audioManager.audioList = audioList;
    // Set intercepter to true to control audio playback
    _audioManager.intercepter = true;
  }

  AudioManager get audioManager => _audioManager;
}
