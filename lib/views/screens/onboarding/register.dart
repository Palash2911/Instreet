import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static var routeName = 'register-screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  String get name => _nameController.text;
  String get phone => _phoneController.text;
  String get email => _emailController.text;
  String get date => _dateController.text;

  String gender = "";
  List<Gender> genders = [];

  bool isInit = false;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      _nameController.text = "";
      _phoneController.text = "";
      _emailController.text = "";
      _dateController.text = "";
      genders.add(Gender("Male", Icons.male, false));
      genders.add(Gender("Female", Icons.female, false));
      genders.add(Gender("Others", Icons.transgender, false));
    }
    setState(() {
      isInit = true;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tell us about you'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.only(left: 21),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: kTextPopR14,
                      icon: const Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 1, color: Colors.black)
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name!';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: kTextPopR14,
                      icon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 1, color: Colors.black)
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter email!';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Phone",
                      hintStyle: kTextPopR14,
                      icon: const Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 1, color: Colors.black)
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      final phoneRegex = RegExp(r'^\+?\d{9,15}$');
                      if (!phoneRegex.hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintText: "Date of Birth",
                        hintStyle: kTextPopR14,
                        icon: const Icon(
                            Icons.calendar_today_rounded),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date Not Set !';
                        }
                        return null;
                      },
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2004, 1, 1),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2018));
                        if (pickedDate != null) {
                          String formattedDate =
                          DateFormat.yMMMMd('en_US')
                              .format(pickedDate);
                          setState(() {
                            _dateController.text = formattedDate;
                          });
                        } else {}
                      },
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.male_rounded,
                        size: 32.0,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 12.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 27.0),
                            SizedBox(
                              height: 54,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: genders.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          genders.forEach((gender) =>
                                          gender.isSelected =
                                          false);
                                          genders[index].isSelected =
                                          true;
                                          gender =
                                              genders[index].name;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 9),
                                        child: Chip(
                                          label: Text(
                                            genders[index].name,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: !genders[index]
                                                    .isSelected
                                                    ? kprimaryColor
                                                    : Colors.white),
                                          ),
                                          backgroundColor:
                                          !genders[index]
                                              .isSelected
                                              ? Colors.white
                                              : kprimaryColor,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: kprimaryColor,
                        textStyle: const TextStyle(
                          fontSize: 18,
                        )),
                    child: const Text('Enter In-Street'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Gender {
  String name;
  IconData icon;
  bool isSelected;

  Gender(this.name, this.icon, this.isSelected);
}
