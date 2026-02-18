import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/guru_location_model.dart';
import '../../data/repositories/location_repository.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/config/theme.dart';
import '../widgets/admin_header.dart'; // Import AdminHeader

/// Screen untuk admin melihat lokasi semua guru
class GuruLocationScreen extends StatefulWidget {
  const GuruLocationScreen({Key? key}) : super(key: key);

  @override
  State<GuruLocationScreen> createState() => _GuruLocationScreenState();
}

class _GuruLocationScreenState extends State<GuruLocationScreen> {
  final LocationRepository _repository = LocationRepository();
  final LocationService _locationService = LocationService();
  bool _showOnlineOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminHeader(
        title: 'Guru Locations',
        icon: Icons.location_on,
        additionalActions: [
           IconButton(
            icon: Icon(
              _showOnlineOnly ? Icons.visibility : Icons.visibility_off,
            ),
            tooltip: _showOnlineOnly ? 'Show All' : 'Show Online Only',
            onPressed: () {
              setState(() {
                _showOnlineOnly = !_showOnlineOnly;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<GuruLocation>>(
        stream: _showOnlineOnly
            ? _repository.getOnlineGuruLocations()
            : _repository.getAllGuruLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final locations = snapshot.data ?? [];

          if (locations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    _showOnlineOnly
                        ? 'No online guru found'
                        : 'No guru locations found',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return _buildLocationCard(location);
            },
          );
        },
      ),
    );
  }

  Widget _buildLocationCard(GuruLocation location) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLocationDetails(location),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Name + Status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: location.isOnline
                            ? AppTheme.accentGreen.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.person,
                        color: location.isOnline ? AppTheme.accentGreen : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location.guruName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: location.isOnline
                                      ? AppTheme.accentGreen
                                      : Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                location.isOnline ? 'Online' : 'Offline',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: location.isOnline
                                      ? AppTheme.accentGreen
                                      : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),
                // Location Info
                _buildInfoRow(
                  Icons.location_on,
                  'Coordinates',
                  location.coordinatesString,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  Icons.access_time,
                  'Last Update',
                  location.formattedTimestamp,
                ),
                if (location.accuracy != null) ...[
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    Icons.gps_fixed,
                    'Accuracy',
                    location.accuracy!.toUpperCase(),
                  ),
                ],
                const SizedBox(height: 16),
                // Google Maps Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _openInGoogleMaps(location.latitude, location.longitude),
                    icon: const Icon(Icons.map, size: 18),
                    label: const Text('Open in Google Maps'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.orange),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showLocationDetails(GuruLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                 color: Colors.orange.withOpacity(0.1),
                 borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.location_on, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(location.guruName)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Latitude', location.latitude.toStringAsFixed(6)),
            const SizedBox(height: 12),
            _buildDetailRow('Longitude', location.longitude.toStringAsFixed(6)),
            const SizedBox(height: 12),
            _buildDetailRow('Status', location.isOnline ? 'Online' : 'Offline'),
            const SizedBox(height: 12),
            _buildDetailRow('Last Update', location.formattedTimestamp),
            if (location.accuracy != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow('Accuracy', location.accuracy!.toUpperCase()),
            ],
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Actions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () =>
                        _openInGoogleMaps(location.latitude, location.longitude),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.map, color: Colors.blue),
                          SizedBox(height: 4),
                          Text(
                            'Maps',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () =>
                        _copyCoordinates(location.latitude, location.longitude),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.copy, color: Colors.grey),
                          SizedBox(height: 4),
                          Text(
                            'Copy',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Open location in Google Maps
  Future<void> _openInGoogleMaps(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Google Maps'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening maps: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Copy coordinates to clipboard
  Future<void> _copyCoordinates(double latitude, double longitude) async {
    final coordinates = '$latitude, $longitude';
    await Clipboard.setData(ClipboardData(text: coordinates));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Coordinates copied to clipboard'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
