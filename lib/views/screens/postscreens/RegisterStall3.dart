import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RegisterStall3 extends StatefulWidget {
  final List<dynamic> stallImagesList;
  final List<dynamic> menuImagesList;
  final String location;
  final String role;
  final String name;
  final String ownerName;
  final String contactNumber;
  final String? sId;

  const RegisterStall3(
      {super.key,
      required this.stallImagesList,
      required this.menuImagesList,
      required this.location,
      required this.role,
      required this.name,
      required this.ownerName,
      required this.contactNumber,
      this.sId});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterStall3State createState() => _RegisterStall3State();
}

class _RegisterStall3State extends State<RegisterStall3> {

  TextEditingController _descriptionController = TextEditingController();

  final MultiSelectController _controller = MultiSelectController();

  TextEditingController _aiContoller = TextEditingController();

  bool _isFetchingData = false;

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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.sId != null) {
      fetchStallDetails();
    }
  }

  Future<void> fetchStallDetails() async {
    try {
      var authToken = Provider.of<Auth>(context, listen: false).token;
      Stall existingStall = Provider.of<StallProvider>(context, listen: false)
          .getUserRegisteredStalls(authToken)
          .firstWhere((stall) => stall.sId == widget.sId);

      _controller.setOptions(allCategories
          .map((category) => ValueItem<dynamic>(
                label: category.toString(),
                value: category,
              ))
          .toList());

      selectedCategories = existingStall.stallCategories;
      var selectedOptions = selectedCategories
          .map((category) => ValueItem<dynamic>(
                label: category.toString(),
                value: category,
              ))
          .toList();

      setState(() {
        _descriptionController.text = existingStall.stallDescription;
        _controller.clearAllSelection();
        _controller.setSelectedOptions(selectedOptions);
      });
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
                border: const GradientBoxBorder(
                  width: 1,
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.blue, Colors.purple],
                  ),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _aiContoller,
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
                onTap: _isFetchingData ? null : getStallDescriptionFromAi,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: kprimaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: _isFetchingData
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.create, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Create",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ai description 
  void getStallDescriptionFromAi() async {

    setState(() {
      isLoading = true; // Start loading
    });

    Navigator.of(context).pop();

    const ourUrl ='https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyCI-BViPUvEpgYt9QJ4-YUuDzOVHNjL8yI';

    final header = {'Content-Type': 'application/json'};
    var data = {
      "contents": [
        {
          "parts": [
            {"text": _aiContoller.text.trim()}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(ourUrl),
        headers: header,
        body: jsonEncode(data)
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);
        setState(() {
          _descriptionController.text = result['candidates'][0]['content']['parts'][0]['text'];
          isLoading = false;
        });
      } else {
        showToast("There was some error while generating description please add manually");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      showToast("There was some error while generating description please add manually");
      setState(() {
        isLoading = false;
      });
    }

    _aiContoller.clear();
    
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

  Future<void> _submitStall(BuildContext context) async {
    if (selectedCategories.isEmpty && _descriptionController.text.isEmpty) {
      showToast("Please Fill All Fields !");
      return;
    }

    setState(() {
      isLoading = true;
    });

    var stallProvider = Provider.of<StallProvider>(context, listen: false);
    var authId = Provider.of<Auth>(context, listen: false).token;

    try {
      await stallProvider.addStall(
        Stall(
          sId: widget.sId != null ? widget.sId.toString() : '',
          stallName: widget.name,
          ownerName: widget.ownerName,
          rating: 0.0,
          stallCategories: selectedCategories,
          stallDescription: _descriptionController.text,
          bannerImageUrl: '',
          favoriteUsers: [],
          ownerContact: widget.contactNumber,
          location: widget.location,
          stallImages: widget.sId != null ? widget.stallImagesList : [],
          menuImages: widget.sId != null ? widget.menuImagesList : [],
          creatorUID: authId,
          isOwner: widget.role == 'creator' ? false : true,
        ),
        widget.stallImagesList,
        widget.menuImagesList,
        widget.sId != null ? 'update' : 'add',
      );
      Fluttertoast.showToast(
        msg: "Stall ${widget.sId != null ? 'Updated' : 'Added'} successfully",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushReplacementNamed('bottom-nav');
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
        isLoading = false;
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
                height: MediaQuery.of(context).size.height * 0.96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 40),
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: isLoading ? null : () => _submitStall(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: kprimaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (widget.sId != null
                                    ? "Update Stall"
                                    : "Let's Add Stall"),
                                textAlign: TextAlign.center,
                                style:
                                    kTextPopM16.copyWith(color: Colors.white),
                              ),
                              const SizedBox(width: 10),
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
          if (isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
