import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/screens/postscreens/DescribeTheStall.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';

class StallImages extends StatefulWidget {
  String role;
  String name;
  String ownername;
  String contactnumber;
  StallImages(
      {super.key,
      required this.role,
      required this.name,
      required this.ownername,
      required this.contactnumber});

  @override
  State<StallImages> createState() => _StallImagesState();
}

class _StallImagesState extends State<StallImages> {
  TextEditingController _locationController = TextEditingController();
  String currentLocation = '';
  bool useCurrentLocation = false;
  bool isLoading = false;

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
      setState(() {
        currentLocation =
            'Lat: ${position.latitude}, Lng: ${position.longitude}';
        _locationController.text = currentLocation;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  final picker = ImagePicker();
  List<String?> imageUrls = [null, null, null];
  List<String?> menuImages = [];

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

  Future<void> _pickImage(int index, bool isMenu) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      isLoading = true;
    });
    if (pickedFile != null) {
      File image = File(pickedFile.path);

      String? imageUrl = await uploadImage(image);

      print("this is uploaded image url : ${imageUrl}");

      setState(() {
        if (!isMenu) {
          imageUrls[index] = imageUrl;
        } else {
          menuImages.add(imageUrl);
        }
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("this is printed from stallimage scree: ${widget.role + widget.name + widget.ownername + widget.contactnumber}");
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
                          margin: EdgeInsets.all(8),
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
                                    _pickImage(index, false);
                                  },
                                  child: Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              if (imageUrls[index] != null)
                              ClipRRect(
                                child: Image.network(
                                  height:MediaQuery.of(context).size.width * 0.24,
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  imageUrls[index]!,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                    setTitle("Uploaded Menu Images Images"),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.25,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
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
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.add_circle,
                                  size: 30,
                                  color: kprimaryColor,
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.width * 0.25,
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
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
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
                                  contactnumber: widget.contactnumber),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: EdgeInsets.all(15),
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
