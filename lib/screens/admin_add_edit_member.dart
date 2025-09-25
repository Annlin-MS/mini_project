import 'package:flutter/material.dart';
import '../models/ration_card.dart';

class AdminAddEditMember extends StatefulWidget {
  final RationCard rationCard;
  final FamilyMember? member;

  const AdminAddEditMember({
    Key? key,
    required this.rationCard,
    this.member,
  }) : super(key: key);

  @override
  _AdminAddEditMemberState createState() => _AdminAddEditMemberState();
}

class _AdminAddEditMemberState extends State<AdminAddEditMember> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _fatherHusbandController;
  late TextEditingController _relationshipController;
  late TextEditingController _dobController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  late TextEditingController _aadharController;
  String? _selectedGender;
  bool _isHeadOfFamily = false;

  DateTime? _selectedDob;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member?.name ?? '');
    _fatherHusbandController =
        TextEditingController(text: widget.member?.fatherHusbandName ?? '');
    _relationshipController =
        TextEditingController(text: widget.member?.relationship ?? '');
    _dobController = TextEditingController(
        text: widget.member != null
            ? widget.member!.dateOfBirth.toLocal().toString().split(' ')[0]
            : '');
    _ageController =
        TextEditingController(text: widget.member?.age.toString() ?? '');
    _addressController =
        TextEditingController(text: widget.member?.address ?? '');
    _aadharController =
        TextEditingController(text: widget.member?.aadharNumber ?? '');
    _selectedGender = widget.member?.gender;
    _isHeadOfFamily = widget.member?.isHeadOfFamily ?? false;
    _selectedDob = widget.member?.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherHusbandController.dispose();
    _relationshipController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _aadharController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(1970),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = picked.toLocal().toString().split(' ')[0];
        _updateAge(picked);
      });
    }
  }

  void _updateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    _ageController.text = age.toString();
  }

  void _saveMember() {
    if (_formKey.currentState!.validate()) {
      final newMember = FamilyMember(
        id: widget.member?.id ?? UniqueKey().toString(),
        cardNumber: widget.rationCard.cardNumber,
        name: _nameController.text.trim(),
        fatherHusbandName: _fatherHusbandController.text.trim(),
        relationship: _relationshipController.text.trim(),
        dateOfBirth: _selectedDob ?? DateTime.now(),
        age: int.tryParse(_ageController.text) ?? 0,
        address: _addressController.text.trim(),
        aadharNumber: _aadharController.text.trim(),
        gender: _selectedGender ?? '',
        isHeadOfFamily: _isHeadOfFamily,
      );

      final index = widget.rationCard.familyMembers
          .indexWhere((m) => m.id == newMember.id);
      if (index == -1) {
        widget.rationCard.familyMembers.add(newMember);
      } else {
        widget.rationCard.familyMembers[index] = newMember;
      }

      if (_isHeadOfFamily) {
        widget.rationCard.headOfFamily = newMember.name;
      }

      Navigator.of(context).pop(newMember);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.member == null ? 'Add Member' : 'Edit Member'),
        backgroundColor: Colors.red.shade700,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _fatherHusbandController,
                decoration:
                InputDecoration(labelText: "Father's/Husband's Name"),
                validator: (v) =>
                v == null || v.isEmpty ? 'Enter father/husband name' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _relationshipController,
                decoration: InputDecoration(labelText: 'Relationship'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Enter relationship' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (v) =>
                v == null || v.isEmpty ? 'Select date of birth' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                readOnly: true,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Enter address' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _aadharController,
                decoration: InputDecoration(labelText: 'Aadhar Number'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Enter Aadhar number' : null,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) =>
                    DropdownMenuItem(value: gender, child: Text(gender)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Gender'),
                onChanged: (val) => setState(() => _selectedGender = val),
                validator: (val) =>
                val == null || val.isEmpty ? 'Select gender' : null,
              ),
              SizedBox(height: 12),
              CheckboxListTile(
                title: Text('Head of Family'),
                value: _isHeadOfFamily,
                onChanged: (val) => setState(() => _isHeadOfFamily = val ?? false),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMember,
                child: Text(widget.member == null ? 'Add Member' : 'Save Changes'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
