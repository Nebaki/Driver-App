import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/bloc/bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/init/route.dart';

enum Gender { male, female }

class PreferenceScreen extends StatefulWidget {
  static const routeNAme = "/preferencescreen";
  final PreferenceArgument args;

  const PreferenceScreen({Key? key, required this.args}) : super(key: key);
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
    super.initState();
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

          Future.delayed(const Duration(seconds: 1), () {
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
                      ],
                    ),
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


}
