import 'package:driverapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  static const routeName = "/editaprofile";
  final _textStyle =
      const TextStyle(color: Colors.black12, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        CustomeBackArrow(),
        Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 180),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black54,
                  //backgroundImage: AssetImage("assetName"),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildProfileItems(
                    context: context,
                    text: "Name",
                    textfieldtext: "Eyob Tilahun"),
                SizedBox(
                  height: 10,
                ),
                _buildProfileItems(
                    context: context,
                    text: "Location",
                    textfieldtext: "Addis Ababa, Ethiopi"),
                SizedBox(
                  height: 10,
                ),
                _buildProfileItems(
                    context: context,
                    text: "Email",
                    textfieldtext: "Email@gmail.com"),
                SizedBox(
                  height: 10,
                ),
                _buildProfileItems(
                    context: context,
                    text: "Phone",
                    textfieldtext: "+251934540217"),
                SizedBox(
                  height: 10,
                ),
                _buildProfileItems(
                    context: context,
                    text: "Password",
                    textfieldtext: "Password"),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Save Changes",
                            style: TextStyle(color: Colors.white)))),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: Colors.red.shade900))),
                      onPressed: () {},
                      child: Text("Delete Account",
                          style: TextStyle(color: Colors.red.shade900))),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildProfileItems(
      {required BuildContext context,
      required String text,
      required String textfieldtext}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: _textStyle,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Full Name",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.black45),
                  // prefixIcon: Icon(
                  //   Icons.vpn_key,
                  //   size: 19,
                  // ),
                  fillColor: Colors.white,

                  //filled: true,
                  // border:
                  //     OutlineInputBorder(borderSide: BorderSide.none)
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Your Name';
                  }
                  return null;
                },
              ))
        ],
      ),
    );
  }
}

// Stack(
//         children: [
//           SingleChildScrollView(
//             child: Container(
//               child: Form(
//                   child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 40,
//                     backgroundImage: AssetImage("assetName"),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             "Name",
//                             style: _textStyle,
//                           ),
//                           Text("Location", style: _textStyle),
//                           Text("E-mail", style: _textStyle),
//                           Text("Phone", style: _textStyle),
//                           Text("Password", style: _textStyle),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           TextFormField(),
//                           TextFormField(),
//                           TextFormField(),
//                           TextFormField(),
//                           TextFormField(),
//                         ],
//                       )
//                     ],
//                   ),
//                   ElevatedButton(
//                       onPressed: () {}, child: const Text("Save Changes")),
//                   TextButton(
//                       style: ButtonStyle(
//                           side: MaterialStateProperty.all<BorderSide>(
//                               BorderSide(color: Colors.red.shade900))),
//                       onPressed: () {},
//                       child: Text("Delete Account",
//                           style: TextStyle(color: Colors.red.shade900)))
//                 ],
//               )),
//             ),
//           ),
//           CustomeBackArrow()
//         ],
//       ),