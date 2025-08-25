import 'package:flutter/material.dart';

class CompanyProfilePage extends StatelessWidget {
  const CompanyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data
    const companyName = 'Acme Corporation';
    const companyAddress = '123 Main Street, City, Country';
    const companyBranch = '456 Branch Ave, City, Country';
    const companyLength = '10 years';
    const companyWebsite = 'https://www.acme.com';
    const companySocial = 'https://linkedin.com/company/acme';
    const companyServices = ['Consulting', 'Development', 'Support'];
    const subscriptionStatus = 'Active';
    const subscriptionPricing = '₹999/year';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        title: const Text('Company Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for user photo and company logo with text and edit icon at the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // User Photo Column
                Column(
                  children: [
                    const Text('Your Photo', style: TextStyle(fontWeight: FontWeight.bold)),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.indigo,
                          child: Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit, size: 18, color: Colors.indigo),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Company Logo Column
                Column(
                  children: [
                    const Text('Company Logo', style: TextStyle(fontWeight: FontWeight.bold)),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.business, size: 40, color: Colors.white),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit, size: 18, color: Colors.indigo),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Company Name
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Company Name'),
              subtitle: Text(companyName),
            ),
            // Company Address
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Company Address'),
              subtitle: Text(companyAddress),
            ),
            // Company Branch Address
            ListTile(
              leading: const Icon(Icons.account_tree),
              title: const Text('Company Branch Address'),
              subtitle: Text(companyBranch),
            ),
            // Company Length
            ListTile(
              leading: const Icon(Icons.timelapse),
              title: const Text('Company Length'),
              subtitle: Text(companyLength),
            ),
            // Company Services
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Company Services', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Wrap(
              spacing: 8,
              children: companyServices.map((service) => Chip(label: Text(service))).toList(),
            ),
            const SizedBox(height: 16),
            // Company Website
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Company Website'),
              subtitle: Text(companyWebsite),
            ),
            // Company Social Media Links
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Company Social Media Links'),
              subtitle: Text(companySocial),
            ),
            const SizedBox(height: 24),
            // Subscription display
            Card(
              color: subscriptionStatus == 'Active'
                  ? Colors.green[50]
                  : subscriptionStatus == 'Ended'
                      ? Colors.red[50]
                      : Colors.orange[50],
              child: ListTile(
                leading: Icon(
                  subscriptionStatus == 'Active'
                      ? Icons.check_circle
                      : subscriptionStatus == 'Ended'
                          ? Icons.cancel
                          : Icons.warning,
                  color: subscriptionStatus == 'Active'
                      ? Colors.green
                      : subscriptionStatus == 'Ended'
                          ? Colors.red
                          : Colors.orange,
                ),
                title: Text('Subscription: $subscriptionStatus'),
                subtitle: Text('Pricing: $subscriptionPricing'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: Text(subscriptionStatus == 'Active' ? 'Renew' : 'Purchase'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
