import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/route.dart';

enum Gender { male, female }

class PreferenceScreen extends StatefulWidget {
  static const routeNAme = "/preferencescreen";
  final PreferenceArgument args;

  PreferenceScreen({Key? key, required this.args}) : super(key: key);
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  Gender? _gender = Gender.female;

  //int serviceName = -1;
  late String serviceName;
  late double min_rate;
  bool _isLoading = false;
  RangeValues rangeValues = const RangeValues(0, 60);

  @override
  void initState() {
    // TODO: implement initState
    print(widget.args.carType);
    serviceName = widget.args.carType;
    min_rate = widget.args.min_rate;
    switch (widget.args.gender) {
      case "Male":
        setState(() {
          _gender = Gender.male;
        });
        break;
      case "Female":
        setState(() {
          _gender = Gender.female;
        });
        break;
      case "Any":
        setState(() {
          _gender = null;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body: BlocConsumer<UserBloc, UserState>(builder: (_, state) {
        return _buildScreen();
      }, listener: (_, state) {
        if (state is UserLoading) {
          _isLoading = true;
        }

        if (state is UserPreferenceUploadSuccess) {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Successfull"),
            backgroundColor: Colors.green,
          ));

          Future.delayed(Duration(seconds: 1), () {
            BlocProvider.of<AuthBloc>(context).add(AuthDataLoad());
          });
        }

        if (state is UserOperationFailure) {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Error Updating"),
            backgroundColor: Colors.red.shade900,
          ));
        }
      }),
    );
  }

  Widget _buildScreen() {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 120, bottom: 20),
                      child: Text(
                        "Passenger Gender",
                        style: TextStyle(
                            color: Colors.white24,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Radio<Gender>(
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.white),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.white),
                                value: Gender.male,
                                groupValue: _gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    print(value);
                                    _gender = value!;
                                  });
                                }),
                            const Text(
                              "Male",
                              style: TextStyle(
                                  color: Colors.white24, fontSize: 10),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Radio<Gender>(
                                toggleable: true,
                                activeColor: Colors.white,
                                fillColor: MaterialStateProperty.all<Color>(
                                    Colors.white),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.white),
                                value: Gender.female,
                                groupValue: _gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                }),
                            const Text(
                              "Female",
                              style: TextStyle(
                                  color: Colors.white24, fontSize: 10),
                            )
                          ],
                        ),
                        // RadioListTile(
                        //   value: true,
                        //   groupValue: true,
                        //   onChanged: (value) {},
                        // ),
                        // RadioListTile(
                        //   value: true,
                        //   groupValue: true,
                        //   onChanged: (value) {},
                        // ),
                      ],
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.only(top: 20, bottom: 20),
                    //   child: Text(
                    //     "Minimum Rating",
                    //     style: TextStyle(
                    //         color: Colors.white24,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16),
                    //   ),
                    // ),
                    // RatingBar.builder(
                    //     initialRating: widget.args.min_rate,
                    //     minRating: 1,
                    //     direction: Axis.horizontal,
                    //     allowHalfRating: true,
                    //     itemCount: 5,
                    //     //itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    //     itemBuilder: (context, _) =>
                    //         Icon(Icons.star, color: Colors.white),
                    //     onRatingUpdate: (rating) {
                    //       min_rate = rating;
                    //       print(rating);
                    //     }),
                    // //_buildVihcleTypeList(),
                    // const Padding(
                    //   padding: EdgeInsets.only(top: 40, bottom: 20),
                    //   child: Text(
                    //     "Services",
                    //     style: TextStyle(
                    //         color: Colors.white24,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16),
                    //   ),
                    // ),
                    // //row

                    // _buildServiceTypeItems(),
                  ],
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () {
                      updatePreference();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text(
                          "Apply",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                )
                              : Container(),
                        )
                      ],
                    )))
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 60),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Preference",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Positioned(
            top: 50,
            right: 10,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                )))
      ],
    );
  }

  void updatePreference() {
    UserEvent event = UserPreferenceUpdate(User(preference: {
      "gender": _gender == Gender.male ? "Male" : "Female",
      "min_rate": min_rate,
      "car_type": serviceName
    }));

    BlocProvider.of<UserBloc>(context).add(event);
  }

  Widget _buildVihcleTypeList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.local_taxi_rounded,
              color: Colors.white,
              size: 35,
            ),
            Checkbox(
              side: const BorderSide(width: 1, color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              value: true,
              onChanged: (value) {},
              fillColor: MaterialStateProperty.all<Color>(Colors.white),
              checkColor: Colors.red,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.car_rental,
              color: Colors.white,
              size: 35,
            ),
            Checkbox(
              side: const BorderSide(width: 1, color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              value: false,
              onChanged: (value) {},
              fillColor: MaterialStateProperty.all<Color>(Colors.white),
              checkColor: Colors.red,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildServiceTypeItems() {
    final _selectedDecoration = BoxDecoration(
        color: Colors.white, border: Border.all(color: Colors.red, width: 1));
    final _unselectedDecoration = BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white24, width: 1));
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: serviceName == "Economy"
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white24, width: 1)),
                child: IconButton(
                    iconSize: serviceName == "Economy" ? 50 : 40,
                    onPressed: () {
                      setState(() {
                        serviceName = "Economy";
                      });
                    },
                    icon: Icon(Icons.supervised_user_circle,
                        color: serviceName == "Economy"
                            ? Colors.red
                            : Colors.white)),
              ),
              const Text(
                "Economy",
                style: TextStyle(color: Colors.white24, fontSize: 10),
              )
            ],
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: serviceName == "Arround the clock"
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white24, width: 1)),
                child: IconButton(
                    iconSize: serviceName == "Arround the clock" ? 50 : 40,
                    onPressed: () {
                      setState(() {
                        serviceName = "Arroun the clock";
                        //serviceName = 1;
                      });
                    },
                    icon: Icon(
                      Icons.lock_clock_outlined,
                      color: serviceName == "Arround the clock"
                          ? Colors.red
                          : Colors.white,
                    )),
              ),
              const Text(
                "Arround the clock",
                style: TextStyle(color: Colors.white24, fontSize: 10),
              )
            ],
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: serviceName == "Secure"
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white24, width: 1)),
                child: IconButton(
                    iconSize: serviceName == "Secure" ? 50 : 40,
                    onPressed: () {
                      setState(() {
                        serviceName = "Secure";
                        //serviceName = 2;
                      });
                    },
                    icon: Icon(
                      Icons.lock_clock_outlined,
                      color:
                          serviceName == "Secure" ? Colors.red : Colors.white,
                    )),
              ),
              const Text(
                "Secure",
                style: TextStyle(color: Colors.white24, fontSize: 10),
              )
            ],
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: serviceName == "Disabled Parking"
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white24, width: 1)),
                child: IconButton(
                    iconSize: serviceName == "Disabled Parking" ? 50 : 40,
                    onPressed: () {
                      setState(() {
                        serviceName = "Disabled Parking";
                        //serviceName = 3;
                      });
                    },
                    icon: Icon(
                      Icons.lock_clock_outlined,
                      color: serviceName == "Disabled Parking"
                          ? Colors.red
                          : Colors.white,
                    )),
              ),
              const Text(
                "Disabled parking",
                style: TextStyle(color: Colors.white24, fontSize: 10),
              )
            ],
          ),
        ],
      ),
    );
  }
}
