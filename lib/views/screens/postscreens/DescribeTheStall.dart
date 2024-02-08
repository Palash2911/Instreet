import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/postscreens/PostScreenNav.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DescribeStallPage extends StatefulWidget {
  List<File> stallImagesList = [];
  List<File> menuImagesList = [];
  String location;
  String role;
  String name;
  String ownername;
  String contactnumber;
  String bannerImageUrl;
  String? sId;

  DescribeStallPage(
      {super.key,
      required this.stallImagesList,
      required this.menuImagesList,
      required this.location,
      required this.role,
      required this.name,
      required this.ownername,
      required this.contactnumber,
      required this.bannerImageUrl,
      this.sId});

  @override
  // ignore: library_private_types_in_public_api
  _DescribeStallPageState createState() => _DescribeStallPageState();
}

class _DescribeStallPageState extends State<DescribeStallPage> {
  TextEditingController _descriptionController = TextEditingController();

  final MultiSelectController _controller = MultiSelectController();

  List<dynamic> selectedCategories = [];

  List<String> allCategories = [
    'Books',
    'Electronics',
    'Clothes',
    'Art',
    'Toy',
    'Sport',
    'Saloon',
    'Jewelry',
    'Health',
    'Food',
    'Flowers',
    'Other'
  ];

  bool isSubmitting = false;

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
          _descriptionController.text = existingStall['stallDescription'];
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

  void _openAIDescriptionWidget() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AIDescriptionWidget();
      },
    );
  }

  Widget AIDescriptionWidget() {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create with AI',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: GradientBoxBorder(
                  width: 1,
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.blue, Colors.purple],
                  ),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                showCursor: true,
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                // here is one problem when u try to pop the dialog insted to poping the dialog the main screen is getting pop itself not dialog
                onTap: null,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.create,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Create",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: kprimaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setTitle(String title, bool isAI) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          (isAI)
              ? GestureDetector(
                  onTap: _openAIDescriptionWidget,
                  child: Icon(
                    Icons.edit,
                    size: 25,
                    color: kprimaryColor,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  /* Submit Stall Function*/
  Future<void> _submitStall() async {
    // if (widget.name.isEmpty ||
    //     selectedCategories.isEmpty || widget.location.isEmpty || widget.stallImagesList.isEmpty || widget.menuImagesList.isEmpty || widget.ownername.isEmpty || widget.contactnumber.isEmpty || widget.location.isEmpty) {
    //   showToast("Please fill in all required fields.");
    //   return;
    // }

    setState(() {
      isSubmitting = true;
    });

    var stallProvider = Provider.of<StallProvider>(context, listen: false);

    var authId = Provider.of<Auth>(context, listen: false).token;

    try {
      await stallProvider.addStall(
        Stall(
          sId: "",
          stallName: widget.name,
          ownerName: widget.ownername,
          rating: 0.0,
          stallCategories: selectedCategories,
          stallDescription: _descriptionController.text,
          bannerImageUrl: widget.bannerImageUrl,
          favoriteUsers: [],
          ownerContact: widget.contactnumber,
          location: widget.location,
          stallImages: [],
          menuImages: [],
          creatorUID: authId,
        ),
        widget.stallImagesList,
        widget.menuImagesList,
      );

      Fluttertoast.showToast(
        msg: "Stall Added successfully",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PostScreenNav()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (error) {
      print("Error submitting stall: $error");

      Fluttertoast.showToast(
        msg: "Error Adding Stall. Please try again !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 10.0,
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Future<void> _updateStall() async {
    if (widget.sId == null) {
      return;
    }
    if (widget.name.isEmpty ||
        widget.bannerImageUrl.isEmpty ||
        selectedCategories.isEmpty ||
        widget.location.isEmpty ||
        widget.stallImagesList.isEmpty ||
        widget.menuImagesList.isEmpty ||
        widget.ownername.isEmpty ||
        widget.contactnumber.isEmpty ||
        widget.location.isEmpty) {
      showToast("Please fill in all required fields.");
      return; // Stop execution if any field is empty
    }

    setState(() {
      isSubmitting = true;
    });

    var stallProvider = Provider.of<StallProvider>(context, listen: false);

    try {
      await stallProvider.updateStall(Stall(
        sId: widget.sId.toString(),
        stallName: widget.name,
        ownerName: widget.ownername,
        rating: 0.0,
        stallCategories: selectedCategories,
        stallDescription: _descriptionController.text,
        bannerImageUrl: widget.bannerImageUrl,
        favoriteUsers: [],
        ownerContact: widget.contactnumber,
        location: widget.location,
        stallImages: widget.stallImagesList,
        menuImages: widget.menuImagesList,
        creatorUID: Provider.of<Auth>(context, listen: false).token,
      ));

      Fluttertoast.showToast(
        msg: "Stall Updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PostScreenNav(),
        ),
      );
    } catch (error) {
      print("Error updating stall: $error");

      Fluttertoast.showToast(
        msg: "Error Updating Stall. Please try again !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
                    /*Stall description start */
                    setTitle("Describe the Stall", true),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: kprimaryColor, width: 1.0),
                        ),
                        labelText: 'Describe The Stall....',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Text(
                          'Around 100 words',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    setTitle("Stall Category", false),
                    MultiSelectDropDown(
                      controller: _controller,
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        setState(() {
                          selectedCategories = selectedOptions
                              .map((option) => option.value as String)
                              .toList();
                        });
                      },
                      options: allCategories.map((category) {
                        return ValueItem(
                          label: category.toString(),
                          value: category.toString(),
                        );
                      }).toList(),
                      selectionType: SelectionType.multi,
                      chipConfig: ChipConfig(
                          wrapType: WrapType.scroll,
                          backgroundColor: kprimaryColor),
                      dropdownHeight: 300,
                      optionTextStyle: const TextStyle(fontSize: 16),
                      selectedOptionIcon: const Icon(Icons.check_circle),
                      selectedOptionTextColor: kprimaryColor,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: isSubmitting
                            ? null
                            : (widget.sId != null
                                ? _updateStall
                                : _submitStall),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: kprimaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isSubmitting
                                    ? "Submitting..."
                                    : (widget.sId != null
                                        ? "Update Stall"
                                        : "Submit Stall"),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              if (isSubmitting)
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                              else
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
