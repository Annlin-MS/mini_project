import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dealer_model.dart';
import '../services/daily_report_service.dart';

class DealerProfileScreen extends StatefulWidget {
  final Dealer dealer;

  const DealerProfileScreen({
    Key? key,
    required this.dealer,
  }) : super(key: key);

  @override
  _DealerProfileScreenState createState() => _DealerProfileScreenState();
}

class _DealerProfileScreenState extends State<DealerProfileScreen> {
  DailyReport? todayReport;
  bool isLoadingReport = true;

  @override
  void initState() {
    super.initState();
    _generateTodayReport();
  }

  Future<void> _generateTodayReport() async {
    try {
      final report = await DailyReportService.generateDailyReport(
        widget.dealer.id,
        widget.dealer.shopId,
      );
      setState(() {
        todayReport = report;
        isLoadingReport = false;
      });
    } catch (e) {
      setState(() {
        isLoadingReport = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dealer = widget.dealer;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header with Photo
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_getDealerPrimaryColor(), _getDealerPrimaryColor().withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40), // Status bar padding
                  // Profile Picture
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: dealer.profileImageUrl.isNotEmpty
                          ? NetworkImage(dealer.profileImageUrl)
                          : AssetImage('assets/dealer_placeholder.png') as ImageProvider,
                      child: dealer.profileImageUrl.isEmpty
                          ? Icon(Icons.store, size: 60, color: _getDealerPrimaryColor())
                          : null,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    dealer.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Licensed Dealer • Ward ${dealer.wardNumber}',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRatingStars(dealer.rating),
                      SizedBox(width: 8),
                      Text(
                        '${dealer.rating}/5.0',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Personal Information
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _buildInfoRow('Full Name', dealer.name),
                    _buildInfoRow('Age', '${dealer.age} years'),
                    _buildInfoRow('Gender', dealer.gender),
                    _buildInfoRow('Date of Birth', DateFormat('dd MMM yyyy').format(dealer.dateOfBirth)),
                    _buildInfoRow('Father\'s Name', dealer.fatherName.isNotEmpty ? dealer.fatherName : 'Not provided'),
                    _buildInfoRow('Blood Group', dealer.bloodGroup),
                    _buildInfoRow('Phone', dealer.phone),
                    _buildInfoRow('Email', dealer.email),
                    _buildInfoRow('Emergency Contact', dealer.emergencyContact.isNotEmpty ? dealer.emergencyContact : 'Not provided'),
                    _buildInfoRow('Qualification', dealer.qualification.isNotEmpty ? dealer.qualification : 'Not provided'),
                    _buildInfoRow('Experience', dealer.experience.isNotEmpty ? dealer.experience : '${dealer.experienceYears} years'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Shop & License Details
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shop & License Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _buildInfoRow('Shop Name', dealer.shopName),
                    _buildInfoRow('Shop License No.', dealer.shopLicenseNumber.isNotEmpty ? dealer.shopLicenseNumber : 'Not provided'),
                    _buildInfoRow('Shop License Expiry', DateFormat('dd MMM yyyy').format(dealer.shopLicenseExpiry)),
                    _buildInfoRow('Dealer License No.', dealer.licenseNumber),
                    _buildInfoRow('License Expiry', DateFormat('dd MMM yyyy').format(dealer.licenseExpiry)),
                    _buildInfoRow('FSSAI Number', dealer.fssaiNumber.isNotEmpty ? dealer.fssaiNumber : 'Not provided'),
                    _buildInfoRow('GST Number', dealer.gstNumber.isNotEmpty ? dealer.gstNumber : 'Not provided'),
                    _buildInfoRow('Shop Area', dealer.shopArea > 0 ? '${dealer.shopArea} sq ft' : 'Not provided'),
                    _buildInfoRow('Shop Type', dealer.shopType),
                    _buildInfoRow('Ward Number', dealer.wardNumber),
                    _buildInfoRow('Address', dealer.address),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Government ID Details
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Government ID Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _buildInfoRow('Aadhar Number', dealer.aadharNumber.isNotEmpty ? dealer.aadharNumber : 'Not provided'), // FULL AADHAR
                    _buildInfoRow('PAN Number', dealer.panNumber.isNotEmpty ? dealer.panNumber : 'Not provided'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Banking Details
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Banking Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _buildInfoRow('Bank Name', dealer.bankName.isNotEmpty ? dealer.bankName : 'Not provided'),
                    _buildInfoRow('Account Number', dealer.accountNumber.isNotEmpty ? 'XXXXXX${dealer.accountNumber.substring(dealer.accountNumber.length - 4)}' : 'Not provided'),
                    _buildInfoRow('IFSC Code', dealer.ifscCode.isNotEmpty ? dealer.ifscCode : 'Not provided'),
                    _buildInfoRow('Branch Name', dealer.branchName.isNotEmpty ? dealer.branchName : 'Not provided'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Performance & Statistics
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Performance & Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _buildPerformanceRow('Overall Rating', '${dealer.rating}/5.0', dealer.rating >= 4.0 ? Colors.green : Colors.orange),
                    _buildPerformanceRow('Performance Status', dealer.performanceStatus,
                        dealer.performanceStatus == 'Excellent' ? Colors.green :
                        dealer.performanceStatus == 'Good' ? Colors.blue :
                        dealer.performanceStatus == 'Average' ? Colors.orange : Colors.red),
                    _buildPerformanceRow('Total Customers', '${dealer.totalCustomers}', Colors.blue),
                    _buildPerformanceRow('Warnings Count', '${dealer.warningsCount}',
                        dealer.warningsCount == 0 ? Colors.green : Colors.red),
                    _buildPerformanceRow('Join Date', DateFormat('dd MMM yyyy').format(dealer.joinDate), Colors.grey.shade700),
                    _buildPerformanceRow('Experience', '${dealer.experienceYears} years', Colors.purple),
                    _buildPerformanceRow('Last Stock Update', DateFormat('dd MMM, HH:mm').format(dealer.lastStockUpdate),
                        DateTime.now().difference(dealer.lastStockUpdate).inHours < 24 ? Colors.green : Colors.red),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Today's Report
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Today\'s Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        if (todayReport != null && !todayReport!.isSubmitted)
                          ElevatedButton(
                            onPressed: _submitTodayReport,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getDealerPrimaryColor(),
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Submit to Admin'),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (isLoadingReport)
                      Center(child: CircularProgressIndicator())
                    else if (todayReport != null)
                      _buildTodayReportSection(todayReport!)
                    else
                      Text('Unable to generate today\'s report'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayReportSection(DailyReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Report Status
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: report.isSubmitted ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            report.isSubmitted ? 'Submitted to Admin' : 'Pending Submission',
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),

        SizedBox(height: 16),

        // Customer Statistics
        Text('Customer Statistics', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildCustomerStatCard('AAY', report.customerStats['aay'] ?? 0, Color(0xFFFFD700))),
            SizedBox(width: 8),
            Expanded(child: _buildCustomerStatCard('BPL', report.customerStats['bpl'] ?? 0, Color(0xFFE91E63))),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildCustomerStatCard('APL', report.customerStats['apl'] ?? 0, Color(0xFF2196F3))),
            SizedBox(width: 8),
            Expanded(child: _buildCustomerStatCard('White', report.customerStats['white'] ?? 0, Color(0xFF9E9E9E))),
          ],
        ),

        SizedBox(height: 16),

        // Revenue & Tokens
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text('₹${report.totalRevenue.toStringAsFixed(0)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    Text('Revenue', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text('${report.totalTokens}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text('Tokens', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Alerts
        if (report.lowStockAlerts.isNotEmpty) ...[
          Text('Stock Alerts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          SizedBox(height: 8),
          ...report.lowStockAlerts.map((alert) => Container(
            margin: EdgeInsets.only(bottom: 4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text(alert, style: TextStyle(fontSize: 12))),
              ],
            ),
          )).toList(),
          SizedBox(height: 16),
        ],

        if (report.malpracticeAlerts.isNotEmpty) ...[
          Text('Compliance Alerts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          SizedBox(height: 8),
          ...report.malpracticeAlerts.map((alert) => Container(
            margin: EdgeInsets.only(bottom: 4),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text(alert, style: TextStyle(fontSize: 12))),
              ],
            ),
          )).toList(),
        ],
      ],
    );
  }

  Widget _buildCustomerStatCard(String type, int count, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text('$count', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          Text(type, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: 16));
    }

    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: 16));
    }

    int remainingStars = 5 - stars.length;
    for (int i = 0; i < remainingStars; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.white, size: 16));
    }

    return Row(children: stars);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceRow(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valueColor)),
          ),
        ],
      ),
    );
  }

  Color _getDealerPrimaryColor() {
    return Color(0xFF2E7D32); // Green for dealers
  }

  Future<void> _submitTodayReport() async {
    if (todayReport != null) {
      try {
        await DailyReportService.submitDailyReport(todayReport!);
        setState(() {
          todayReport = DailyReport(
            id: todayReport!.id,
            dealerId: todayReport!.dealerId,
            shopId: todayReport!.shopId,
            date: todayReport!.date,
            customerStats: todayReport!.customerStats,
            stockLevels: todayReport!.stockLevels,
            stockSales: todayReport!.stockSales,
            totalRevenue: todayReport!.totalRevenue,
            totalTokens: todayReport!.totalTokens,
            lowStockAlerts: todayReport!.lowStockAlerts,
            malpracticeAlerts: todayReport!.malpracticeAlerts,
            isSubmitted: true,
            submittedAt: DateTime.now(),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Daily report submitted to admin successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
