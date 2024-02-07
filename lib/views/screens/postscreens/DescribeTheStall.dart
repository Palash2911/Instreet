import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/postscreens/PostScreenNav.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DescribeStallPage extends StatefulWidget {
  List<dynamic> stallImagesList = [];
  List<dynamic> menuImagesList = [];
  String location;
  String role;
  String name;
  String ownername;
  String contactnumber;

  DescribeStallPage(
      {super.key,
      required this.stallImagesList,
      required this.menuImagesList,
      required this.location,
      required this.role,
      required this.name,
      required this.ownername,
      required this.contactnumber});

  @override
  // ignore: library_private_types_in_public_api
  _DescribeStallPageState createState() => _DescribeStallPageState();
}

class _DescribeStallPageState extends State<DescribeStallPage> {

  TextEditingController _descriptionController = TextEditingController();

  List<String> selectedCategories = [];
  
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

  void _openAIDescriptionWidget() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AIDescriptionWidget();
      },
    );
  }

  // not yet implement
  Widget AIDescriptionWidget(){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create with AI',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
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
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.create,
                        color: Colors.white,
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

  Future<void> _submitStall() async {
    setState(() {
      isSubmitting = true;
    });

    var stallProvider = Provider.of<StallProvider>(context, listen: false);

    var authId = Provider.of<Auth>(context, listen: false).token;

    try {
      await stallProvider.addStall(Stall(
          sId: "iygiwfi",
          stallName: widget.name,
          ownerName: widget.ownername,
          rating: 5.0,
          stallCategories: selectedCategories,
          stallDescription: _descriptionController.text,
          bannerImageUrl:widget.stallImagesList[0],
          favoriteUsers: [],
          ownerContact: widget.contactnumber,
          location: widget.location,
          stallImages: widget.stallImagesList,
          menuImages: widget.menuImagesList,
          creatorUID: authId));

      Fluttertoast.showToast(
        msg: "Stall Added successfully",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const PostScreenNav(),
        ),
      );


    } catch (error) {

      print("Error submitting stall: $error");

      Fluttertoast.showToast(
        msg: "Error Adding Stall. Please try again !",
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
                    setTitle("Describe the Stall", true),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Type a large description...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Around 100 words',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    setTitle("Stall Category", false),
                    DropdownButtonFormField<String>(
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: Colors.white,
                      value: selectedCategories.isNotEmpty
                          ? selectedCategories.first
                          : null,
                      items: allCategories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.white,
                                checkColor: kprimaryColor,
                                value: selectedCategories.contains(category),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null) {
                                      if (value) {
                                        selectedCategories.add(category);
                                      } else {
                                        selectedCategories.remove(category);
                                      }
                                    }
                                  });
                                },
                              ),
                              Text(
                                category,
                                style: TextStyle(
                                  color: selectedCategories.contains(category)
                                      ? kprimaryColor
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            if (selectedCategories.contains(value)) {
                              selectedCategories.remove(value);
                            } else {
                              selectedCategories.add(value);
                            }
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select categories',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Selected Categories: ${selectedCategories.join(', ')}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: isSubmitting ? null : _submitStall,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isSubmitting ? "Submitting..." : "Next",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              if (isSubmitting)
                                SizedBox(
                                  width: 10,
                                ),
                              if (isSubmitting)
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              else
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
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
        ],
      ),
    );
  }
}
