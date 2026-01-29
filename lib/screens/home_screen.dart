import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
// import 'package:wanderly/data/trip_dummy.dart';
import 'package:wanderly/data/trip_model.dart';
import 'package:wanderly/modals/add_trip_modal.dart';
import 'package:wanderly/style/app_colors.dart';
import 'package:wanderly/style/app_text.dart';
import 'package:wanderly/widgets/custom_app_bar.dart';
import 'package:wanderly/widgets/custom_text_input.dart';
import 'package:wanderly/widgets/trip_card.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchInputController = TextEditingController();

  final List<Trip> dummyTrips = [
    Trip(
      title: 'Paris Getaway',
      date: 'Oct 12 - Oct 18, 2024',
      imageUrl: 'https://picsum.photos/600/400?1',
      status: '6 Days Left',
      members: [
        'https://i.pravatar.cc/100?1',
        'https://i.pravatar.cc/100?2',
      ],
    ),
    Trip(
      title: 'Tokyo Adventure',
      date: 'Dec 01 - Dec 15, 2024',
      imageUrl: 'https://picsum.photos/600/400?2',
      status: 'Planning',
      members: [
        'https://i.pravatar.cc/100?3',
      ],
    ),
    Trip(
      title: 'Tokyo Adventure',
      date: 'Dec 01 - Dec 15, 2024',
      imageUrl: 'https://picsum.photos/600/400?3',
      status: 'Planning',
      members: [
        'https://i.pravatar.cc/100?4',
        'https://i.pravatar.cc/100?5',
      ],
    ),
  ];

  @override
  void dispose() {
    searchInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);

    return Scaffold(
      appBar: CustomAppBar(height: Adaptive.h(8)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextInput(
                label: "",
                hint: "Search your adventures...",
                controller: searchInputController,
              ),
              SizedBox(height: Adaptive.sh(1)),
              Text(
                "Upcoming Trips",
                style: AppTextStyles.sectionHeading(context),
              ),
              SizedBox(height: Adaptive.sh(1)),
              Expanded(
                child: ListView.separated(
                  itemCount: dummyTrips.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return TripCard(
                      trip: dummyTrips[index],
                      onDelete: () {
                        setState(() {
                          dummyTrips.removeAt(index);
                        });
                      },
                      onEdit: () {
                        showAddTripModal(
                          context,
                          trip: dummyTrips[index],
                          onSubmit: (updatedTrip) {
                            setState(() {
                              dummyTrips[index] = updatedTrip;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {},
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Explore',
          ),
        ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTripModal(
              onSubmit: (trip) {
                setState(() {
                  dummyTrips.add(trip);
                });
              },
            ),
          );
        },
        backgroundColor: c.background,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32,),
      ),
    );
  }
}

void showAddTripModal(
  BuildContext context, {
  Trip? trip,
  required Function(Trip) onSubmit,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddTripModal(
      trip: trip,
      onSubmit: onSubmit,
    ),
  );
}
