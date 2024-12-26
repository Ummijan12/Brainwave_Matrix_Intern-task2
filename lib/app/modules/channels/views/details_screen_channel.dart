import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/sources_model.dart';

class SourceDetailsScreen extends StatelessWidget {
  final SourceModel source;

  const SourceDetailsScreen({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                source.name ?? 'Source Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Lottie.asset('assets/1735148202050.json'),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDetailCard(),
                SizedBox(height: 16),
                _buildInfoSection(),
                SizedBox(height: 16),
                _buildActionButtons(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getSourceImage() {
    return source.url ?? 'https://via.placeholder.com/350x250';
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              source.description ?? 'No description available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(
              icon: Icons.category,
              label: 'Category',
              value: source.category ?? 'Not specified',
            ),
            Divider(),
            _buildInfoRow(
              icon: Icons.language,
              label: 'Language',
              value: source.language ?? 'Not specified',
            ),
            Divider(),
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Country',
              value: source.country ?? 'Not specified',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareSource() {
    Share.share(
      'Check out this news source: ${source.name}\n\nVisit: ${source.url}',
      subject: source.name,
    );
  }

  Future<void> _launchSourceInAppBrowser() async {
    if (source.url == null || source.url!.isEmpty) {
      Get.snackbar(
        'Error',
        'No URL available for this source',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final Uri uri = Uri.parse(source.url!);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not launch source URL',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while launching URL',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: _launchSourceInAppBrowser,
          icon: Icon(
            Icons.open_in_browser,
            color: Colors.white,
          ),
          label: Text(
            'Visit Source',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _shareSource,
          icon: Icon(Icons.share),
          label: Text('Share'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
