import 'package:flutter/material.dart';
import '../models/booking_window_model.dart';
import '../data/mock_database.dart';
import '../services/booking_service.dart';

class DealerCreateTokenPage extends StatefulWidget {
  final String dealerId;
  final String dealerName;
  final String shopId;
  final String shopName;

  const DealerCreateTokenPage({
    Key? key,
    required this.dealerId,
    required this.dealerName,
    required this.shopId,
    required this.shopName,
  }) : super(key: key);

  @override
  _DealerCreateTokenPageState createState() => _DealerCreateTokenPageState();
}

class _DealerCreateTokenPageState extends State<DealerCreateTokenPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _maxTokensController = TextEditingController();

  String _selectedSession = 'morning';
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now().add(const Duration(days: 1)));
  }

  String _formatDate(DateTime dt) => '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  Future<void> _pickDate() async {
    var picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null) {
      _dateController.text = _formatDate(picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 9, minute: 0));
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay(hour: 12, minute: 0));
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  void _openBookingWindow() {
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select start and end times')));
      return;
    }
    if (_endTime!.hour < _startTime!.hour || (_endTime!.hour == _startTime!.hour && _endTime!.minute <= _startTime!.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('End time must be after start time')));
      return;
    }
    final maxTokens = int.tryParse(_maxTokensController.text) ?? 0;
    if (maxTokens <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid max tokens')));
      return;
    }

    final window = BookingWindow(
      id: 'window_${DateTime.now().millisecondsSinceEpoch}',
      dealerId: widget.dealerId,
      shopId: widget.shopId,
      date: _parseDate(_dateController.text),
      session: _selectedSession,
      startTime: _startTime!,
      endTime: _endTime!,
      maxTokens: maxTokens,
      tokensBooked: 0,
      isActive: true,
      createdAt: DateTime.now(),
    );

    setState(() {
      mockBookingWindows.add(window);
    });

    BookingService.notifyUsers(window);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking window opened! Users notified.')));

    _startTime = null;
    _endTime = null;
    _maxTokensController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Booking Window')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Date (dd/mm/yyyy)'),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: _selectedSession,
              items: ['morning', 'evening'].map((session) {
                return DropdownMenuItem(value: session, child: Text(session.toUpperCase()));
              }).toList(),
              onChanged: (val) => setState(() => _selectedSession = val!),
              decoration: const InputDecoration(labelText: 'Session'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(_startTime == null ? 'Select Start Time' : 'Start: ${_startTime!.format(context)}'),
                    trailing: const Icon(Icons.access_time),
                    tileColor: Colors.grey[200],
                    onTap: _pickStartTime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ListTile(
                    title: Text(_endTime == null ? 'Select End Time' : 'End: ${_endTime!.format(context)}'),
                    trailing: const Icon(Icons.access_time),
                    tileColor: Colors.grey[200],
                    onTap: _pickEndTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _maxTokensController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Max Tokens'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openBookingWindow,
              child: const Text('Open Booking Window'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}