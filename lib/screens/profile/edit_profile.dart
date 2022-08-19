
import 'package:cached_network_image/cached_network_image.dart';
import 'package:driverapp/helper/helper.dart';
import 'package:driverapp/utils/session.dart';
import 'package:driverapp/widgets/custome_backarrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/models/user/user.dart';
import 'package:driverapp/route.dart';
import 'package:provider/provider.dart';

import '../../repository/auth.dart';
import '../../utils/constants/error_messages.dart';
import '../../utils/constants/ui_strings.dart';
import '../../utils/painter.dart';
import '../../utils/theme/ThemeProvider.dart';
import '../../utils/validator.dart';
import '../credit/toast_message.dart';
import '../resetpassword/changepassword.dart';

class EditProfile extends StatefulWidget {
  static const routeName = "/editaprofile";

  final EditProfileArgument args;

  const EditProfile({Key? key, required this.args}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var emailController = TextEditingController();
  var emergencyController = TextEditingController();
  late ThemeProvider themeProvider;
  final _appBar = GlobalKey<FormState>();
  @override
  void initState() {
    email = widget.args.auth.email;
    emergencyNumber = widget.args.auth.emergencyContact ?? "+251";
    emailController.text = email ?? "";
    emergencyController.text = emergencyNumber;
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CreditAppBar(
          key: _appBar, title: updateAccountU, appBar: AppBar(), widgets: []),
      body: Stack(
          children: [
            Opacity(
              opacity: 0.5,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 150,
                  color: themeProvider.getColor,
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 70,
                color: themeProvider.getColor,
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 150,
                  color: themeProvider.getColor,
                  child: ClipPath(
                    clipper: WaveClipperBottom(),
                    child: Container(
                      height: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            BlocConsumer<UserBloc, UserState>(builder: (context, state) {
              return _buildProfileForm();
            }, listener: (context, state) {
              if (state is UserUnAuthorised) {
                gotoSignIn(context);
              }
              if (state is ImageUploadSuccess) {
                BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
              }
              if (state is UserLoading) {}
              if (state is UsersLoadSuccess) {
                _isLoading = false;

                isEmailUpdated = false;
                isEmergencyUpdated = false;
                email = emailController.text;
                emergencyNumber = emergencyController.text;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Update Successful"),
                  backgroundColor: Colors.green,
                ));
                Future.delayed(const Duration(seconds: 1), () {
                  BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
                });
              }
              if (state is UserOperationFailure) {
                _isLoading = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Update Failed"),
                  backgroundColor: Colors.red.shade900,
                ));
              }
            }),
          ]
      ),
    );
  }
  bool isEmailUpdated = false;
  bool isEmergencyUpdated = false;
  late String? email;
  late String emergencyNumber;
  Widget _buildProfileForm() {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // _showModalNavigation();
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: widget.args.auth.profilePicture!,
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                            const Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.black,
                            ),
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.normal)
                  ]),
                  child: TextFormField(
                    enabled: false,
                    initialValue: widget.args.auth.name,
                    decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        isCollapsed: false,
                        isDense: true,
                        hintText: "Full Name",
                        focusColor: Colors.blue,

                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                        prefixIcon: Icon(
                          Icons.contact_mail,
                          size: 19,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field can\'t be empity';
                      } else if (value.length < 4) {
                        return 'Name length must not be less than 4';
                      } else if (value.length > 25) {
                        return 'Name length must not be Longer than 25';
                      }
                      return null;
                    },
                    onSaved: (value) {
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.normal)
                  ]),
                  child: TextFormField(
                    enabled: false,
                    initialValue: widget.args.auth.lastName,
                    decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        isCollapsed: false,
                        isDense: true,
                        hintText: "Last Name",
                        focusColor: Colors.blue,

                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                        prefixIcon: Icon(
                          Icons.contact_mail,
                          size: 19,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none)),
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'This field can\'t be empity';
                    //   } else if (value.length < 4) {
                    //     return 'Name length must not be less than 4';
                    //   } else if (value.length > 25) {
                    //     return 'Nameength must not be Longer than 25';
                    //   }
                    //   return null;
                    // },
                    onSaved: (value) {
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.normal)
                  ]),
                  child: TextFormField(
                    // 77352588
                    enabled: false,
                    initialValue: widget.args.auth.phoneNumber,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        isCollapsed: false,
                        isDense: true,
                        hintText: "Phone Number",
                        focusColor: Colors.blue,

                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                        prefixIcon: Icon(
                          Icons.phone_callback_outlined,
                          size: 19,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none)),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.normal)
                  ]),
                  child: TextFormField(
                    controller: emailController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        isCollapsed: false,
                        isDense: true,
                        hintText: "Email",
                        focusColor: Colors.blue,

                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          size: 19,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none)),
                    validator: (value) {
                      return Sanitizer().isEmailValid(value.toString());
                    },
                    onSaved: (value) {
                      Session().logSession("update-email", value ?? "empty");
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.normal)
                  ]),
                  child: TextFormField(
                    controller: emergencyController,
                    style: TextStyle(fontSize: 18),
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        isCollapsed: false,
                        isDense: true,
                        hintText: "Emergency Contact",
                        focusColor: Colors.blue,

                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45),
                        prefixIcon: Icon(
                          Icons.contact_phone_outlined,
                          size: 19,
                        ),
                        prefixText: "+251",
                        prefixStyle: TextStyle(color: Colors.black),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none)),
                    validator: (value){
                      if (value!.isEmpty) {
                        return null;
                      } else if (value.length < 9) {
                      return phoneLengthE;
                      } else if (value.length > 9) {
                      return phoneExceedE;
                      } else if(value.length == 9){
                      return null;
                      }
                    },
                    onSaved: (value) {
                      Session().logSession("update-emer", value ?? "empty");
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      final form = _formKey.currentState;
                      if (form!.validate()) {
                        form.save();
                        String emailVal = "";
                        String emergencyVal = "";
                        Session().logSession("update-data",
                            "email old: $email, new: ${emailController.text}");
                        Session().logSession("update-data",
                            "emer old: $emergencyNumber, new: ${emergencyController.text}");
                        if(email != emailController.text){
                          isEmailUpdated = true;
                          emailVal = emailController.text;
                        }
                        if(emergencyNumber != emergencyController.text){
                          isEmergencyUpdated = true;
                          emergencyVal = emergencyController.text;
                        }
                        if(isEmailUpdated || isEmergencyUpdated){
                          updateProfile(emailVal, emergencyVal);
                        }else {
                          ShowSnack(context: context,message: "Nothing to update").show();
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text(
                          "Save Changes",
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1,
                            ),
                          )
                              : Container(),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ChangePassword.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text(
                          "Change Password",
                        ),
                        const Spacer(),
                        /*Align(
                          alignment: Alignment.centerRight,
                          child: _isLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 1,
                            ),
                          )
                              : Container(),
                        )*/
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ));
  }

  // Widget _buildProfileForm() {
  //   return Stack(
  //     children: [
  //       // CustomeBackArrow(),
  //       Form(
  //         key: _formKey,
  //         child: Container(
  //           height: MediaQuery.of(context).size.height,
  //           child: SingleChildScrollView(
  //             padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text("Edit Profile",
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.w300,
  //                         fontSize: 32,
  //                         color: Colors.white)),
  //                 const SizedBox(height: 40),
  //                 Card(
  //                   elevation: 5,
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 15),
  //                     child: Column(
  //                       children: [
  //                         // const CircleAvatar(
  //                         //   radius: 60,
  //                         //   backgroundColor: Colors.black54,
  //                         //   //backgroundImage: AssetImage("assetName"),
  //                         // ),
  //                         const SizedBox(
  //                           height: 20,
  //                         ),
  //                         GestureDetector(
  //                           onTap: () {
  //                             _showModalNavigation();
  //                           },
  //                           child: CircleAvatar(
  //                             backgroundColor: Colors.grey.shade300,
  //                             radius: 60,
  //                             child: _isImageLoading
  //                                 ? CircularProgressIndicator()
  //                                 : ClipRRect(
  //                                     borderRadius: BorderRadius.circular(100),
  //                                     child: BlocBuilder<AuthBloc, AuthState>(
  //                                       builder: (_, state) {
  //                                         if (state is AuthDataLoadSuccess) {
  //                                           return CachedNetworkImage(
  //                                             imageUrl:
  //                                                 state.auth.profilePicture!,
  //                                             imageBuilder:
  //                                                 (context, imageProvider) =>
  //                                                     Container(
  //                                               decoration: BoxDecoration(
  //                                                 image: DecorationImage(
  //                                                   image: imageProvider,
  //                                                   fit: BoxFit.cover,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                             placeholder: (context, url) =>
  //                                                 const CircularProgressIndicator(),
  //                                             errorWidget: (context, url,
  //                                                     error) =>
  //                                                 Image.asset(
  //                                                     'assets/icons/avatar-icon.png'),
  //                                           );
  //                                         }
  //                                         return CircleAvatar(
  //                                           radius: 100,
  //                                         );
  //                                       },
  //                                     )),

  //                             // _image == null
  //                             //     ? Container()
  //                             //     : ClipRRect(
  //                             //         borderRadius: BorderRadius.circular(100),
  //                             //         child: Stack(
  //                             //           children: [
  //                             //             Container(
  //                             //               child: Image.file(
  //                             //                 File(_image!.path),
  //                             //                 fit: BoxFit.cover,
  //                             //               ),
  //                             //               width: 300,
  //                             //               height: 300,
  //                             //             ),
  //                             //             Positioned(
  //                             //               bottom: 4.0,
  //                             //               right: 4.0,
  //                             //               child: IconButton(
  //                             //                 icon: const Icon(Icons.edit),
  //                             //                 onPressed: () {},
  //                             //               ),
  //                             //             )
  //                             //           ],
  //                             //         ),
  //                             //       ),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           height: 20,
  //                         ),
  //                         TextFormField(
  //                           initialValue: widget.args.auth.name,
  //                           decoration: const InputDecoration(
  //                               alignLabelWithHint: true,
  //                               floatingLabelBehavior:
  //                                   FloatingLabelBehavior.always,
  //                               isCollapsed: false,
  //                               isDense: true,
  //                               hintText: "Full Name",
  //                               focusColor: Colors.blue,
  //                               focusedBorder: OutlineInputBorder(
  //                                   borderSide: BorderSide(
  //                                       width: 0.6, color: Colors.orange)),
  //                               hintStyle: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.black45),
  //                               prefixIcon: Icon(
  //                                 Icons.contact_mail,
  //                                 size: 19,
  //                               ),
  //                               fillColor: Colors.white,
  //                               filled: true,
  //                               border: OutlineInputBorder(
  //                                   //borderRadius: BorderRadius.all(Radius.circular(10)),
  //                                   borderSide: BorderSide(
  //                                       color: Colors.grey, width: 0.4))),
  //                           validator: (value) {
  //                             if (value!.isEmpty) {
  //                               return 'This field can\'t be empity';
  //                             } else if (value.length < 4) {
  //                               return 'Name length must not be less than 4';
  //                             } else if (value.length > 25) {
  //                               return 'Nameength must not be Longer than 25';
  //                             }
  //                             return null;
  //                           },
  //                           onSaved: (value) {
  //                             _user["first_name"] = value!.split(" ")[0];
  //                             _user["last_name"] = value.split(" ")[1];
  //                           },
  //                         ),
  //                         const SizedBox(
  //                           height: 10,
  //                         ),
  //                         TextFormField(
  //                           initialValue: widget.args.auth.phoneNumber,
  //                           decoration: const InputDecoration(
  //                               alignLabelWithHint: true,
  //                               floatingLabelBehavior:
  //                                   FloatingLabelBehavior.always,
  //                               isCollapsed: false,
  //                               isDense: true,
  //                               hintText: "Phone Number",
  //                               focusColor: Colors.blue,
  //                               focusedBorder: OutlineInputBorder(
  //                                   borderSide: BorderSide(
  //                                       width: 0.6, color: Colors.orange)),
  //                               hintStyle: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.black45),
  //                               prefixIcon: Icon(
  //                                 Icons.phone_callback_outlined,
  //                                 size: 19,
  //                               ),
  //                               fillColor: Colors.white,
  //                               filled: true,
  //                               border: OutlineInputBorder(
  //                                   //borderRadius: BorderRadius.all(Radius.circular(10)),
  //                                   borderSide: BorderSide(
  //                                       color: Colors.grey, width: 0.4))),
  //                           validator: (value) {
  //                             if (value!.isEmpty) {
  //                               return 'Please enter Your Password';
  //                             } else if (value.length < 4) {
  //                               return 'Password length must not be less than 4';
  //                             } else if (value.length > 25) {
  //                               return 'Password length must not be greater than 25';
  //                             }
  //                             return null;
  //                           },
  //                           onSaved: (value) {
  //                             _user["phone_number"] = value;
  //                           },
  //                         ),
  //                         const SizedBox(
  //                           height: 10,
  //                         ),
  //                         TextFormField(
  //                           initialValue: widget.args.auth.email,
  //                           decoration: const InputDecoration(
  //                               alignLabelWithHint: true,
  //                               floatingLabelBehavior:
  //                                   FloatingLabelBehavior.always,
  //                               isCollapsed: false,
  //                               isDense: true,
  //                               hintText: "Email",
  //                               focusColor: Colors.blue,
  //                               focusedBorder: OutlineInputBorder(
  //                                   borderSide: BorderSide(
  //                                       width: 0.6, color: Colors.orange)),
  //                               hintStyle: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.black45),
  //                               prefixIcon: Icon(
  //                                 Icons.mail_outline,
  //                                 size: 19,
  //                               ),
  //                               fillColor: Colors.white,
  //                               filled: true,
  //                               border: OutlineInputBorder(
  //                                   //borderRadius: BorderRadius.all(Radius.circular(10)),
  //                                   borderSide: BorderSide(
  //                                       color: Colors.grey, width: 0.4))),
  //                           validator: (value) {
  //                             if (value!.isEmpty) {}
  //                             return null;
  //                           },
  //                           onSaved: (value) {
  //                             _user["email"] = value;
  //                           },
  //                         ),
  //                         const SizedBox(
  //                           height: 10,
  //                         ),

  //                         const SizedBox(
  //                           height: 10,
  //                         ),
  //                         TextFormField(
  //                           initialValue: widget.args.auth.emergencyContact,
  //                           decoration: const InputDecoration(
  //                               alignLabelWithHint: true,
  //                               floatingLabelBehavior:
  //                                   FloatingLabelBehavior.always,
  //                               isCollapsed: false,
  //                               isDense: true,
  //                               hintText: "Emergency Contact Number",
  //                               focusColor: Colors.blue,
  //                               focusedBorder: OutlineInputBorder(
  //                                   borderSide: BorderSide(
  //                                       width: 0.6, color: Colors.orange)),
  //                               hintStyle: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.black45),
  //                               prefixIcon: Icon(
  //                                 Icons.contact_phone_outlined,
  //                                 size: 19,
  //                               ),
  //                               fillColor: Colors.white,
  //                               filled: true,
  //                               border: OutlineInputBorder(
  //                                   //borderRadius: BorderRadius.all(Radius.circular(10)),
  //                                   borderSide: BorderSide(
  //                                       color: Colors.grey, width: 0.4))),
  //                           onSaved: (value) {
  //                             //print("now");
  //                             _user["emergency_contact"] = value;
  //                           },
  //                         ),
  //                         const SizedBox(
  //                           height: 40,
  //                         ),
  //                         SizedBox(
  //                             height: 40,
  //                             width: MediaQuery.of(context).size.width * 0.6,
  //                             child: ElevatedButton(
  //                               onPressed: _isLoading
  //                                   ? null
  //                                   : () {
  //                                       final form = _formKey.currentState;
  //                                       if (form!.validate()) {
  //                                         form.save();

  //                                         updateProfile();
  //                                       }
  //                                     },
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   const Spacer(),
  //                                   const Text("Save Changes",
  //                                       style: TextStyle(color: Colors.white)),
  //                                   const Spacer(),
  //                                   Align(
  //                                     alignment: Alignment.centerRight,
  //                                     child: _isLoading
  //                                         ? const SizedBox(
  //                                             height: 20,
  //                                             width: 20,
  //                                             child: CircularProgressIndicator(
  //                                               color: Colors.white,
  //                                             ),
  //                                           )
  //                                         : Container(),
  //                                   )
  //                                 ],
  //                               ),
  //                             )),
  //                         const SizedBox(
  //                           height: 10,
  //                         ),
  //                         SizedBox(
  //                           width: MediaQuery.of(context).size.width * 0.6,
  //                           child: TextButton(
  //                               style: ButtonStyle(
  //                                   shape: MaterialStateProperty.all<
  //                                           RoundedRectangleBorder>(
  //                                       RoundedRectangleBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(30))),
  //                                   side: MaterialStateProperty.all<BorderSide>(
  //                                       BorderSide(
  //                                           color: Colors.red.shade900))),
  //                               onPressed: () {
  //                                 showDialog(
  //                                     context: context,
  //                                     builder: (BuildContext context) =>
  //                                         AlertDialog(
  //                                           title: const Text("Confirm"),
  //                                           content: const Text.rich(TextSpan(
  //                                             text:
  //                                                 "Are you sure you want to delete your accout? ",
  //                                           )),
  //                                           actions: [
  //                                             TextButton(
  //                                                 onPressed: () {},
  //                                                 child: const Text("Yes")),
  //                                             TextButton(
  //                                                 onPressed: () {
  //                                                   Navigator.pop(context);
  //                                                 },
  //                                                 child: const Text("No")),
  //                                           ],
  //                                         ));
  //                               },
  //                               child: Text("Delete Account",
  //                                   style:
  //                                       TextStyle(color: Colors.red.shade900))),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void updateProfile(String email, String emergency) {
    setState(() {
      _isLoading = true;
    });
    UserEvent event = UserUpdate(User(
        firstName: widget.args.auth.name,
        lastName: widget.args.auth.lastName,
        phoneNumber: widget.args.auth.phoneNumber,
        gender: 'Male',
        id: widget.args.auth.id,
        email: email,
        emergencyContact: emergency));
    BlocProvider.of<UserBloc>(context).add(event);
  }
}


