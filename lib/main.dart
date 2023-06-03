import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _dropdownvalue = 0;
  late ByteData _byteGuitar;
  late ByteData _byteFlute;
  late ByteData _bytePaino;
  @override
  void initState() {
    // _byteGuitar = load('assets/Best_of_Guitars_4U_v1.0.sf2');
    // _byteFlute = load('assets/Expressive_Flute_SSO_v1.2.sf2');
    load('assets/Yamaha-Grand-Lite-SF-v1.1.sf2');
    super.initState();
  }

  void load(String asset) async {
    FlutterMidi().unmute(); // Optionally Unmute
    // _byteGuitar = await rootBundle.load('assets/Best_of_Guitars_4U_v1.0.sf2');
    // _byteFlute = await rootBundle.load('assets/Expressive_Flute_SSO_v1.2.sf2');
    ByteData _bytePaino = await rootBundle.load(asset);
    FlutterMidi().prepare(sf2: _bytePaino);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Piano Demo',
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text('Multi Instruments'),
            leading: Icon(Icons.phone),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<int>(
                  dropdownColor: Colors.red,
                  focusColor: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(10),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  items: const [
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Text(
                        'Piano',
                        // style: TextStyle(color: Colors.black),
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text(
                        'Gitar',
                        // style: TextStyle(color: Colors.black),
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text(
                        'Flute',
                        // style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                  onChanged: dropdownCallback,
                  value: _dropdownvalue,
                  icon: Icon(Icons.queue_music_outlined),
                  iconEnabledColor: Colors.white,
                ),
              )
            ],
          ),
          body: Center(
            child: InteractivePiano(
              highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
              naturalColor: Colors.white,
              accidentalColor: Colors.black,
              keyWidth: 60,
              noteRange: NoteRange.forClefs([
                Clef.Treble,
              ]),
              onNotePositionTapped: (position) {
                FlutterMidi().playMidiNote(midi: position.pitch);
              },
            ),
          ),
        ));
  }

  dropdownCallback(int? selectedValue) async {
    if (selectedValue is int) {
      setState(() {
        _dropdownvalue = selectedValue;
      });
    }
    if (selectedValue == 0) {
      FlutterMidi().changeSound(sf2: _bytePaino);
    } else if (selectedValue == 1) {
      FlutterMidi().changeSound(
          sf2: await rootBundle.load('assets/Best_of_Guitars_4U_v1.0.sf2'));
    } else if (selectedValue == 2) {
      FlutterMidi().changeSound(
          sf2: await rootBundle.load('assets/Expressive_Flute_SSO_v1.2.sf2'));
    }
  }
}
