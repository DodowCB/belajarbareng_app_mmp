import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/guru_location_model.dart';
import '../../data/repositories/location_repository.dart';
import '../../../../core/services/location_service.dart';

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
      appBar: AppBar(
        title: const Text('Guru Locations'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
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
            padding: const EdgeInsets.all(16),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showLocationDetails(location),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name + Status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: location.isOnline
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person,
                      color: location.isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.guruName,
                          style: const TextStyle(
                            fontSize: 16,
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
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              location.isOnline ? 'Online' : 'Offline',
                              style: TextStyle(
                                fontSize: 12,
                                color: location.isOnline
                                    ? Colors.green
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
              const Divider(height: 24),
              // Location Info
              _buildInfoRow(
                Icons.location_on,
                'Coordinates',
                location.coordinatesString,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.access_time,
                'Last Update',
                location.formattedTimestamp,
              ),
              if (location.accuracy != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.gps_fixed,
                  'Accuracy',
                  location.accuracy!.toUpperCase(),
                ),
              ],
              const SizedBox(height: 12),
              // Google Maps Button
              ElevatedButton.icon(
                onPressed: () =>
                    _openInGoogleMaps(location.latitude, location.longitude),
                icon: const Icon(Icons.map, size: 16),
                label: const Text('Open in Google Maps'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
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
            style: const TextStyle(fontSize: 13),
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
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(child: Text(location.guruName)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Latitude', location.latitude.toStringAsFixed(6)),
            const SizedBox(height: 8),
            _buildDetailRow('Longitude', location.longitude.toStringAsFixed(6)),
            const SizedBox(height: 8),
            _buildDetailRow('Status', location.isOnline ? 'Online' : 'Offline'),
            const SizedBox(height: 8),
            _buildDetailRow('Last Update', location.formattedTimestamp),
            if (location.accuracy != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow('Accuracy', location.accuracy!.toUpperCase()),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Google Maps Link:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () =>
                  _openInGoogleMaps(location.latitude, location.longitude),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.map, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Open in Maps',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Copy Coordinates Button
            InkWell(
              onTap: () =>
                  _copyCoordinates(location.latitude, location.longitude),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.copy, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text(
                      'Copy Coordinates',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
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
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