//old

// import 'package:driverapp/widgets/widgets.dart';
// import 'package:flutter/material.dart';

// class EditProfile extends StatelessWidget {
//   static const routeName = "/editaprofile";
//   final _textStyle =
//       const TextStyle(color: Colors.black12, fontWeight: FontWeight.bold);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//       children: [
//         CustomeBackArrow(),
//         Container(
//           height: MediaQuery.of(context).size.height,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.only(top: 180),
//             child: Column(
//               children: [
//                 const CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.black54,
//                   //backgroundImage: AssetImage("assetName"),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 _buildProfileItems(
//                     context: context,
//                     text: "Name",
//                     textfieldtext: "Eyob Tilahun"),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 _buildProfileItems(
//                     context: context,
//                     text: "Location",
//                     textfieldtext: "Addis Ababa, Ethiopi"),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 _buildProfileItems(
//                     context: context,
//                     text: "Email",
//                     textfieldtext: "Email@gmail.com"),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 _buildProfileItems(
//                     context: context,
//                     text: "Phone",
//                     textfieldtext: "+251934540217"),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 _buildProfileItems(
//                     context: context,
//                     text: "Password",
//                     textfieldtext: "Password"),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 SizedBox(
//                     height: 40,
//                     width: MediaQuery.of(context).size.width * 0.6,
//                     child: ElevatedButton(
//                         onPressed: () {},
//                         child: const Text("Save Changes",
//                             style: TextStyle(color: Colors.white)))),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.6,
//                   child: TextButton(
//                       style: ButtonStyle(
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(30))),
//                           side: MaterialStateProperty.all<BorderSide>(
//                               BorderSide(color: Colors.red.shade900))),
//                       onPressed: () {},
//                       child: Text("Delete Account",
//                           style: TextStyle(color: Colors.red.shade900))),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     ));
//   }

