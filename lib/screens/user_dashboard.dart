import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';
import '../models/payment_model.dart';
import '../models/ration_card.dart';
import '../data/mock_database.dart';
import 'user_profile_screen.dart';
import 'book_token.dart';
import 'complaint_registration_screen.dart';
import 'notification_screen.dart';
import 'entitlements_screen.dart';
import 'payment_options_page.dart';

class UserDashboard extends StatefulWidget {
  final String userName;
  final String rationCardNo;
  final String cardType;
  final int cardColor;
  final Map<String, dynamic> currentMonthEntitlement;

  const UserDashboard({
    Key? key,
    required this.userName,
    required this.rationCardNo,
    required this.cardType,
    required this.cardColor,
    required this.currentMonthEntitlement,
  }) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;

  // Dynamic AppBar titles for each tab (including new Profile tab)
  final List<String> _appBarTitles = [
    'User Dashboard',      // Home tab
    'Book Token',          // Token booking tab
    'Register Complaint',  // Complaints tab
    'Payment History',     // History/Payments tab
    'Family Profile',      // NEW: Profile tab
  ];

  @override
  Widget build(BuildContext context) {
    RationCard rationCard = mockRationCards.firstWhere(
          (card) => card.cardNumber == widget.rationCardNo,
      orElse: () => mockRationCards.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_currentIndex]), // Dynamic title based on tab
        backgroundColor: _getKeralaPrimaryColor(widget.cardType),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => _navigateToNotifications(rationCard),
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showCardValidity(rationCard),
          ),
        ],
      ),
      body: _getTab(_currentIndex, rationCard),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _getKeralaPrimaryColor(widget.cardType),
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Complaints'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'), // NEW: Profile tab
        ],
      ),
    );
  }

  // ✅ FIXED: _getTab method with corrected UserProfileScreen parameters
  Widget _getTab(int index, RationCard rationCard) {
    switch (index) {
      case 0:
        return _buildDashboardTab(rationCard);
      case 1:
        return BookToken(rationCard: rationCard);
      case 2:
        return ComplaintRegistrationScreen(rationCard: rationCard);
      case 3:
        return _buildHistoryTab(rationCard);
      case 4: // ✅ FIXED: Profile tab with correct parameters
        return UserProfileScreen(
          rationCard: rationCard,
          cardColor: _getKeralaCardColor(widget.cardType),
        );
      default:
        return _buildDashboardTab(rationCard);
    }
  }

  Widget _buildDashboardTab(RationCard rationCard) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Welcome Card with Profile Picture
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getKeralaPrimaryColor(widget.cardType),
                    _getKeralaPrimaryColor(widget.cardType).withOpacity(0.7)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Profile Picture with Kerala Card Color Border
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: _getKeralaCardColor(widget.cardType),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              widget.userName.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Ration Card with Color Indicator
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getKeralaCardColor(widget.cardType),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'RC: ${widget.rationCardNo}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${_getKeralaCardDisplayName(widget.cardType)} • ${rationCard.isValid ? "Active" : "Expired"}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildActionCard(
                'Book Token',
                Icons.confirmation_number,
                Colors.blue,
                    () => setState(() => _currentIndex = 1),
              ),
              _buildActionCard(
                'Family Profile', // NEW: Quick access to profile
                Icons.account_circle,
                Colors.indigo,
                    () => setState(() => _currentIndex = 4),
              ),
              _buildActionCard(
                'View Entitlements',
                Icons.inventory_2,
                Colors.green,
                    () => _navigateToEntitlements(rationCard),
              ),
              _buildActionCard(
                'Make Payment',
                Icons.payment,
                Colors.purple,
                    () => _navigateToPayments(rationCard),
              ),
              _buildActionCard(
                'Register Complaint',
                Icons.report_problem,
                Colors.red,
                    () => setState(() => _currentIndex = 2),
              ),
              _buildActionCard(
                'View History',
                Icons.history,
                Colors.orange,
                    () => setState(() => _currentIndex = 3),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Kerala Card Information Summary
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getKeralaCardColor(widget.cardType),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        _getKeralaCardFullName(widget.cardType),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Family Members', style: TextStyle(color: Colors.grey.shade600)),
                      Text('${rationCard.familyMembers.length}', style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Monthly Entitlement', style: TextStyle(color: Colors.grey.shade600)),
                      Text(_getKeralaMonthlyEntitlement(widget.cardType), style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Card Status', style: TextStyle(color: Colors.grey.shade600)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: rationCard.isValid ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          rationCard.isValid ? 'Active' : 'Expired',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // This Month's Summary
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Month\'s Entitlements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _buildSummaryRow('Rice', '${widget.currentMonthEntitlement['rice'] ?? '5'}kg'),
                  _buildSummaryRow('Wheat', '${widget.currentMonthEntitlement['wheat'] ?? '3'}kg'),
                  _buildSummaryRow('Sugar', '${widget.currentMonthEntitlement['sugar'] ?? '2'}kg'),
                  _buildSummaryRow('Oil', '${widget.currentMonthEntitlement['oil'] ?? '1'}L'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String item, String quantity) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item, style: TextStyle(fontSize: 16)),
          Text(quantity, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(RationCard rationCard) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment & Transaction History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Recent payments
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Payments',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _buildPaymentItem('Token #001', '₹85', '15 Sep 2025', 'Completed'),
                  _buildPaymentItem('Token #002', '₹92', '10 Sep 2025', 'Completed'),
                  _buildPaymentItem('Token #003', '₹78', '5 Sep 2025', 'Completed'),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Recent Bookings
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Bookings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _buildBookingItem('Token #T001', 'Today 10:00 AM', 'Confirmed'),
                  _buildBookingItem('Token #T002', 'Yesterday 2:00 PM', 'Completed'),
                  _buildBookingItem('Token #T003', '15 Sep 3:00 PM', 'Completed'),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () => _navigateToPayments(rationCard),
            icon: Icon(Icons.payment),
            label: Text('Make New Payment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getKeralaPrimaryColor(widget.cardType),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(String tokenId, String amount, String date, String status) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tokenId, style: TextStyle(fontWeight: FontWeight.w600)),
              Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(status, style: TextStyle(color: Colors.green, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(String tokenId, String dateTime, String status) {
    Color statusColor = status == 'Confirmed' ? Colors.blue :
    status == 'Completed' ? Colors.green : Colors.orange;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tokenId, style: TextStyle(fontWeight: FontWeight.w600)),
              Text(dateTime, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // KERALA GOVERNMENT OFFICIAL COLORS
  Color _getKeralaPrimaryColor(String cardType) {
    return _getKeralaCardColor(cardType).withOpacity(0.9);
  }

  Color _getKeralaCardColor(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'aay':
        return Color(0xFFFFD700); // Gold/Yellow for AAY (Antyodaya)
      case 'bpl':
        return Color(0xFFE91E63); // Pink for BPL (Priority)
      case 'apl':
        return Color(0xFF2196F3); // Blue for APL (State Subsidy)
      case 'white':
        return Color(0xFF9E9E9E); // Grey for White (NOT BLUE!)
      default:
        return Color(0xFF9E9E9E);
    }
  }

  String _getKeralaCardDisplayName(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'aay':
        return 'AAY Card';
      case 'bpl':
        return 'BPL Card';
      case 'apl':
        return 'APL Card';
      case 'white':
        return 'White Card';
      default:
        return 'Ration Card';
    }
  }

  String _getKeralaCardFullName(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'aay':
        return 'Antyodaya Anna Yojana (AAY)';
      case 'bpl':
        return 'Below Poverty Line (BPL)';
      case 'apl':
        return 'Above Poverty Line (APL)';
      case 'white':
        return 'General Category (White)';
      default:
        return 'Ration Card';
    }
  }

  String _getKeralaMonthlyEntitlement(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'aay':
        return '35 kg grains (FREE)';
      case 'bpl':
        return '25 kg grains (₹2-3/kg)';
      case 'apl':
        return '15 kg grains (₹6-8/kg)';
      case 'white':
        return '10 kg grains (Market price)';
      default:
        return 'As per norms';
    }
  }

  // ✅ FIXED: Navigation methods with CORRECT parameter names
  void _navigateToNotifications(RationCard rationCard) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationScreen(rationCardNo: rationCard.cardNumber), // ✅ FIXED
      ),
    );
  }

  void _navigateToEntitlements(RationCard rationCard) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntitlementsScreen(
          rationCardNo: rationCard.cardNumber, // ✅ FIXED
          cardType: widget.cardType,
          currentMonthEntitlement: widget.currentMonthEntitlement, // ✅ FIXED
        ),
      ),
    );
  }

  void _navigateToPayments(RationCard rationCard) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentOptionsPage(
          userId: 'user_${rationCard.cardNumber}',
          userName: widget.userName,
          rationCardNo: rationCard.cardNumber,
        ),
      ),
    );
  }

  void _showCardValidity(RationCard rationCard) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getKeralaCardColor(widget.cardType),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            Text('Card Information'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Card Number: ${rationCard.cardNumber}'),
            Text('Type: ${_getKeralaCardFullName(widget.cardType)}'),
            Text('Head of Family: ${rationCard.headOfFamily}'),
            Text('Family Members: ${rationCard.familyMembers.length}'),
            Text('Issue Date: ${rationCard.issueDate.day}/${rationCard.issueDate.month}/${rationCard.issueDate.year}'),
            Text('Expiry Date: ${rationCard.expiryDate.day}/${rationCard.expiryDate.month}/${rationCard.expiryDate.year}'),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Status: '),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: rationCard.isValid ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    rationCard.isValid ? "Active" : "Expired",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
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
}
