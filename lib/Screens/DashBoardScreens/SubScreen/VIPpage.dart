import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../widget/customroundedappbar.dart';

class VipPage extends StatefulWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  _VipPageState createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> {
  late Razorpay _razorpay;
  bool isSubscribed = false;
  String subscriptionType = '';
  DateTime? subscriptionStartDate;
  DateTime? subscriptionEndDate;
  String subscriptionId = '';
  String referralCode = 'VIP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  int referralCount = 3;
  String? selectedPlan; // Add this line for tracking selected plan
  int? selectedAmount; // Add this line for tracking selected amount

  // Sample billing history data
  List<Map<String, dynamic>> billingHistory = [
    {'plan': 'Monthly Plan', 'date': 'Jan 2025', 'amount': '\$19.99', 'status': 'Paid', 'id': 'TXN001'},
    {'plan': 'Monthly Plan', 'date': 'Dec 2024', 'amount': '\$19.99', 'status': 'Paid', 'id': 'TXN002'},
    {'plan': 'Monthly Plan', 'date': 'Nov 2024', 'amount': '\$19.99', 'status': 'Paid', 'id': 'TXN003'},
    {'plan': 'Yearly Plan', 'date': 'Oct 2024', 'amount': '\$199.99', 'status': 'Paid', 'id': 'TXN004'},
  ];

  // Replace with your Razorpay test key
  static const String RAZORPAY_KEY_ID = 'rzp_test_R6p4FIeSjWZHCC';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      isSubscribed = true;
      subscriptionStartDate = DateTime.now();
      subscriptionEndDate = subscriptionType == 'Monthly'
          ? DateTime.now().add(Duration(days: 30))
          : DateTime.now().add(Duration(days: 365));
      subscriptionId = response.paymentId ?? '';

