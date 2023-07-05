import 'package:flutter/material.dart';
import 'package:maps/models/user.dart';
import 'package:maps/providers/float_height.dart';
import 'package:maps/providers/server.dart';
import 'package:maps/providers/user.dart';
import 'package:maps/utils/button.dart';
import 'package:maps/utils/role.dart';
import 'package:maps/utils/vehicle.dart';
import 'package:maps/widgets/edit_profile.dart';
import 'package:maps/widgets/my_button.dart';
import 'package:provider/provider.dart';
import 'package:maps/widgets/shimmer.dart';

class MyDraggableSheet extends StatefulWidget {
  const MyDraggableSheet({super.key});
  @override
  State<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  void changeHeight() {
    Provider.of<FloatingHeight>(context, listen: false)
        .setHeight(_controller.pixels);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(changeHeight);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showEditProfile() {
    showDialog(
      context: context,
      builder: (context) => EditProfile(),
    );
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
                      borderRadius: const BorderRadius.vertical(
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
                            children: [
                              Icon(
                                user.role == UserRole.driver
                                    ? Icons.drive_eta_rounded
                                    : Icons.person_2_rounded,
                                size: 35,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                user.role == UserRole.driver
                                    ? "Driver"
                                    : "Passenger",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              user.destination == null
                                  ? Switch(
                                      value: false,
                                      onChanged: (value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Select a point on the map to set destination.'),
                                          ),
                                        );
                                      })
                                  : (user.connectionState ==
                                          ConnectionState.waiting
                                      ? MyShimmer(width: 60, height: 30)
                                      : Switch(
                                          value: true,
                                          onChanged: (value) {
                                            user.cancelDestination();
                                            Provider.of<Server>(context,
                                                    listen: false)
                                                .socket
                                                .sink
                                                .close();
                                          })),
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
                              (user.role == UserRole.driver
                                  ? Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MyButton(
                                          label:
                                              "${user.vehicleIndex == null ? "Set" : "Edit"} Profile",
                                          buttonType: ButtonType.secondary,
                                          icon: Icons.edit_square,
                                          function: () {
                                            if (user.destination == null) {
                                              _controller.reset();
                                              showEditProfile();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Please cancel destination before modifying profile!'),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  : const SizedBox()),
                              const SizedBox(
                                height: 10,
                              ),
                              (user.role == UserRole.driver
                                  ? MyButton(
                                      label: "Switch to passenger",
                                      icon: Icons.loop,
                                      function: () {
                                        if (user.destination == null) {
                                          _controller.reset();
                                          user.setUserRole(UserRole.passenger);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'Please cancel destination before switching role!'),
                                              action: SnackBarAction(
                                                  label: 'Cancel destination',
                                                  onPressed: () {
                                                    user.cancelDestination();
                                                    Provider.of<Server>(context,
                                                            listen: false)
                                                        .socket
                                                        .sink
                                                        .close();
                                                  }),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  : MyButton(
                                      label: "Switch to driver",
                                      icon: Icons.loop,
                                      function: () {
                                        if (user.destination == null) {
                                          _controller.reset();
                                          user.setUserRole(UserRole.driver);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'Please cancel destination before switching role!'),
                                              action: SnackBarAction(
                                                  label: 'Cancel destination',
                                                  onPressed: () =>
                                                      user.cancelDestination()),
                                            ),
                                          );
                                        }
                                      },
                                    )),
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
