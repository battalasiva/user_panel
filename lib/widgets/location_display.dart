import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:user_panel/core/constants/colors.dart';
import 'package:user_panel/core/constants/text_styles.dart';

class LocationDisplay extends StatefulWidget {
  const LocationDisplay({super.key});

  @override
  State<LocationDisplay> createState() => _LocationDisplayState();
}

class _LocationDisplayState extends State<LocationDisplay> {
  String _fetchedLocation = "Fetching location...";
  String _userEnteredText = "";
  bool _isManualLocationEntered = false;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _fetchedLocation = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _fetchedLocation = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _fetchedLocation = "Location permissions denied.";
      });
      if (!_isManualLocationEntered) {
        await _manualEnterLocation();
      }
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude = position.latitude;
    _longitude = position.longitude;

    await _getAddressFromCoordinates(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    setState(() {
      _fetchedLocation = "${place.locality}, ${place.administrativeArea}";
    });
  }

  Future<void> _manualEnterLocation() async {
    String tempLocation = '';
    final TextEditingController _controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(
            builder: (context, setState) {
              String? errorText;

              return AlertDialog(
                backgroundColor: AppColor.white,
                title: Text(
                  'Enter Your Pincode or Address',
                  style: txt_14_500.copyWith(color: AppColor.black1),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller,
                      onChanged: (value) {
                        tempLocation = value;
                        if (errorText != null) {
                          setState(() {
                            errorText = null;
                          });
                        }
                      },
                      style: TextStyle(color: AppColor.black),
                      decoration: InputDecoration(
                        hintText: 'Enter Pincode or City Name',
                        hintStyle: TextStyle(color: AppColor.grey),
                        errorText: errorText,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColor.black, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColor.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor1,
                    ),
                    onPressed: () {
                      if (tempLocation.trim().isEmpty) {
                        setState(() {
                          errorText = "Please enter a location!";
                        });
                      } else {
                        Navigator.pop(context, tempLocation);
                      }
                    },
                    child: Text(
                      'Find',
                      style: TextStyle(color: AppColor.white),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      _userEnteredText = result.trim();
      _isManualLocationEntered = true;
      await _getLocationFromAddress(result.trim());
    }
  }

  Future<void> _getLocationFromAddress(String inputAddress) async {
    try {
      List<Location> locations = await locationFromAddress(inputAddress);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        _latitude = location.latitude;
        _longitude = location.longitude;

        await _getAddressFromCoordinates(_latitude!, _longitude!);
      } else {
        setState(() {
          _fetchedLocation = "Location not found.";
        });
      }
    } catch (e) {
      setState(() {
        _fetchedLocation = "Error finding location.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: AppColor.black),
            const SizedBox(width: 5),
            SizedBox(
              child: Text(
                _fetchedLocation.isEmpty
                    ? _userEnteredText
                    : '$_userEnteredText $_fetchedLocation',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColor.black, fontSize: 15),
              ),
            ),
          ],
        ),
        if (_latitude != null && _longitude != null)
          Padding(
            padding:  EdgeInsets.all(5),
            child: Text(
              'Latitude: ${_latitude!.toStringAsFixed(4)},\nLongitude: ${_longitude!.toStringAsFixed(4)}',
              style: TextStyle(color: AppColor.black, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

