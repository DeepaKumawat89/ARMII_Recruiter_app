import 'package:flutter/material.dart';

class PaymentTracking extends StatelessWidget {
  PaymentTracking({Key? key}) : super(key: key);

  // Dummy current subscription data
  final Map<String, dynamic> currentSubscription = {
    'plan': 'Premium',
    'price': 499.00,
    'status': 'Active',
    'renewalDate': '2025-09-01',
    'autoRenew': true,
  };

  // Dummy subscription payment history
  final List<Map<String, dynamic>> payments = [
    {
      'date': '2025-08-01',
      'amount': 499.00,
      'plan': 'Premium',
      'status': 'Paid',
      'invoice': true,
    },
    {
      'date': '2025-07-01',
      'amount': 499.00,
      'plan': 'Premium',
      'status': 'Paid',
      'invoice': true,
    },
    {
      'date': '2025-06-01',
      'amount': 499.00,
      'plan': 'Premium',
      'status': 'Failed',
      'invoice': false,
    },
    {
      'date': '2025-05-01',
      'amount': 299.00,
      'plan': 'Basic',
      'status': 'Paid',
      'invoice': true,
    },
  ];

  Color statusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.indigo;
      case 'Expired':
        return Colors.red;
      case 'Canceled':
        return Colors.grey;
      case 'Paid':
        return Colors.indigo;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Subscription Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.indigo, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Current Plan: ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.indigo.shade900,
                            fontSize: 16,
                          )),
                      Text(currentSubscription['plan'],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.indigo,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(width: 12),
                      Chip(
                        label: Text(currentSubscription['status'],
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: statusColor(currentSubscription['status']),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Price: ₹${currentSubscription['price'].toStringAsFixed(2)} / month',
                      style: TextStyle(color: Colors.grey.shade800)),
                  SizedBox(height: 4),
                  Text('Next Renewal: ${currentSubscription['renewalDate']}',
                      style: TextStyle(color: Colors.grey.shade800)),
                  SizedBox(height: 4),
                  if (currentSubscription['autoRenew'])
                    Text('Auto-renewal is ON', style: TextStyle(color: Colors.indigo)),
                  if (!currentSubscription['autoRenew'])
                    Text('Auto-renewal is OFF', style: TextStyle(color: Colors.red)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Renew/Upgrade Clicked')),
                          );
                        },
                        child: Text('Renew/Upgrade'),
                      ),
                      SizedBox(width: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.indigo,
                          side: BorderSide(color: Colors.indigo),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Cancel Subscription Clicked')),
                          );
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text('Subscription Payment History',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(Icons.subscriptions, color: Colors.indigo),
                      title: Text(
                        '₹${payment['amount'].toStringAsFixed(2)} - ${payment['plan']}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.indigo.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${payment['date']}',
                              style: TextStyle(color: Colors.grey.shade700)),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Chip(
                            label: Text(payment['status'],
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: statusColor(payment['status']),
                          ),
                          if (payment['invoice'])
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Downloading invoice...')),
                                );
                              },
                              child: Text('Invoice', style: TextStyle(color: Colors.indigo)),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