      // Add to billing history
      billingHistory.insert(0, {
        'plan': '$subscriptionType Plan',
        'date': '${DateTime.now().month}/${DateTime.now().year}',
        'amount': subscriptionType == 'Monthly' ? '\$19.99' : '\$199.99',
        'status': 'Paid',
        'id': response.paymentId ?? '',
      });
    });

    Fluttertoast.showToast(
      msg: "Payment successful! Welcome to VIP!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment failed: ${response.message}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External wallet: ${response.walletName}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _openRazorpayCheckout(String planType, int amount) {
    var options = {
      'key': RAZORPAY_KEY_ID,
      'amount': amount * 100,
      'name': 'VIP Subscription',
      'description': '$planType Plan Subscription',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      subscriptionType = planType;
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      Fluttertoast.showToast(
        msg: "Payment initialization failed. Please try again.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customRoundedAppBar(context, isSubscribed ? 'VIP Member' : 'Go VIP'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFE4ECF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: isSubscribed ? _buildSubscribedView() : _buildSubscriptionView(),
        ),
      ),
    );
  }

  Widget _buildSubscriptionView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.amber, Colors.orangeAccent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withAlpha((0.3 * 255).toInt()),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(Icons.workspace_premium, color: Colors.white, size: 48),
                ),
                SizedBox(height: 10),
                Text('Upgrade your recruiting experience',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Benefits of VIP subscription:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              )),
          const SizedBox(height: 4),
          _benefitItem(Icons.check_circle, 'Access premium candidate database'),
          _benefitItem(Icons.check_circle, 'Post unlimited job listings'),
          _benefitItem(Icons.check_circle, 'Priority candidate support'),
          _benefitItem(Icons.check_circle, 'Detailed analytics & reports'),
          const SizedBox(height: 20),
          Text('Choose your plan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              )),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _planCard(context, 'Monthly', '\$19.99', 'Billed monthly', Colors.indigoAccent, 1999)),
              const SizedBox(width: 16),
              Expanded(child: _planCard(context, 'Yearly', '\$199.99', 'Save 20% annually', Colors.amber, 19999)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedPlan == null
                  ? null
                  : () => _openRazorpayCheckout(selectedPlan!, selectedAmount!),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Text(
                selectedPlan == null ? 'Select a Plan' : 'Subscribe Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Inter'
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribedView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Welcome Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withAlpha((0.3 * 255).toInt()),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Icon(Icons.verified, color: Colors.white, size: 64),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to VIP!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 24),

          // Subscription Management
          _buildSubscriptionManagement(),
          const SizedBox(height: 16),

          // Referral System
          _buildReferralSystem(),
          const SizedBox(height: 16),

          // Billing History
          _buildBillingHistory(),
          const SizedBox(height: 24),

          // Continue Button
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.arrow_back, color: Colors.white),
            label: Text(
              'Continue',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 1. SUBSCRIPTION MANAGEMENT
  Widget _buildSubscriptionManagement() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.manage_accounts, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Subscription Management',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Current Plan Info
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Current Plan:', style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                      Text('$subscriptionType Plan',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontFamily: 'Inter')),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Started:', style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                      Text('${subscriptionStartDate?.day}/${subscriptionStartDate?.month}/${subscriptionStartDate?.year}',
                          style: TextStyle(fontFamily: 'Inter')),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Next Billing:', style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                      Text('${subscriptionEndDate?.day}/${subscriptionEndDate?.month}/${subscriptionEndDate?.year}',
                          style: TextStyle(fontFamily: 'Inter')),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status:', style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Inter')),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Active',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Inter')),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Management Options
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _upgradePlan,
                    icon: Icon(Icons.upgrade, size: 18),
                    label: Text('Upgrade'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pauseSubscription,
                    icon: Icon(Icons.pause, size: 18),
                    label: Text('Pause'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _cancelSubscription,
                icon: Icon(Icons.cancel, color: Colors.red, size: 18),
                label: Text('Cancel Subscription', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. REFERRAL SYSTEM
  Widget _buildReferralSystem() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.share, color: Colors.orange, size: 24),
                SizedBox(width: 8),
                Text(
                  'Referral System',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.withOpacity(0.1), Colors.amber.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.card_giftcard, size: 48, color: Colors.orange),
                  SizedBox(height: 12),
                  Text(
                    'Refer Friends & Earn',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Get 1 month free for every successful referral!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontFamily: 'Inter'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Referral Stats
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text('$referralCount', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                        Text('Successful Referrals', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text('3', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                        Text('Months Earned', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Referral Code
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Referral Code:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      Text(referralCode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ],
                  ),
                  IconButton(
                    onPressed: _copyReferralCode,
                    icon: Icon(Icons.copy, color: Colors.blue),
                    tooltip: 'Copy Code',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _shareReferralCode,
              icon: Icon(Icons.share),
              label: Text('Share Referral Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. BILLING HISTORY
  Widget _buildBillingHistory() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.purple, size: 24),
                SizedBox(width: 8),
                Text(
                  'Billing History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recent transactions
            ...billingHistory.take(3).map((transaction) => _billingItem(
              transaction['plan'],
              transaction['date'],
              transaction['amount'],
              transaction['status'],
              transaction['id'],
            )).toList(),

            const SizedBox(height: 12),

            Center(
              child: TextButton.icon(
                onPressed: _showFullBillingHistory,
                icon: Icon(Icons.history),
                label: Text('View All Transactions'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingItem(String plan, String date, String amount, String status, String transactionId) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan, style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontFamily: 'Inter')),
                Text('ID: $transactionId', style: TextStyle(color: Colors.grey[500], fontSize: 10, fontFamily: 'Inter')),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Inter')),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'Paid' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == 'Paid' ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // HELPER METHODS
  void _upgradePlan() {
    if (subscriptionType == 'Monthly') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Upgrade to Yearly Plan', style: TextStyle(fontFamily: 'Inter')),
          content: Text('Upgrade to Yearly plan and save 20%! You\'ll be charged \$199.99 and your billing cycle will change to yearly.', style: TextStyle(fontFamily: 'Inter')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(fontFamily: 'Inter')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _openRazorpayCheckout('Yearly', 19999);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Upgrade Now', style: TextStyle(fontFamily: 'Inter')),
            ),
          ],
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "You're already on the highest plan!");
    }
  }

  void _pauseSubscription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pause Subscription', style: TextStyle(fontFamily: 'Inter')),
        content: Text('Your subscription will be paused for 30 days. You can reactivate it anytime during this period.', style: TextStyle(fontFamily: 'Inter')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(fontFamily: 'Inter')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Subscription paused for 30 days",
                backgroundColor: Colors.orange,
                textColor: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Pause Now', style: TextStyle(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  void _cancelSubscription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Subscription', style: TextStyle(fontFamily: 'Inter')),
        content: Text('Are you sure you want to cancel your VIP subscription? You\'ll lose access to all premium features at the end of your current billing period.', style: TextStyle(fontFamily: 'Inter')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep VIP', style: TextStyle(fontFamily: 'Inter')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isSubscribed = false;
                subscriptionType = '';
                subscriptionStartDate = null;
                subscriptionEndDate = null;
              });
              Fluttertoast.showToast(
                msg: "Subscription cancelled successfully",
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Cancel Plan', style: TextStyle(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  void _copyReferralCode() {
    Clipboard.setData(ClipboardData(text: referralCode));
    Fluttertoast.showToast(
      msg: "Referral code copied to clipboard!",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void _shareReferralCode() {
    // In a real app, you would use share_plus package
    // For now, just show a toast
    Fluttertoast.showToast(
      msg: "Share functionality would open here",
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  void _showFullBillingHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Complete Billing History', style: TextStyle(fontFamily: 'Inter')),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: billingHistory.length,
            itemBuilder: (context, index) {
              final transaction = billingHistory[index];
              return ListTile(
                title: Text(transaction['plan'], style: TextStyle(fontFamily: 'Inter')),
                subtitle: Text('${transaction['date']} • ID: ${transaction['id']}', style: TextStyle(fontFamily: 'Inter')),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(transaction['amount'], style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                    Text(transaction['status'], style: TextStyle(
                      color: transaction['status'] == 'Paid' ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    )),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  Widget _benefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
        ],
      ),
    );
  }

  Widget _planCard(BuildContext context, String title, String price, String subtitle, Color color, int amountInPaise) {
    final isSelected = selectedPlan == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = title;
          selectedAmount = amountInPaise;
        });
      },
      child: Card(
        elevation: isSelected ? 8 : 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color, fontFamily: 'Inter')),
              SizedBox(height: 8),
              Text(price, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: color, fontFamily: 'Inter')),
              SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[700], fontFamily: 'Inter')),
              const SizedBox(height: 16),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: color,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

