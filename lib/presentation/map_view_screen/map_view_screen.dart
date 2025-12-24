import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/issue_preview_card.dart';
import './widgets/map_controls_widget.dart';
import './widgets/map_filter_bottom_sheet.dart';
import './widgets/map_search_bar.dart';
import './widgets/nearby_issues_bottom_sheet.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLocationLoading = false;
  bool _showReportButton = false;
  LatLng? _longPressLocation;
  String _currentMapType = 'standard';
  Map<String, dynamic>? _selectedIssue;

  // Filter state
  Map<String, dynamic> _currentFilters = {
    'categories': <String>[],
    'statuses': <String>[],
    'priorities': <String>[],
    'startDate': null,
    'endDate': null,
  };

  // Mock issues data
  final List<Map<String, dynamic>> _allIssues = [
    {
      'id': '2024001',
      'title': 'Pothole on Main Street',
      'description':
          'Large pothole causing traffic issues and potential vehicle damage. Located near the intersection with Oak Avenue.',
      'category': 'road',
      'status': 'pending',
      'priority': 'high',
      'location': 'Main Street, Downtown',
      'latitude': 37.7849,
      'longitude': -122.4094,
      'imageUrl':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'reportedBy': 'John Smith',
      'distance': 150,
    },
    {
      'id': '2024002',
      'title': 'Broken Street Light',
      'description':
          'Street light has been out for several days, creating safety concerns for pedestrians during evening hours.',
      'category': 'electricity',
      'status': 'in_progress',
      'priority': 'medium',
      'location': 'Park Avenue & 5th Street',
      'latitude': 37.7849,
      'longitude': -122.4074,
      'imageUrl':
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'reportedBy': 'Sarah Johnson',
      'distance': 280,
    },
    {
      'id': '2024003',
      'title': 'Water Leak in Park',
      'description':
          'Continuous water leak from underground pipe creating muddy conditions and water waste in Central Park.',
      'category': 'water',
      'status': 'resolved',
      'priority': 'high',
      'location': 'Central Park, North Section',
      'latitude': 37.7869,
      'longitude': -122.4084,
      'imageUrl':
          'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400',
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      'reportedBy': 'Mike Davis',
      'distance': 420,
    },
    {
      'id': '2024004',
      'title': 'Overflowing Trash Bins',
      'description':
          'Multiple trash bins overflowing near the bus stop, attracting pests and creating unsanitary conditions.',
      'category': 'waste',
      'status': 'pending',
      'priority': 'medium',
      'location': 'Bus Stop - Market Street',
      'latitude': 37.7829,
      'longitude': -122.4064,
      'imageUrl':
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400',
      'createdAt': DateTime.now().subtract(const Duration(hours: 6)),
      'reportedBy': 'Lisa Wilson',
      'distance': 320,
    },
    {
      'id': '2024005',
      'title': 'Broken Playground Equipment',
      'description':
          'Swing set chains are broken and pose safety risk to children. Immediate attention required.',
      'category': 'parks',
      'status': 'in_progress',
      'priority': 'critical',
      'location': 'Community Park Playground',
      'latitude': 37.7889,
      'longitude': -122.4104,
      'imageUrl':
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      'createdAt': DateTime.now().subtract(const Duration(hours: 12)),
      'reportedBy': 'David Brown',
      'distance': 180,
    },
    {
      'id': '2024006',
      'title': 'Suspicious Activity Report',
      'description':
          'Unusual activity reported near the community center during late evening hours. Increased patrol requested.',
      'category': 'public_safety',
      'status': 'pending',
      'priority': 'high',
      'location': 'Community Center Parking',
      'latitude': 37.7809,
      'longitude': -122.4054,
      'imageUrl':
          'https://images.unsplash.com/photo-1557804506-669a67965ba0?w=400',
      'createdAt': DateTime.now().subtract(const Duration(hours: 8)),
      'reportedBy': 'Emma Taylor',
      'distance': 450,
    },
  ];

  Set<Marker> _markers = {};
  List<Map<String, dynamic>> _filteredIssues = [];
  List<Map<String, dynamic>> _nearbyIssues = [];

  @override
  void initState() {
    super.initState();
    _filteredIssues = List.from(_allIssues);
    _getCurrentLocation();
    _createMarkers();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      if (!kIsWeb) {
        final permission = await Permission.location.request();
        if (!permission.isGranted) {
          setState(() {
            _isLocationLoading = false;
          });
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLocationLoading = false;
      });

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            16.0,
          ),
        );
      }

      _updateNearbyIssues();
    } catch (e) {
      setState(() {
        _isLocationLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to get current location'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _createMarkers() {
    final Set<Marker> markers = {};

    for (final issue in _filteredIssues) {
      markers.add(
        Marker(
          markerId: MarkerId(issue['id']),
          position: LatLng(issue['latitude'], issue['longitude']),
          onTap: () => _onMarkerTapped(issue),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerColor(issue['category']),
          ),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  double _getMarkerColor(String category) {
    switch (category) {
      case 'road':
        return BitmapDescriptor.hueRed;
      case 'water':
        return BitmapDescriptor.hueBlue;
      case 'electricity':
        return BitmapDescriptor.hueOrange;
      case 'waste':
        return BitmapDescriptor.hueGreen;
      case 'public_safety':
        return BitmapDescriptor.hueViolet;
      case 'parks':
        return BitmapDescriptor.hueCyan;
      default:
        return BitmapDescriptor.hueRed;
    }
  }

  void _onMarkerTapped(Map<String, dynamic> issue) {
    setState(() {
      _selectedIssue = issue;
    });
  }

  void _onMapLongPress(LatLng position) {
    setState(() {
      _longPressLocation = position;
      _showReportButton = true;
    });

    // Hide the button after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showReportButton = false;
        });
      }
    });
  }

  void _onReportIssueHere() {
    if (_longPressLocation != null) {
      Navigator.pushNamed(
        context,
        '/report-issue-screen',
        arguments: {
          'latitude': _longPressLocation!.latitude,
          'longitude': _longPressLocation!.longitude,
        },
      );
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredIssues = List.from(_allIssues);
      });
    } else {
      setState(() {
        _filteredIssues = _allIssues.where((issue) {
          return issue['title'].toLowerCase().contains(query.toLowerCase()) ||
              issue['location'].toLowerCase().contains(query.toLowerCase()) ||
              issue['description'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
    _createMarkers();
    _updateNearbyIssues();
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _filteredIssues = _allIssues.where((issue) {
        // Category filter
        final categories = filters['categories'] as List<String>;
        if (categories.isNotEmpty && !categories.contains(issue['category'])) {
          return false;
        }

        // Status filter
        final statuses = filters['statuses'] as List<String>;
        if (statuses.isNotEmpty && !statuses.contains(issue['status'])) {
          return false;
        }

        // Priority filter
        final priorities = filters['priorities'] as List<String>;
        if (priorities.isNotEmpty && !priorities.contains(issue['priority'])) {
          return false;
        }

        // Date range filter
        final startDate = filters['startDate'] as DateTime?;
        final endDate = filters['endDate'] as DateTime?;
        final issueDate = issue['createdAt'] as DateTime;

        if (startDate != null && issueDate.isBefore(startDate)) {
          return false;
        }
        if (endDate != null &&
            issueDate.isAfter(endDate.add(const Duration(days: 1)))) {
          return false;
        }

        return true;
      }).toList();
    });
    _createMarkers();
    _updateNearbyIssues();
  }

  void _updateNearbyIssues() {
    if (_currentPosition == null) return;

    final nearby = _filteredIssues.where((issue) {
      final distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        issue['latitude'],
        issue['longitude'],
      );
      return distance <= 1000; // Within 1km
    }).toList();

    // Sort by distance
    nearby.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        a['latitude'],
        a['longitude'],
      );
      final distanceB = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        b['latitude'],
        b['longitude'],
      );
      return distanceA.compareTo(distanceB);
    });

    setState(() {
      _nearbyIssues = nearby;
    });
  }

  void _toggleMapType() {
    setState(() {
      switch (_currentMapType) {
        case 'standard':
          _currentMapType = 'satellite';
          break;
        case 'satellite':
          _currentMapType = 'traffic';
          break;
        case 'traffic':
          _currentMapType = 'terrain';
          break;
        case 'terrain':
          _currentMapType = 'standard';
          break;
      }
    });
  }

  MapType _getMapType() {
    switch (_currentMapType) {
      case 'satellite':
        return MapType.satellite;
      case 'terrain':
        return MapType.terrain;
      case 'traffic':
        return MapType.normal;
      default:
        return MapType.normal;
    }
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar.mapView(context),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              if (_currentPosition != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(_currentPosition!.latitude,
                        _currentPosition!.longitude),
                    14.0,
                  ),
                );
              }
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7849, -122.4094), // San Francisco
              zoom: 12.0,
            ),
            markers: _markers,
            mapType: _getMapType(),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onLongPress: _onMapLongPress,
            onTap: (_) {
              setState(() {
                _selectedIssue = null;
                _showReportButton = false;
              });
            },
            trafficEnabled: _currentMapType == 'traffic',
          ),

          // Search bar
          MapSearchBar(
            onSearch: _onSearchChanged,
            onFilterTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SizedBox(
                  height: 80.h,
                  child: MapFilterBottomSheet(
                    currentFilters: _currentFilters,
                    onFiltersChanged: _onFiltersChanged,
                  ),
                ),
              );
            },
          ),

          // Map controls
          MapControlsWidget(
            onMyLocationPressed: _getCurrentLocation,
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onLayerToggle: _toggleMapType,
            currentLayer: _currentMapType,
            isLocationLoading: _isLocationLoading,
          ),

          // Report issue here button
          ReportIssueHereButton(
            onPressed: _onReportIssueHere,
            isVisible: _showReportButton,
          ),

          // Issue preview card
          if (_selectedIssue != null)
            Positioned(
              bottom: 25.h,
              left: 0,
              right: 0,
              child: IssuePreviewCard(
                issue: _selectedIssue!,
                onViewDetails: () {
                  Navigator.pushNamed(
                    context,
                    '/issue-detail-screen',
                    arguments: _selectedIssue,
                  );
                },
                onClose: () {
                  setState(() {
                    _selectedIssue = null;
                  });
                },
              ),
            ),

          // Nearby issues bottom sheet
          if (_selectedIssue == null)
            NearbyIssuesBottomSheet(
              nearbyIssues: _nearbyIssues,
              onIssueSelected: (issue) {
                setState(() {
                  _selectedIssue = issue;
                });
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(issue['latitude'], issue['longitude']),
                    16.0,
                  ),
                );
              },
              onViewAllIssues: () {
                Navigator.pushNamed(context, '/home-dashboard');
              },
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
