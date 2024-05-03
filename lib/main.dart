import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: AudioButton()),
      ),
    );
  }
}

class AudioButton extends StatefulWidget {
  const AudioButton({super.key});

  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
  late AudioPlayer player;
  late AudioPlayer secondPlayer;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    // If in low latency, the completion event is not fired.
    // Android only
    player.setPlayerMode(PlayerMode.lowLatency);
    secondPlayer = AudioPlayer();

    player.onPlayerComplete.listen((event) async {
      debugPrint("Player completed");
      await secondPlayer.stop();
      await secondPlayer.resume();
    });
  }

  @override
  void dispose() {
    player.dispose();
    secondPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        player.setReleaseMode(ReleaseMode.stop),
        player.setSource(AssetSource("c3.mp3")),
        secondPlayer.setSource(AssetSource("d3.mp3")),
        secondPlayer.setReleaseMode(ReleaseMode.stop),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ElevatedButton(
            onPressed: () async {
              await player.stop();
              await player.resume();
            },
            child: const Text("Play"),
          );
        }
        return const Text("loading");
      },
    );
  }
}
