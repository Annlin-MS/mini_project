import 'package:flutter/material.dart';
import '../models/ration_card.dart';
import '../data/mock_database.dart';
import '../services/token_service.dart';
import '../models/booking_window_model.dart';
import '../services/booking_service.dart';

class UserTimeSlotBooking extends StatefulWidget {
  final RationCard rationCard;

  const UserTimeSlotBooking({Key? key, required this.rationCard}) : super(key: key);

  @override
  _UserTimeSlotBookingState createState() => _UserTimeSlotBookingState();
}

class _UserTimeSlotBookingState extends State<UserTimeSlotBooking> {
  List<BookingWindow> _availableWindows = [];
  BookingWindow? _selectedWindow;

  @override
  void initState() {
    super.initState();
    _loadAvailableWindows();
  }

  void _loadAvailableWindows() {
    setState(() {
      _availableWindows = mockBookingWindows.where((window) =>
      window.shopId == widget.rationCard.shopId &&
          window.isActive &&
          !window.isFull &&
          window.date.isAfter(DateTime.now().subtract(Duration(days: 1)))
      ).toList();
    });
  }

  void _bookToken(BookingWindow window) {
    final token = BookingService.bookTokenInWindow(
      bookingWindowId: window.id,
      userId: 'user_${widget.rationCard.cardNumber}',
      userName: widget.rationCard.headOfFamily,
      rationCardNo: widget.rationCard.cardNumber,
      shopId: widget.rationCard.shopId,
      items: _getDefaultEntitlements(widget.rationCard.cardType),
    );

    if (token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token ${token.tokenNumber} booked successfully!'), backgroundColor: Colors.green),
      );
      setState(() {
        _loadAvailableWindows();
        _selectedWindow = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Slot is full. Please choose another.'), backgroundColor: Colors.red),
      );
    }
  }

  List<Map<String, dynamic>> _getDefaultEntitlements(String cardType) {
    switch (cardType) {
      case 'AAY': return [{'name': 'Rice', 'price': '₹3/kg', 'quantity': '35 kg'}, {'name': 'Wheat', 'price': '₹2/kg', 'quantity': '15 kg'}];
      case 'PHH': return [{'name': 'Rice', 'price': '₹3/kg', 'quantity': '20 kg'}, {'name': 'Wheat', 'price': '₹2/kg', 'quantity': '10 kg'}];
      case 'BPL': return [{'name': 'Rice', 'price': '₹3/kg', 'quantity': '25 kg'}, {'name': 'Wheat', 'price': '₹2/kg', 'quantity': '12 kg'}];
      default: return [{'name': 'Rice', 'price': '₹3/kg', 'quantity': '15 kg'}, {'name': 'Wheat', 'price': '₹2/kg', 'quantity': '8 kg'}];
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildTimeSlotCard(BookingWindow window) {
    return Card(
      child: ListTile(
        title: Text('${_formatDate(window.date)} - ${window.session.toUpperCase()}'),
        subtitle: Text('${_formatTimeOfDay(window.startTime)} to ${_formatTimeOfDay(window.endTime)}'),
        trailing: Text('${window.availableTokens} tokens left', style: TextStyle(
            color: window.availableTokens < 5 ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold
        )),
        selected: _selectedWindow == window,
        onTap: () => setState(() => _selectedWindow = window),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Time Slot'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Time Slots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Select a time slot for ration collection:', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),

            if (_availableWindows.isEmpty)
              Center(child: Text('No time slots available. Please check back later.')),

            Expanded(
              child: ListView.builder(
                itemCount: _availableWindows.length,
                itemBuilder: (context, index) => _buildTimeSlotCard(_availableWindows[index]),
              ),
            ),

            if (_selectedWindow != null) ...[
              SizedBox(height: 20),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Selected Slot:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${_formatDate(_selectedWindow!.date)} ${_selectedWindow!.session.toUpperCase()}'),
                      Text('${_formatTimeOfDay(_selectedWindow!.startTime)} - ${_formatTimeOfDay(_selectedWindow!.endTime)}'),
                      Text('${_selectedWindow!.availableTokens} tokens remaining', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _bookToken(_selectedWindow!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('BOOK TOKEN NOW'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}