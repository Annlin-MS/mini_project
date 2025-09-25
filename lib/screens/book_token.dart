import 'package:flutter/material.dart';
import '../models/ration_card.dart';
import 'user_time_slot_booking.dart';

class BookToken extends StatefulWidget {  // Changed name to match import
  final RationCard rationCard;

  const BookToken({Key? key, required this.rationCard}) : super(key: key);

  @override
  _BookTokenState createState() => _BookTokenState();
}

class _BookTokenState extends State<BookToken> {
  final TextEditingController _rationCardController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill user details from rationCard
    _rationCardController.text = widget.rationCard.cardNumber;
    _userNameController.text = widget.rationCard.headOfFamily;
  }

  @override
  void dispose() {
    _rationCardController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // NO SCAFFOLD OR APPBAR - Only content for tab usage
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Book Your Token',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Pre-filled user information
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow('Ration Card', widget.rationCard.cardNumber),
                  _buildDetailRow('Head of Family', widget.rationCard.headOfFamily),
                  _buildDetailRow('Card Type', widget.rationCard.cardType),
                  _buildDetailRow('Status', widget.rationCard.isValid ? 'Active' : 'Inactive'),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Token booking options
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Options',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // Quick booking button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _quickBookToken(),
                      icon: Icon(Icons.flash_on),
                      label: Text('Quick Book (Next Available Slot)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Advanced booking button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _navigateToAdvancedBooking(),
                      icon: Icon(Icons.schedule),
                      label: Text('Choose Time Slot'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green.shade700,
                        side: BorderSide(color: Colors.green.shade700),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Available time slots preview
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Available Slots',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTimeSlotChip('09:00-10:00', true),
                      _buildTimeSlotChip('10:00-11:00', true),
                      _buildTimeSlotChip('11:00-12:00', false),
                      _buildTimeSlotChip('14:00-15:00', true),
                      _buildTimeSlotChip('15:00-16:00', true),
                      _buildTimeSlotChip('16:00-17:00', false),
                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      _buildLegendItem(Colors.green, 'Available'),
                      SizedBox(width: 20),
                      _buildLegendItem(Colors.grey, 'Full'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Information card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade700),
                      SizedBox(width: 8),
                      Text(
                        'Important Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text('• Tokens are valid only for the selected date and time slot'),
                  SizedBox(height: 4),
                  Text('• Please arrive 15 minutes before your time slot'),
                  SizedBox(height: 4),
                  Text('• Bring your ration card and a valid ID proof'),
                  SizedBox(height: 4),
                  Text('• Cancellation allowed up to 2 hours before the slot'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildTimeSlotChip(String time, bool isAvailable) {
    return Chip(
      label: Text(
        time,
        style: TextStyle(
          color: isAvailable ? Colors.green.shade800 : Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      backgroundColor: isAvailable ? Colors.green.shade100 : Colors.grey.shade200,
      side: BorderSide(
        color: isAvailable ? Colors.green.shade300 : Colors.grey.shade400,
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  void _quickBookToken() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Quick Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book token for next available slot?'),
            SizedBox(height: 8),
            Text('Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
            Text('Time: 09:00-10:00'),
            Text('Shop: ${widget.rationCard.shopId}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Token booked successfully for ${widget.rationCard.headOfFamily}!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _navigateToAdvancedBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserTimeSlotBooking(rationCard: widget.rationCard),
      ),
    );
  }
}
