import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'profile_page.dart'; // Import the ProfilePage

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  final CountDownController _controller = CountDownController();
  final TextEditingController _workDurationController = TextEditingController(text: '25');
  final TextEditingController _breakDurationController = TextEditingController(text: '5');
  bool _isRunning = false;
  bool _isWorkPeriod = true;
  int _workDuration = 1500; // 25 minutes
  int _breakDuration = 300; // 5 minutes

  void _startTimer() {
    setState(() {
      _workDuration = int.parse(_workDurationController.text) * 60;
      _breakDuration = int.parse(_breakDurationController.text) * 60;
      _isWorkPeriod = true;
      _isRunning = true;
    });
    _controller.restart(duration: _workDuration);
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    _controller.pause();
    _controller.restart(duration: _workDuration); // Reset to initial duration
  }

  void _toggleTimer() {
    if (_isRunning) {
      _controller.pause();
      setState(() {
        _isRunning = false;
      });
    } else {
      _controller.resume();
      setState(() {
        _isRunning = true;
      });
    }
  }

  void _onComplete() {
    setState(() {
      _isWorkPeriod = !_isWorkPeriod;
      _isRunning = false;
    });
    _controller.restart(duration: _isWorkPeriod ? _workDuration : _breakDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to ProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularCountDownTimer(
                duration: _isWorkPeriod ? _workDuration : _breakDuration,
                initialDuration: 0,
                controller: _controller,
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                ringColor: const Color.fromARGB(255, 50, 49, 46),
                fillColor: Colors.amber,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                strokeWidth: 20.0,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(
                  fontSize: 33.0,
                  color: Colors.white,  // Changed to white
                  fontWeight: FontWeight.bold,
                ),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: false,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: false,
                onStart: () {
                  setState(() {
                    _isRunning = true;
                  });
                },
                onComplete: _onComplete,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _workDurationController,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Work (min)',
                          labelStyle: TextStyle(color: Colors.black), // Label text color
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: _breakDurationController,
                        style: const TextStyle(color: Colors.black), 
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Break (min)',
                          labelStyle: TextStyle(color: Colors.black),  // Label text color
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Start Timer',
                  style: TextStyle(
                    color: Colors.black,  // Button text color
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _stopTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Different color for Stop button
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Stop Timer',
                  style: TextStyle(
                    color: Colors.white,  // Button text color
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _isRunning ? 'Pause' : 'Resume',
                  style: const TextStyle(
                    color: Colors.black,  // Button text color
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
