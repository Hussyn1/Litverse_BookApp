import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

class AudioBookReader extends StatefulWidget {
  final String bookTitle;
  final String textAssetPath;

  const AudioBookReader({
    super.key,
    required this.bookTitle,
    required this.textAssetPath,
  });

  @override
  State<AudioBookReader> createState() => _AudioBookReaderState();
}

class _AudioBookReaderState extends State<AudioBookReader> {
  late FlutterTts _flutterTts;

  String _bookText = "";
  bool _isLoading = true;
  bool _isPlaying = false;
  String _errorMessage = "";

  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _loadBookText();
  }

  Future<void> _initializeTTS() async {
    _flutterTts = FlutterTts();

    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);

    _flutterTts.setStartHandler(() {
      setState(() => _isPlaying = true);
    });

    _flutterTts.setCompletionHandler(() {
      setState(() => _isPlaying = false);
    });

    _flutterTts.setErrorHandler((message) {
      setState(() {
        _isPlaying = false;
        _errorMessage = message;
      });
    });
  }

  Future<void> _loadBookText() async {
    try {
      final text = await rootBundle.loadString(widget.textAssetPath);
      setState(() {
        _bookText = text;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load book: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _flutterTts.stop();
    } else {
      await _flutterTts.setSpeechRate(_playbackSpeed);
      await _flutterTts.speak(_bookText);
    }
  }

  void _changePlaybackSpeed() {
    setState(() {
      switch (_playbackSpeed) {
        case 1.0:
          _playbackSpeed = 1.25;
          break;
        case 1.25:
          _playbackSpeed = 1.5;
          break;
        case 1.5:
          _playbackSpeed = 2.0;
          break;
        default:
          _playbackSpeed = 1.0;
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookTitle),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Loading book..."),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBookText,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              _bookText,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ),
        _buildAudioControls(),
      ],
    );
  }

  Widget _buildAudioControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.deepOrange,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
            ),
            onPressed: _changePlaybackSpeed,
            child: Text("${_playbackSpeed}x"),
          ),
          IconButton(
            iconSize: 48,
            icon: Icon(
              _isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: Colors.white,
            ),
            onPressed: _togglePlayPause,
          ),
        ],
      ),
    );
  }
} 
