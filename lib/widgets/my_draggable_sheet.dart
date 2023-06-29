import 'package:flutter/material.dart';
import 'package:maps/logic/float_height.dart';
import 'package:maps/logic/user.dart';
import 'package:maps/utils/button.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/utils/vehicle.dart';
import 'package:maps/widgets/edit_profile.dart';
import 'package:maps/widgets/my_button.dart';
import 'package:provider/provider.dart';

class MyDraggableSheet extends StatefulWidget {
  const MyDraggableSheet({super.key});
  @override
  State<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      Provider.of<FLoatingHeight>(context, listen: false)
          .setHeight(_controller.pixels);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<User>(
      builder: ((context, user, child) {
        return DraggableScrollableSheet(
          initialChildSize: 85 / screenHeight,
          minChildSize: 85 / screenHeight,
          maxChildSize: user.role == UserRole.driver
              ? 230 / screenHeight
              : 170 / screenHeight,
          snap: true,
          controller: _controller,
          builder: (BuildContext context, ScrollController controller) {
            return SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 2,
                          offset: Offset(0, -2),
                        )
                      ],
                      color: Theme.of(context).canvasColor,
                    ),
                    height: 20,
                    child: Center(
                        child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    user.role == UserRole.driver
                                        ? "Driver"
                                        : "Passenger",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).highlightColor,
                          thickness: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              user.role == UserRole.driver
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        MyButton(
                                          label: "Edit Profile",
                                          buttonType: ButtonType.secondary,
                                          icon: Icons.edit_square,
                                          function: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => EditProfile(
                                                vehicle: user.vehicle,
                                                changeVehicle:
                                                    (Vehicle vehicle) => {
                                                  user.setVehicle(
                                                    vehicle.vehicleType,
                                                    vehicle.noOfSeaters,
                                                  ),
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 10,
                              ),
                              user.role == UserRole.driver
                                  ? MyButton(
                                      label: "Switch to passenger",
                                      icon: Icons.loop,
                                      function: () {
                                        user.setUserRole(UserRole.passenger);
                                      },
                                    )
                                  : MyButton(
                                      label: "Switch to driver",
                                      icon: Icons.loop,
                                      function: () {
                                        user.setUserRole(UserRole.driver);
                                      },
                                    ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