//   Widget _buildProfileItems(
//       {required BuildContext context,
//       required String text,
//       required String textfieldtext}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             text,
//             style: _textStyle,
//           ),
//           Container(
//               width: MediaQuery.of(context).size.width * 0.7,
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: "Full Name",
//                   hintStyle: TextStyle(
//                       fontWeight: FontWeight.w300, color: Colors.black45),
//                   // prefixIcon: Icon(
//                   //   Icons.vpn_key,
//                   //   size: 19,
//                   // ),
//                   fillColor: Colors.white,

//                   //filled: true,
//                   // border:
//                   //     OutlineInputBorder(borderSide: BorderSide.none)
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Please enter Your Name';
//                   }
//                   return null;
//                 },
//               ))
//         ],
//       ),
//     );
//   }
// }

// // Stack(
// //         children: [
// //           SingleChildScrollView(
// //             child: Container(
// //               child: Form(
// //                   child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   const CircleAvatar(
// //                     radius: 40,
// //                     backgroundImage: AssetImage("assetName"),
// //                   ),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Column(
// //                         children: [
// //                           Text(
// //                             "Name",
// //                             style: _textStyle,
// //                           ),
// //                           Text("Location", style: _textStyle),
// //                           Text("E-mail", style: _textStyle),
// //                           Text("Phone", style: _textStyle),
// //                           Text("Password", style: _textStyle),
// //                         ],
// //                       ),
// //                       Column(
// //                         children: [
// //                           TextFormField(),
// //                           TextFormField(),
// //                           TextFormField(),
// //                           TextFormField(),
// //                           TextFormField(),
// //                         ],
// //                       )
// //                     ],
// //                   ),
// //                   ElevatedButton(
// //                       onPressed: () {}, child: const Text("Save Changes")),
// //                   TextButton(
// //                       style: ButtonStyle(
// //                           side: MaterialStateProperty.all<BorderSide>(
// //                               BorderSide(color: Colors.red.shade900))),
// //                       onPressed: () {},
// //                       child: Text("Delete Account",
// //                           style: TextStyle(color: Colors.red.shade900)))
// //                 ],
// //               )),
// //             ),
// //           ),
// //           CustomeBackArrow()
// //         ],
// //       ),