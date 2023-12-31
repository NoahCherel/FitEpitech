import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Profile/profile.dart';
import '../UI/homepage.dart';

class CalendarScreen extends StatefulWidget {
  static const routeName = '/calendar';

  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class Event {
  final DateTime date;
  final int durationInMinutes;
  final String workoutActivity;
  final int caloriesBurned;

  Event({
    required this.date,
    required this.durationInMinutes,
    required this.workoutActivity,
    required this.caloriesBurned,
  });
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  int _selectedIndex = 1;
  List<Event> _events = [];

  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _workoutActivityController = TextEditingController();
  final TextEditingController _caloriesBurnedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTableCalendar(),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                if (isSameDay(event.date, _selectedDay)) {
                  return GestureDetector(
                    onTap: () {
                      _removeEvent(index);
                    },
                    child: ListTile(
                      title: Text(event.workoutActivity),
                      subtitle: Text('${event.durationInMinutes} minutes'),
                      trailing: Text('${event.caloriesBurned} calories'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _addButton(),
            ),
          ),
          // Only show the activities on the selected day
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigate to the selected page
          if (_selectedIndex == 0) {
            Navigator.pushNamed(context, MainScreen.routeName);
          } else if (_selectedIndex == 1) {
            Navigator.pushNamed(context, CalendarScreen.routeName);
          } else if (_selectedIndex == 2) {
            Navigator.pushNamed(context, ProfileScreen.routeName);
          }
        },

      ),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey[200],
      title: Center(child: Text('Calendar', style: TextStyle(fontSize: 24.0, color: Colors.black))),
        automaticallyImplyLeading: false,
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2021, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: (day) {
        return _events
            .where((event) => isSameDay(event.date, day))
            .map((event) => event.workoutActivity)
            .toList();
      },
      calendarStyle: const CalendarStyle(
        todayTextStyle: TextStyle(color: Colors.white),
        selectedTextStyle: TextStyle(color: Colors.white),
        weekendTextStyle: TextStyle(color: Colors.red),
        todayDecoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.rectangle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final event in events)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAddEventForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add an Event',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 8.0),
          TextFormField(
            controller: _workoutActivityController,
            decoration: const InputDecoration(labelText: 'Workout Activity'),
          ),
          SizedBox(height: 8.0),
          TextFormField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Event Duration (minutes)'),
          ),
          SizedBox(height: 8.0),
          TextFormField(
            controller: _caloriesBurnedController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Calories Burned'),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: _addEvent,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              textStyle: TextStyle(fontSize: 18.0),
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _addButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _buildAddEventForm(),
        );
      },
      child: Icon(Icons.add),
    );
  }

  void _addEvent() {
    final duration = int.tryParse(_durationController.text) ?? 0;
    final workoutActivity = _workoutActivityController.text;
    final caloriesBurned = int.tryParse(_caloriesBurnedController.text) ?? 0;

    if (duration > 0 && workoutActivity.isNotEmpty && caloriesBurned > 0) {
      final newEvent = Event(
        date: _selectedDay,
        durationInMinutes: duration,
        workoutActivity: workoutActivity,
        caloriesBurned: caloriesBurned,
      );
      setState(() {
        _events.add(newEvent);
        _durationController.clear();
        _workoutActivityController.clear();
        _caloriesBurnedController.clear();
      });
      Navigator.pop(context);
    }
  }

  void _removeEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
  }
}
