import '../models/dealer_model.dart';
import '../models/shop_model.dart';
import '../models/token_model.dart';
import '../data/mock_database.dart';

class DailyReportService {
  static Future<DailyReport> generateDailyReport(String dealerId, String shopId) async {
    final today = DateTime.now();
    final todayFormatted = '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

    // Get today's tokens
    final todayTokens = mockTokens.where((token) =>
    token.shopId == shopId && token.date == todayFormatted
    ).toList();

    // Get shop data
    final shop = mockShops.firstWhere((s) => s.id == shopId);

    // Calculate customer statistics
    Map<String, int> customerStats = {
      'aay': 0,
      'bpl': 0,
      'apl': 0,
      'white': 0,
    };

    for (var token in todayTokens) {
      String cardType = _getCardTypeFromRationCard(token.rationCardNo ?? '');
      customerStats[cardType] = (customerStats[cardType] ?? 0) + 1;
    }

    // Calculate stock levels
    Map<String, double> stockLevels = {};
    List<String> lowStockAlerts = [];

    shop.inventory.forEach((item, details) {
      if (details is Map<String, dynamic>) {
        double current = (details['current'] ?? 0).toDouble();
        double max = (details['max'] ?? 1).toDouble();
        double percentage = (current / max) * 100;

        stockLevels[item] = percentage;

        // Check for low stock (below 20%)
        if (percentage < 20) {
          lowStockAlerts.add('$item is running low (${percentage.toStringAsFixed(1)}% remaining)');
        }
      }
    });

    // Calculate stock sales
    Map<String, int> stockSales = {};
    double totalRevenue = 0;

    for (var token in todayTokens) {
      if (token.status == 'completed') {
        totalRevenue += token.totalAmount ?? 0;
        // Mock sales calculation
        stockSales['Rice'] = (stockSales['Rice'] ?? 0) + 5;
        stockSales['Wheat'] = (stockSales['Wheat'] ?? 0) + 3;
        stockSales['Sugar'] = (stockSales['Sugar'] ?? 0) + 2;
        stockSales['Oil'] = (stockSales['Oil'] ?? 0) + 1;
      }
    }

    // Check for malpractice alerts
    List<String> malpracticeAlerts = [];

    // Check for unusual sales patterns
    int totalCustomers = customerStats.values.fold(0, (sum, count) => sum + count);
    if (totalCustomers > 0 && totalRevenue / totalCustomers > 200) {
      malpracticeAlerts.add('High revenue per customer detected (₹${(totalRevenue / totalCustomers).toStringAsFixed(0)})');
    }

    // Check for stock inconsistencies
    if (stockSales.values.fold(0, (sum, sales) => sum + sales) > totalCustomers * 10) {
      malpracticeAlerts.add('Stock sales exceed expected customer demand');
    }

    // Check for missing stock updates
    final dealer = mockDealers.firstWhere((d) => d.id == dealerId);
    if (DateTime.now().difference(dealer.lastStockUpdate).inHours > 24) {
      malpracticeAlerts.add('Stock not updated for more than 24 hours');
    }

    return DailyReport(
      id: 'report_${dealerId}_${today.millisecondsSinceEpoch}',
      dealerId: dealerId,
      shopId: shopId,
      date: today,
      customerStats: customerStats,
      stockLevels: stockLevels,
      stockSales: stockSales,
      totalRevenue: totalRevenue,
      totalTokens: todayTokens.length,
      lowStockAlerts: lowStockAlerts,
      malpracticeAlerts: malpracticeAlerts,
      isSubmitted: false,
    );
  }

  static Future<void> submitDailyReport(DailyReport report) async {
    // In real app, this would send to server/database
    final updatedReport = DailyReport(
      id: report.id,
      dealerId: report.dealerId,
      shopId: report.shopId,
      date: report.date,
      customerStats: report.customerStats,
      stockLevels: report.stockLevels,
      stockSales: report.stockSales,
      totalRevenue: report.totalRevenue,
      totalTokens: report.totalTokens,
      lowStockAlerts: report.lowStockAlerts,
      malpracticeAlerts: report.malpracticeAlerts,
      isSubmitted: true,
      submittedAt: DateTime.now(),
    );

    // Mock storage - in real app, save to database
    print('Daily report submitted for dealer ${report.dealerId}');
    print('Revenue: ₹${report.totalRevenue}');
    print('Customers: ${report.totalTokens}');
    print('Alerts: ${report.lowStockAlerts.length + report.malpracticeAlerts.length}');
  }

  static String _getCardTypeFromRationCard(String rationCardNo) {
    if (rationCardNo.contains('AAY')) return 'aay';
    if (rationCardNo.contains('BPL')) return 'bpl';
    if (rationCardNo.contains('APL')) return 'apl';
    return 'white';
  }
}
