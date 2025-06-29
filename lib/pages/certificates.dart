import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificatesSection extends StatelessWidget {
  final List<Map<String, String>> certificates = [
    {
      'title': 'Account Management 1&2',
      'issuer': 'MyForexFunds',
      'date': 'Jun 2022',
      'image': 'assets/images/myforexfunds_stage1_2.jpg',
      'link':
          'https://drive.google.com/file/d/156zTGXkaO_88Tepb7uX_eFOt1TiJp8NR/view',
    },
    {
      'title': 'Account Management Stage 1',
      'issuer': 'FundingPips',
      'date': 'Apr 2024',
      'image': 'assets/images/fundingpips_stage1.png',
      'link':
          'https://app.fundingpips.com/certificates/verify/363f0140-6b61-4d49-81cd-43ada36850c3',
    },
    {
      'title': 'Account Management Stage 2',
      'issuer': 'FundingPips',
      'date': 'Jul 2024',
      'image': 'assets/images/fundingpips_stage2.png',
      'link':
          'https://app.fundingpips.com/certificates/verify/893a6efb-2afb-4bf4-a502-d358afd74f87',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Certificates',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount =
                    constraints.maxWidth > 900
                        ? 3
                        : constraints.maxWidth > 600
                        ? 2
                        : 1;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: certificates.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 3 / 2,
                  ),
                  itemBuilder: (context, index) {
                    final cert = certificates[index];
                    return CertificateCard(cert: cert);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateCard extends StatelessWidget {
  final Map<String, String> cert;

  const CertificateCard({required this.cert});

  void _launchLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLink = cert.containsKey('link') && cert['link']!.isNotEmpty;

    Widget cardContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (cert['image'] != null)
          Expanded(child: Image.asset(cert['image']!, fit: BoxFit.contain)),
        const SizedBox(height: 8),
        Text(
          cert['title'] ?? '',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${cert['issuer']} • Issued ${cert['date']}',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: InkWell(
          onTap: hasLink ? () => _launchLink(cert['link']!) : null,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: cardContent,
          ),
        ),
      ),
    );
  }
}
