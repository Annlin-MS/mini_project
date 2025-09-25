import 'package:flutter/material.dart';
import '../models/ration_card.dart';
import '../models/complaint_model.dart';
import '../services/complaint_service.dart';

class ComplaintRegistrationScreen extends StatefulWidget {
  final RationCard rationCard;

  const ComplaintRegistrationScreen({
    Key? key,
    required this.rationCard,
  }) : super(key: key);

  @override
  _ComplaintRegistrationScreenState createState() => _ComplaintRegistrationScreenState();
}

class _ComplaintRegistrationScreenState extends State<ComplaintRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _complaintController = TextEditingController();
  String _selectedCategory = 'quality';
  String _selectedPriority = 'medium';
  bool _isSubmitting = false;

  final List<Map<String, String>> _categories = [
    {'value': 'quality', 'label': 'Quality Issue'},
    {'value': 'shortage', 'label': 'Shortage/Delivery'},
    {'value': 'behavior', 'label': 'Staff Behavior'},
    {'value': 'payment', 'label': 'Payment Issue'},
    {'value': 'other', 'label': 'Other'},
  ];

  final List<Map<String, String>> _priorities = [
    {'value': 'high', 'label': 'High Priority'},
    {'value': 'medium', 'label': 'Medium Priority'},
    {'value': 'low', 'label': 'Low Priority'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Complaint'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // User Information
              Card(
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(widget.rationCard.headOfFamily),
                  subtitle: Text('Card: ${widget.rationCard.cardNumber}'),
                ),
              ),
              SizedBox(height: 20),

              // Complaint Category
              Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['value'],
                    child: Text(category['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Priority Level
              Text('Priority', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: _priorities.map((priority) {
                  return DropdownMenuItem<String>(
                    value: priority['value'],
                    child: Text(priority['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Complaint Details
              Text('Complaint Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: _complaintController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Please describe your complaint in detail...',
                  labelText: 'Complaint Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter complaint details';
                  }
                  if (value.length < 10) {
                    return 'Please provide more details (min. 10 characters)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Photo Attachment (Optional)
              Text('Attach Photos (Optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _attachPhoto,
                icon: Icon(Icons.camera_alt),
                label: Text('Add Photo Evidence'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('SUBMIT COMPLAINT', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _attachPhoto() {
    // Implement photo attachment functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Photo attachment feature will be implemented')),
    );
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Create complaint object
        final complaint = Complaint(
          id: 'complaint_${DateTime.now().millisecondsSinceEpoch}',
          rationCardNo: widget.rationCard.cardNumber,
          userName: widget.rationCard.headOfFamily,
          category: _selectedCategory,
          priority: _selectedPriority,
          description: _complaintController.text,
          timestamp: DateTime.now(),
          status: 'pending',
        );

        // Submit to service
        await ComplaintService.submitComplaint(complaint);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Complaint registered successfully! ID: ${complaint.id}'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        _complaintController.clear();
        setState(() {
          _selectedCategory = 'quality';
          _selectedPriority = 'medium';
          _isSubmitting = false;
        });

        // Navigate back after a delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit complaint. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }
}
