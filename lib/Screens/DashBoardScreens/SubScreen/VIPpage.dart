import 'package:flutter/material.dart';
import '../../../widget/customroundedappbar.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customRoundedAppBar(context, 'Go VIP'),
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
                    Text('Upgrade your recruiting experience', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Benefits of VIP subscription:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              _benefitItem(Icons.check_circle, 'Access premium candidate database'),
              _benefitItem(Icons.check_circle, 'Post unlimited job listings'),
              _benefitItem(Icons.check_circle, 'Priority candidate support'),
              _benefitItem(Icons.check_circle, 'Detailed analytics & reports'),
              const SizedBox(height: 32),
              Text('Choose your plan', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _planCard(context, 'Monthly', '\u002419.99', 'Billed monthly', Colors.indigoAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _planCard(context, 'Yearly', '\u0024199.99', 'Save 20% annually', Colors.amber)),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Colors.indigoAccent,
                    elevation: 6,
                  ),
                  child: const Text('Subscribe Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
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
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _planCard(BuildContext context, String title, String price, String subtitle, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
            SizedBox(height: 8),
            Text(price, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: color)),
            SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}
