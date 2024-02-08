import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/postscreens/DescribeTheStall.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class StallImages extends StatefulWidget {
  String role;
  String name;
  String ownerName;
  String contactNumber;
  String? sId;
  StallImages(
      {super.key,
      required this.role,
      required this.name,
      required this.ownerName,
      required this.contactNumber,
      this.sId});

  @override
  State<StallImages> createState() => _StallImagesState();
}

class _StallImagesState extends State<StallImages> {
  final TextEditingController _locationController = TextEditingController();
  String currentLocation = '';

  bool useCurrentLocation = false;
  bool isLoading = false;
  List<File> stallImages = [];
  List<File> menuImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.sId != null) {
      fetchStallDetails();
    }
  }

  Future<void> fetchStallDetails() async {
    try {
      var existingStall =
          await Provider.of<StallProvider>(context, listen: false)
              .getStall(widget.sId!);

      if (existingStall != null) {
        setState(() {
          _locationController.text = existingStall['location'];
          currentLocation = existingStall['location'];
          isLoading = false;

          // Handle stallImages
          if (existingStall['stallImages'] is List<dynamic>) {
            // imageUrls = List<String>.from(existingStall['stallImages']);
          }

          // Handle menuImages
          if (existingStall['menuImages'] is List<dynamic>) {
            // menuImages = List<String>.from(existingStall['menuImages']);
          }
        });
      } else {
        Fluttertoast.showToast(
          msg:
              "Error while fetching stall details, please fill in the blank spaces",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg:
            "Error while fetching stall details, please fill in the blank spaces",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Widget setTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 11),
      child: Text(
        title,
        style: kTextPopM16,
      ),
    );
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        Fluttertoast.showToast(
          msg: "Enable Location",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    try {
      setState(() {
        isLoading = true;
      });
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;

        setState(() {
          String address =
              "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ";
          currentLocation = address ?? 'Unknown Address';
          _locationController.text = currentLocation;
          isLoading = false;
        });
      } else {
        setState(() {
          currentLocation = 'Unknown Address';
          _locationController.text = currentLocation;
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage(int index, bool isMenu) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  "Camera",
                  style: kTextPopR16,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromSource(index, isMenu, ImageSource.camera);
                },
              ),
              ListTile(
                title: Text(
                  "Gallery",
                  style: kTextPopR16,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromSource(index, isMenu, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImageFromSource(
      int index, bool isMenu, ImageSource source) async {
    var pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      isLoading = true;
    });

    if (pickedFile == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    File image = File(pickedFile.path);

    setState(() {
      if (!isMenu) {
        stallImages.add(image);
      } else {
        menuImages.add(image);
      }
      isLoading = false;
    });
  }

  void _removeImage(int index, bool isMenu) {
    setState(() {
      if (!isMenu) {
        stallImages.removeAt(index);
      } else {
        menuImages.removeAt(index);
      }
    });
  }

  void _shiftPage() {
    if (currentLocation.isNotEmpty ||
        menuImages.isNotEmpty ||
        stallImages.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DescribeStallPage(
            stallImagesList: stallImages,
            menuImagesList: menuImages,
            location: currentLocation,
            role: widget.role,
            name: widget.name,
            ownername: widget.ownerName,
            contactnumber: widget.contactNumber,
            bannerImageUrl: '',
            sId: widget.sId,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Please Fill All Fields !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        isSearch: false,
        screenTitle: 'My Posts',
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    setTitle("Location"),
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: "Enter stall location",
                        hintStyle: kTextPopR14,
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.white,
                          checkColor: kprimaryColor,
                          value: useCurrentLocation,
                          onChanged: (value) {
                            setState(() {
                              useCurrentLocation = value!;
                              if (useCurrentLocation) {
                                _getLocation();
                              } else {
                                _locationController.clear();
                              }
                            });
                          },
                        ),
                        const Text('Use My Current Location'),
                      ],
                    ),
                    setTitle("Upload Stall Images"),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: stallImages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == stallImages.length) {
                            return GestureDetector(
                              onTap: () {
                                _pickImage(index, false);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add_circle,
                                  size: 30,
                                  color: kprimaryColor,
                                ),
                              ),
                            );
                          } else {
                            return Stack(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height:
                                      MediaQuery.of(context).size.width * 0.25,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      stallImages[index]!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      _removeImage(index, false);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kprimaryColor,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    setTitle("Upload Menu Images"),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: menuImages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == menuImages.length) {
                            return GestureDetector(
                              onTap: () {
                                _pickImage(index, true);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Icon(
                                  Icons.add_circle,
                                  size: 30,
                                  color: kprimaryColor,
                                ),
                              ),
                            );
                          } else {
                            return Stack(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height:
                                      MediaQuery.of(context).size.width * 0.25,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      menuImages[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      _removeImage(index, true);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kprimaryColor,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: _shiftPage,
                        child: Opacity(
                          opacity: currentLocation.isNotEmpty ||
                                  menuImages.isNotEmpty ||
                                  stallImages.isNotEmpty
                              ? 1
                              : 0.7,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: kprimaryColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Next",
                              textAlign: TextAlign.center,
                              style: kTextPopM16.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
