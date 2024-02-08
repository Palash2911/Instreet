import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
  String ownername;
  String contactnumber;
  String? sId;
  StallImages(
      {super.key,
      required this.role,
      required this.name,
      required this.ownername,
      required this.contactnumber,
      this.sId});

  @override
  State<StallImages> createState() => _StallImagesState();
}

class _StallImagesState extends State<StallImages> {
  TextEditingController _locationController = TextEditingController();
  String currentLocation = '';
  bool useCurrentLocation = false;
  bool isLoading = false;
  String? bannerImageUrl;
  final picker = ImagePicker();
  List<String?> imageUrls = [null, null, null];
  List<String?> menuImages = [];

  // Function to remove an image at a specific index
  void _removeImage(int index, bool isStall, bool isMenu, bool isBanner) {
    setState(() {
      // if (!isMenu) {
      //   imageUrls[index] = null;
      // } else {
      //   menuImages.removeAt(index);
      // }
      // if (isBanner) {
      //   bannerImageUrl = null;
      // }

      if (isBanner) {
        bannerImageUrl = null;
      } else {
        if (!isMenu) {
          imageUrls[index] = null;
        } else {
          menuImages.removeAt(index);
        }
      }
    });
  }

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
            imageUrls = List<String?>.from(existingStall['stallImages']);
          }

          // Handle menuImages
          if (existingStall['menuImages'] is List<dynamic>) {
            menuImages = List<String?>.from(existingStall['menuImages']);
          }

          // Handle bannerImageUrl
          bannerImageUrl = existingStall['bannerImage'];
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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Request location services if not enabled
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

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permissions
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

  Future<String?> uploadImage(File image) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Stalls/${DateTime.now().millisecondsSinceEpoch}.png');

      firebase_storage.UploadTask uploadTask = ref.putFile(image);
      firebase_storage.TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadURL = await storageTaskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error uploading image",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  Future<void> _pickImage(
      int index, bool isStall, bool isMenu, bool isBanner) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromSource(
                      index, isStall, isMenu, isBanner, ImageSource.camera);
                },
              ),
              ListTile(
                title: Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _getImageFromSource(
                      index, isStall, isMenu, isBanner, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImageFromSource(int index, bool isStall, bool isMenu,
      bool isBanner, ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      isLoading = true;
    });

    if (pickedFile == null) {
      // User canceled the image picking
      setState(() {
        isLoading = false;
      });
      return;
    }

    File image = File(pickedFile.path);
    String? imageUrl = await uploadImage(image);

    if (imageUrl == null) {
      // Handle the case when image upload fails
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Handle the case when image upload is successful
    print("this is uploaded image url: $imageUrl");

    setState(() {
      if (isBanner) {
        bannerImageUrl = imageUrl;
        isLoading = false;
        return;
      }

      if (!isMenu) {
        imageUrls[index] = imageUrl;
      } else {
        menuImages.add(imageUrl);
      }

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        "this is printed from stallimage scree: ${widget.role + widget.name + widget.ownername + widget.contactnumber}");

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (index) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.width * 0.25,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (imageUrls[index] == null)
                                ? Colors.grey
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: (imageUrls[index] == null)
                                  ? Colors.transparent
                                  : Colors.black,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (imageUrls[index] == null)
                                GestureDetector(
                                  onTap: () {
                                    _pickImage(index, true, false, false);
                                  },
                                  child: const Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              if (imageUrls[index] != null)
                                Stack(
                                  children: [
                                    ClipRRect(
                                      child: Image.network(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.24,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        imageUrls[index]!,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          _removeImage(
                                              index, true, false, false);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4),
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
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                    setTitle("Upload Stall Banner"),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.40,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (bannerImageUrl == null)
                            GestureDetector(
                              onTap: () {
                                _pickImage(0, false, false, true);
                              },
                              child: Icon(
                                Icons.add_circle,
                                size: 30,
                                color: kprimaryColor,
                              ),
                            ),
                          if (bannerImageUrl != null)
                            Stack(
                              children: [
                                ClipRRect(
                                  child: Image.network(
                                    height: MediaQuery.of(context).size.width *
                                        0.39,
                                    width: MediaQuery.of(context).size.width,
                                    bannerImageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      _removeImage(0, false, false, true);
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
                            ),
                        ],
                      ),
                    ),
                    setTitle("Upload Menu Images"),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.25,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: menuImages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == menuImages.length) {
                            return GestureDetector(
                              onTap: () {
                                _pickImage(index, false, true, false);
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
                                    child: Image.network(
                                      menuImages[index]!,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      _removeImage(index, false, true, false);
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
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DescribeStallPage(
                                  stallImagesList: imageUrls,
                                  menuImagesList: menuImages,
                                  location: currentLocation,
                                  role: widget.role,
                                  name: widget.name,
                                  ownername: widget.ownername,
                                  contactnumber: widget.contactnumber,
                                  bannerImageUrl: bannerImageUrl.toString(),
                                  sId: widget.sId),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Next",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: kprimaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    )
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
