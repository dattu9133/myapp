
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const TimeTrackerApp());
}

class TimeTrackerApp extends StatelessWidget {
  const TimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Hour Calculator',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const TimeTrackerHomePage(),
    );
  }
}

class TimeTrackerHomePage extends StatefulWidget {
  const TimeTrackerHomePage({super.key});

  @override
  State<TimeTrackerHomePage> createState() => TimeTrackerHomePageState();
}

class TimeTrackerHomePageState extends State<TimeTrackerHomePage> with SingleTickerProviderStateMixin {
  TimeOfDay? inTime;
  final TextEditingController effectiveHoursController = TextEditingController();
  final TextEditingController effectiveMinutesController = TextEditingController();
  String totalWorkTime = '';
  String timeDifference = '';
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    effectiveHoursController.dispose();
    effectiveMinutesController.dispose();
    super.dispose();
  }

  Future<void> selectInTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: inTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != inTime) {
      setState(() {
        inTime = picked;
      });
    }
  }

  void calculateWorkHours() {
    if (inTime == null) {
      // Handle case where in-time is not set
      return;
    }

    final int effectiveHours = int.tryParse(effectiveHoursController.text) ?? 0;
    final int effectiveMinutes = int.tryParse(effectiveMinutesController.text) ?? 0;
    final Duration effectiveTime = Duration(hours: effectiveHours, minutes: effectiveMinutes);

    final now = DateTime.now();
    final inDateTime = DateTime(now.year, now.month, now.day, inTime!.hour, inTime!.minute);
    final leaveDateTime = DateTime(now.year, now.month, now.day, 18, 30);

    if (inDateTime.isAfter(leaveDateTime)) {
       setState(() {
        totalWorkTime = 'In-time must be before 6:30 PM';
        timeDifference = '';
      });
      animationController.forward(from: 0.0);
      return;
    }

    final timeAtOffice = leaveDateTime.difference(inDateTime);
    final totalWorkDuration = timeAtOffice + effectiveTime;

    final totalHours = totalWorkDuration.inHours;
    final totalMinutes = totalWorkDuration.inMinutes.remainder(60);

    final eightHours = const Duration(hours: 8);
    final difference = totalWorkDuration - eightHours;

    setState(() {
      totalWorkTime = 'Total work time by 6:30 PM: $totalHours hours and $totalMinutes minutes';
      if (difference.isNegative) {
        final remaining = eightHours - totalWorkDuration;
        timeDifference = 'You need to work ${remaining.inHours} hours and ${remaining.inMinutes.remainder(60)} more minutes to complete 8 hours.';
      } else {
        timeDifference = 'You have worked ${difference.inHours} hours and ${difference.inMinutes.remainder(60)} minutes extra.';
      }
    });

    animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Hour Calculator', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => selectInTime(context),
                        label: Text(inTime == null ? 'Select In-Time' : 'In-Time: ${inTime!.format(context)}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: effectiveHoursController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Effective Hours',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.hourglass_bottom),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: effectiveMinutesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Effective Minutes',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.hourglass_bottom),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateWorkHours,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 30),
              FadeTransition(
                opacity: animation,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Colors.deepPurple.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          totalWorkTime,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          timeDifference,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.deepPurple.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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
