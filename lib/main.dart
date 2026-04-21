import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 123, 210, 251),
        appBarTheme: AppBarThemeData(
          backgroundColor: const Color.fromARGB(255, 165, 226, 255),
        ),
        brightness: Brightness.light,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  TextEditingController hourController = TextEditingController();
  int count = 0;
  double totalHours = 0;
  String message = '';
  String currentImage = 'assets/images/lock_in.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Study Time Tracker',
          style: GoogleFonts.changaOne(
            fontSize: 25,
            color: const Color.fromARGB(255, 19, 116, 158),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

            child: Column(
              children: [
                Text(
                  count < 7 ? 'Day ${count + 1}' : 'Week completed',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  enabled: count < 7, //disabled when week completed 
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        count <
                            7 //weekly
                        ? 'Enter study hours'
                        : 'Reset to start a new week',
                  ),
                  controller: hourController,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: submit,
                      child: const Text('Submit'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        reset();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  'Total study hours: $totalHours',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  message,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 31, 165, 223),
                  ),
                ),
                Image.asset(currentImage, scale: 2.0),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() {
    setState(() {
      double hours = double.tryParse(hourController.text) ?? 0.0;
      totalHours += hours;
      count++;

      if (count == 7) {
        if (totalHours >= 15) {
          currentImage = 'assets/images/happy.jpg';
          message = 'Great job!';
          player.play(AssetSource('audios/wow.mp3'));
        } else if (totalHours >= 8) {
          currentImage = 'assets/images/study_hard.jpg';
          message = 'You can do better!';
          player.play(AssetSource('audios/i_got_this.mp3'));
        } else {
          currentImage = 'assets/images/shocked.jpg';
          message = 'You need to study more...';
          player.play(AssetSource('audios/ack.mp3'));
        }
      }
    });
    hourController.clear();
  }

  void reset() {
    setState(() {
      totalHours = 0;
      count = 0;
      currentImage = 'assets/images/lock_in.jpg';
      message = '';
    });
  }
}
