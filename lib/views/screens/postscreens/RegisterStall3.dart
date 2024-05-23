import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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
  _RegisterStall3State createState() => _RegisterStall3State();
}

Future<void> sendNotificationToAllUsers(String stallName,String id) async {
  try {
    List<String> tokens = [];
    CollectionReference user = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await user.get();

    if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
        // Cast data to Map<String, dynamic> before checking for keys
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        var token = data.containsKey('FcmToken') ? data['FcmToken'] : null;
        if (token != null) {
          tokens.add(token);
        }
      }
    } else {
      print('No users found');
    }

    final serverKey = dotenv.env['FIREBASE_SERVER_KEY'];
    const fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    if (tokens.isNotEmpty) {
      for (int i = 0; i < tokens.length; i++) {
        final response = await http.post(
          Uri.parse(fcmUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':serverKey!,
          },
          body: jsonEncode({
            'to': tokens[i],
            'notification': {
              'title': 'New Stall Added',
              'body': 'Check out the new stall: $stallName',
              'sound': 'default',
              'icon': 'logo_img',
              'data': {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'stall_id': id,
                'status': 'done'
              }
            },
          }),
        );

        if (response.statusCode == 200) {
          print('Notification sent to all users');
        } else {
          print('Failed to send notification: ${response.body}');
        }
      }
    }else{
      print(tokens.length);
    }
  } catch (e) {
    print('Error: $e');
  }

}



class _RegisterStall3State extends State<RegisterStall3> {
  final TextEditingController _descriptionController = TextEditingController();

  final MultiSelectController _controller = MultiSelectController();

  final TextEditingController _aiController = TextEditingController();

  bool _isFetchingData = false;
  late final GenerativeModel _model;
  late final ChatSession _chat;

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
    _model =
        GenerativeModel(model: 'gemini-pro', apiKey: dotenv.env['API_KEY']!);
    _chat = _model.startChat();
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
        msg:"Error while fetching stall details, please fill in the blank spaces",
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Describe With AI',
              style: kTextPopM16,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              decoration: BoxDecoration(
                border: const GradientBoxBorder(
                  width: 2,
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.green, Colors.purple],
                  ),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _aiController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      "Describe the Stall in 5-10 words and watch the Magic of AI.",
                ),
                textAlign: TextAlign.justify,
                showCursor: true,
                maxLines: 4,
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
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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

  Future<void> getStallDescriptionFromAi() async {
    setState(() {
      isLoading = true;
    });

    Navigator.of(context).pop();

    try {
      String prompt =
          "Generate a concise description for a street stall named '${widget.name}', categorized under ${selectedCategories.join(', ')}. The description should be based on the following details: ${_aiController.text}. Aim for a summary that is under 50 words, straightforward, and easily understandable.";
      print(prompt);
      final res = await _chat.sendMessage(Content.text(prompt));

      String fallbackText =
          "Explore '${widget.name}', a unique street stall in the ${selectedCategories.join(', ')} category. '${widget.name}' street stall is located at '${widget.location}' ";

      final text = res.text!.isEmpty ? fallbackText : res.text;

      _descriptionController.text = text.toString();

      print(text);
    } catch (e) {
      debugPrint(e.toString());
      showToast(
          "Unable to generate description automatically. Please input the description manually.");
    }
    setState(() {
      _aiController.clear();
      isLoading = false;
    });
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
                  onTap: selectedCategories.isEmpty
                      ? () => showToast('Please Select The Categories First !')
                      : _openAIDescriptionWidget,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: kprimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Use AI..',
                          style: kTextPopM16.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
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
      // ignore: unused_local_variable
      String currentAddedStallId =  await stallProvider.addStall(
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
          isTrending: false,
        ),
        widget.stallImagesList,
        widget.menuImagesList,
        widget.sId != null ? 'update' : 'add',
      );
      print("this stall is added now ${currentAddedStallId}");
      Fluttertoast.showToast(
        msg: "Stall ${widget.sId != null ? 'Updated' : 'Added'} successfully",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if (mounted) {
        sendNotificationToAllUsers(widget.name,currentAddedStallId);
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
  // sendNotification

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
                    setTitle("Describe The Stall", true),
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
                        labelText: 'Tell us more...',
                      ),
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
