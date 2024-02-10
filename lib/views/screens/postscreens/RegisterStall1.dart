import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/postscreens/RegisterStall2.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class RegisterStall1 extends StatefulWidget {
  final String? sId;
  const RegisterStall1({Key? key, this.sId}) : super(key: key);

  @override
  State<RegisterStall1> createState() => _RegisterStall1State();
}

class _RegisterStall1State extends State<RegisterStall1> {
  final _form = GlobalKey<FormState>();

  String selectedRole = '';

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ownerNameController = TextEditingController();

  String get name => _nameController.text;
  String get phone => _phoneController.text;
  String get ownerName => _ownerNameController.text;
  String phoneNo = "";

  bool isLoading = false;
  bool isOtpEnable = false;
  bool isNextButtonEnabled = false;
  bool isPhoneFilled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ownerNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.sId != null) {
      fetchStallDetails();
    }
  }

  Future<void> fetchStallDetails() async {
    var authToken = Provider.of<Auth>(context, listen: false).token;
    Stall existingStall = Provider.of<StallProvider>(context, listen: false)
        .getUserRegisteredStalls(authToken)
        .firstWhere((stall) => stall.sId == widget.sId);

    setState(() {
      _nameController.text = existingStall.stallName;
      _ownerNameController.text = existingStall.ownerName;
      _phoneController.text = existingStall.ownerContact;
      if (existingStall.isOwner) {
        selectedRole = 'owner';
      } else {
        selectedRole = 'creator';
      }
    });
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

  Future _nextPage() async {
    isLoading = true;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterStall2(
          role: selectedRole,
          name: name,
          ownerName: ownerName,
          contactNumber: phone,
          sId: widget.sId,
        ),
      ),
    );
    setState(() {
      isOtpEnable = false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        isSearch: false,
        screenTitle: 'Enter Details',
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  setTitle("Select Your Role"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'owner',
                            groupValue: selectedRole,
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value!;
                              });
                            },
                            activeColor: kprimaryColor,
                          ),
                          Text(
                            'Owner',
                            style: kTextPopR16,
                          ),
                        ],
                      ),
                      const SizedBox(width: 18),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'creator',
                            groupValue: selectedRole,
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value!;
                              });
                            },
                            activeColor: kprimaryColor,
                          ),
                          Text(
                            'Creator',
                            style: kTextPopR16,
                          ),
                        ],
                      ),
                    ],
                  ),
                  setTitle("Stall Name"),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: "Enter stall name",
                      hintStyle: kTextPopR14,
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter stall name!';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  setTitle("Owner's Name"),
                  TextFormField(
                    controller: _ownerNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: "Enter owner's name",
                      hintStyle: kTextPopR14,
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter owner\'s name!';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  setTitle("Owner Contact Number"),
                  IntlPhoneField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      hintStyle: kTextPopR14,
                      counterText: "",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value!.number.isEmpty) {
                        return 'Please Enter Valid Number!';
                      }
                      return null;
                    },
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      setState(() {
                        phoneNo = phone.completeNumber.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_form.currentState!.validate() &&
                            phone.isNotEmpty &&
                            selectedRole.isNotEmpty) {
                          _nextPage();
                        }
                      },
                      child: Opacity(
                        opacity: phone.isNotEmpty &&
                                selectedRole.isNotEmpty &&
                                _nameController.text.isNotEmpty &&
                                _ownerNameController.text.isNotEmpty
                            ? 1
                            : 0.6,
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
      ),
    );
  }
}
