import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  final Duration initialDuration;
  final Function(Duration) onDurationSelected;

  const TimerScreen({
    Key? key,
    required this.initialDuration,
    required this.onDurationSelected,
  }) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Duration _selectedDuration;

  @override
  void initState() {
    super.initState();
    // 초기화: initialDuration 값을 _selectedDuration에 동기화
    _selectedDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    int hours = _selectedDuration.inHours.clamp(0, 12); // 0~12로 제한
    int minutes = (_selectedDuration.inMinutes % 60).clamp(0, 55);
    if (minutes % 5 != 0) {
      minutes -= minutes % 5; // 5분 단위로 맞춤
    }
    _selectedDuration = Duration(hours: hours, minutes: minutes);

    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '재생 시간 설정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<int>(
                  value: _selectedDuration.inHours,
                  items: List.generate(13, (index) => index)
                      .map((hour) => DropdownMenuItem(
                    value: hour,
                    child: Text('$hour시간'),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedDuration = Duration(
                          hours: value,
                          minutes: _selectedDuration.inMinutes % 60,
                        );
                      });
                    }
                  },
                ),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: _selectedDuration.inMinutes % 60,
                  items: List.generate(12, (index) => index * 5)
                      .map((minute) => DropdownMenuItem(
                    value: minute,
                    child: Text('$minute분'),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedDuration = Duration(
                          hours: _selectedDuration.inHours,
                          minutes: value,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onDurationSelected(_selectedDuration);
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
