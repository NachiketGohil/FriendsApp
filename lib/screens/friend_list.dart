import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:friends_app/database/db_helper.dart';
import 'package:friends_app/constant.dart';
import 'package:friends_app/widgets/custom_button.dart';
import 'package:friends_app/widgets/custom_textfield.dart';
import 'package:friends_app/widgets/error_snackbar.dart';

class FriendList extends StatefulWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  String autoTitle = 'Sign Up', autoButton = 'Create';
  List<Map<String, dynamic>> _friendList = [];
  List<Map<String, dynamic>> _filteredList = [];

  void _refreshFriendList() async {
    final data = await DbHelper.readFriends();
    setState(() {
      _friendList = data;
      _filteredList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredList = _friendList;
    _refreshFriendList(); // Loading the diary when the app starts
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _friendList;
    } else {
      results = _friendList
          .where((value) => value["cFirstName"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Friend List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FocusScope.of(context).unfocus();
          _showForm(null);
        },
        splashColor: Colors.white54,
        backgroundColor: Colors.blueAccent,
        label: const Text("Create Friend"),
        icon: const Icon(
          Icons.group_add_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextField(
                    autocorrect: true,
                    keyboardType: Constants.typeName,
                    textCapitalization: Constants.capitalName,
                    controller: Constants.controlSearch,
                    onChanged: (text) => _runFilter(text),
                    decoration: InputDecoration(
                      hintText: "Search Friend",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      isDense: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.black54,
                    thickness: 0.8,
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _filteredList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          minVerticalPadding: 0,
                          key: ValueKey(_filteredList[index]["cId"]),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tileColor: Colors.lightBlue[50],
                          isThreeLine: true,
                          minLeadingWidth: 0,
                          title: Text(
                            "${_friendList[index]['cFirstName']} ${_friendList[index]['cLastName']}",
                          ),
                          subtitle: Text(
                            "${_friendList[index]['cEmail']} \n${_friendList[index]['cMobile']}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  _showForm(_friendList[index]['cId']);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  size: 26,
                                  color: Colors.green,
                                ),
                                splashColor: Colors.black12,
                                visualDensity: VisualDensity.compact,
                              ),
                              IconButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  _delFriend(_friendList[index]['cId']);
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  size: 26,
                                  color: Colors.red,
                                ),
                                splashColor: Colors.black12,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 100,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Text(
                        'No results found \n Try Again by Searching Name..',
                        style: TextStyle(fontSize: 14, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _friendList.firstWhere((element) => element['cId'] == id);
      Constants.controlFirstName.text = existingJournal['cFirstName'];
      Constants.controlLastName.text = existingJournal['cLastName'];
      Constants.controlEmail.text = existingJournal['cEmail'];
      Constants.controlMobile.text = existingJournal['cMobile'];
      Constants.controlPassword.text = existingJournal['cPassword'];
    }

    ///BUTTON TEXT
    ///Text(id == null ? 'Create New' : 'Update'),
    id == null ? autoButton = 'Create Friend' : autoButton = 'Edit Friend';
    if (id == null) {
      Constants.controlFirstName.clear();
      Constants.controlLastName.clear();
      Constants.controlEmail.clear();
      Constants.controlMobile.clear();
      Constants.controlPassword.clear();
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextfield(
              cuLabelText: 'First Name',
              // cuOnChanged: (text) => Constants.firstName = text,
              textController: Constants.controlFirstName,
              cuTextCapitalization: Constants.capitalName,
              cuKeyboardType: Constants.typeName,
              cuTextInputAction: Constants.inputActionNext,
            ),
            CustomTextfield(
              cuLabelText: 'Last Name',
              //cuOnChanged: (text) => Constants.lastName = text,
              textController: Constants.controlLastName,
              cuTextCapitalization: Constants.capitalName,
              cuKeyboardType: Constants.typeName,
              cuTextInputAction: Constants.inputActionNext,
            ),
            CustomTextfield(
              cuLabelText: 'Email',
              //cuOnChanged: (text) => Constants.email = text,
              textController: Constants.controlEmail,
              cuTextCapitalization: Constants.capitalNone,
              cuKeyboardType: Constants.typeEmail,
              cuTextInputAction: Constants.inputActionNext,
            ),
            CustomTextfield(
              cuLabelText: 'Mobile Number',
              //cuOnChanged: (text) => Constants.mobile = text,
              textController: Constants.controlMobile,
              cuTextCapitalization: Constants.capitalNone,
              cuKeyboardType: Constants.typeNumber,
              cuTextInputAction: Constants.inputActionNext,
            ),
            CustomTextfield(
              cuLabelText: 'Create Password',
              //cuOnChanged: (text) => Constants.password = text,
              textController: Constants.controlPassword,
              cuTextCapitalization: Constants.capitalNone,
              cuKeyboardType: Constants.typePwd,
              cuTextInputAction: Constants.inputActionNone,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: CustomButton(
                onPressedButton: () async {
                  print("$autoButton Clicked");
                  FocusScope.of(context).unfocus();
                  if (!Constants.isValidateFName()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg: 'Please Enter First Name',
                      wantLoading: false,
                    );
                  } else if (!Constants.isValidateLName()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg: 'Please Enter Last Name',
                      wantLoading: false,
                    );
                  } else if (!Constants.isValidateEmail()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg: 'Please Enter Valid Email',
                      wantLoading: false,
                    );
                  } else if (!Constants.isValidateMobile()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg:
                          'Please Enter Mobile Number with Only 10 digits',
                      wantLoading: false,
                    );
                  } else if (!Constants.isValidatePassword()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg:
                          'Please Enter password with at least 4 characters',
                      wantLoading: false,
                    );
                  } else if (Constants.isValidateFName() &&
                      Constants.isValidateLName() &&
                      Constants.isValidateEmail() &&
                      Constants.isValidateMobile() &&
                      Constants.isValidatePassword()) {
                    // ErrorSnackbar.buildErrorSnackbar(
                    //   context: context,
                    //   errorMsg: autoButton == "Create Friend"
                    //       ? "Creating Friend"
                    //       : "Editing Friend",
                    //   wantLoading: true,
                    // );
                    log(
                      autoButton == "Create Friend"
                          ? "Creating Friend"
                          : "Editing Friend",
                      name: "Sanckbar Values",
                      level: 9,
                    );

                    log(
                      "All the values in the variables are: \n"
                      "firstName: ${Constants.controlFirstName.text}\n"
                      "lastName: ${Constants.controlLastName.text}\n"
                      "email: ${Constants.controlEmail.text}\n"
                      "mobile: ${Constants.controlMobile.text}\n"
                      "password: ${Constants.controlPassword.text}\n",
                      level: 2,
                      name: "VALUES IN VARIABLES",
                    );

                    if (id == null) {
                      await _addFriend();
                    } else {
                      await _editFriend(id);
                    }

                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  }
                },
                autoButton: autoButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addFriend() async {
    await DbHelper.createFriend(
        cFirstName: Constants.controlFirstName.text,
        cLastName: Constants.controlLastName.text,
        cEmail: Constants.controlEmail.text,
        cMobile: Constants.controlMobile.text,
        cPassword: Constants.controlPassword.text);
    _refreshFriendList();
  }

  Future<void> _editFriend(int id) async {
    await DbHelper.updateFriend(
        cId: id,
        cFirstName: Constants.controlFirstName.text,
        cLastName: Constants.controlLastName.text,
        cEmail: Constants.controlEmail.text,
        cMobile: Constants.controlMobile.text,
        cPassword: Constants.controlPassword.text);
    _refreshFriendList();
  }

  // Delete an item
  void _delFriend(int id) async {
    await DbHelper.deleteFriend(id);
    _refreshFriendList();
  }
}
