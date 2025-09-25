import 'package:flutter/material.dart';
import '../models/ration_card.dart';

class UserProfileScreen extends StatelessWidget {
  final RationCard rationCard;
  final Color cardColor;

  const UserProfileScreen({
    Key? key,
    required this.rationCard,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Find head of family
    final headOfFamily = rationCard.familyMembers.firstWhere(
          (member) => member.isHeadOfFamily,
      orElse: () => rationCard.familyMembers.first,
    );

    // Get other family members (excluding head)
    final otherMembers = rationCard.familyMembers
        .where((member) => !member.isHeadOfFamily)
        .toList();

    // ✅ FIXED: Remove Scaffold - return only the body content to avoid double AppBar
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section with Card Info
          _buildCardHeader(),

          SizedBox(height: 16),

          // Head of Family Section
          _buildHeadOfFamilySection(headOfFamily, context),

          SizedBox(height: 24),

          // Other Family Members Section
          if (otherMembers.isNotEmpty)
            _buildOtherMembersSection(otherMembers, context),

          SizedBox(height: 24),

          // Family Statistics
          _buildFamilyStats(),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCardHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Ration Card Visual
          Container(
            width: 280,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RATION CARD',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          rationCard.cardType,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    rationCard.cardNumber,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Head: ${rationCard.headOfFamily}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Valid till: ${rationCard.expiryDate.day}/${rationCard.expiryDate.month}/${rationCard.expiryDate.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${rationCard.totalMembers} Members',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Icon(
                        rationCard.isValid ? Icons.verified : Icons.warning,
                        color: rationCard.isValid ? Colors.green : Colors.red,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadOfFamilySection(FamilyMember headOfFamily, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'Head of Family',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildEnhancedMemberCard(headOfFamily, context, isHead: true),
        ],
      ),
    );
  }

  Widget _buildOtherMembersSection(List<FamilyMember> otherMembers, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.family_restroom, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                'Family Members (${otherMembers.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...otherMembers.map((member) => Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _buildEnhancedMemberCard(member, context, isHead: false),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildEnhancedMemberCard(FamilyMember member, BuildContext context, {required bool isHead}) {
    return Card(
      elevation: isHead ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isHead ? Border.all(color: Colors.amber, width: 2) : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Profile Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: member.gender == 'Male'
                            ? Colors.blue.shade100
                            : Colors.pink.shade100,
                        child: Icon(
                          member.gender == 'Male' ? Icons.male : Icons.female,
                          color: member.gender == 'Male' ? Colors.blue : Colors.pink,
                          size: 30,
                        ),
                      ),
                      if (isHead)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(width: 16),

                  // Member Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                member.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            if (isHead)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.amber.shade300),
                                ),
                                child: Text(
                                  'HEAD',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.family_restroom, size: 14, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              member.relationship,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.cake, size: 14, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              '${member.age} years',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.credit_card, size: 12, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                'Aadhar: ${_maskAadhar(member.aadharNumber)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Button
                  IconButton(
                    icon: Icon(Icons.info_outline, color: Colors.blue),
                    onPressed: () => _showMemberDetails(member, context),
                    tooltip: 'View Details',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyStats() {
    final males = rationCard.familyMembers.where((m) => m.gender == 'Male').length;
    final females = rationCard.familyMembers.where((m) => m.gender == 'Female').length;
    final adults = rationCard.familyMembers.where((m) => m.age >= 18).length;
    final minors = rationCard.familyMembers.where((m) => m.age < 18).length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Family Statistics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem('Total Members', '${rationCard.totalMembers}', Icons.people, Colors.blue),
                  ),
                  Expanded(
                    child: _buildStatItem('Adults (18+)', '$adults', Icons.person, Colors.green),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem('Males', '$males', Icons.male, Colors.blue),
                  ),
                  Expanded(
                    child: _buildStatItem('Females', '$females', Icons.female, Colors.pink),
                  ),
                ],
              ),
              if (minors > 0) ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem('Minors (<18)', '$minors', Icons.child_care, Colors.orange),
                    ),
                    Expanded(child: SizedBox()), // Empty space
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _maskAadhar(String aadhar) {
    if (aadhar.length >= 12) {
      return '${aadhar.substring(0, 4)} XXXX ${aadhar.substring(8)}';
    }
    return aadhar;
  }

  void _showMemberDetails(FamilyMember member, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: member.gender == 'Male' ? Colors.blue : Colors.pink,
              child: Icon(
                member.gender == 'Male' ? Icons.male : Icons.female,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name),
                  if (member.isHeadOfFamily)
                    Text(
                      'Head of Family',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Full Name', member.name),
              _buildDetailRow('Relationship', member.relationship),
              _buildDetailRow('Age', '${member.age} years'),
              _buildDetailRow('Gender', member.gender),
              _buildDetailRow('Date of Birth', '${member.dateOfBirth.day}/${member.dateOfBirth.month}/${member.dateOfBirth.year}'),
              _buildDetailRow('Aadhar Number', member.aadharNumber),
              _buildDetailRow('Father/Husband', member.fatherHusbandName),
              _buildDetailRow('Address', member.address),
              if (member.isHeadOfFamily)
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Head of Family',
                          style: TextStyle(
                            color: Colors.amber.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit Profile Information'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profile editing feature will be available after connecting to database'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.green),
              title: Text('Add Family Member'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Add member feature will be available after admin approval'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.download, color: Colors.purple),
              title: Text('Download Family Details'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Family details downloaded successfully'),
                    backgroundColor: Colors.purple,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
