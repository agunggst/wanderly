import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wanderly/features/trip/provider/trip_provider.dart';
import 'package:wanderly/features/trip/data/trip_model.dart';
import 'package:wanderly/features/trip/view/screens/manage_trip_modal.dart';
import 'package:wanderly/core/theme/app_colors.dart';
import 'package:wanderly/core/theme/app_text.dart';
import 'package:wanderly/shared/widgets/confirmation_dialog.dart';
import 'package:wanderly/shared/widgets/custom_app_bar.dart';
import 'package:wanderly/shared/widgets/custom_text_input.dart';
import 'package:wanderly/features/trip/view/widgets/trip_card.dart';

class HomeScreen extends ConsumerWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripListProvider);
    final c = AppColors.of(context);
    final searchInputController = TextEditingController();

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
                child: tripAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(e.toString())),
                  data: (trips) {
                    if (trips.isEmpty) {
                      return const Center(child: Text("No trips yet"));
                    }

                    return ListView.separated(
                      itemCount: trips.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final trip = trips[index];

                        return TripCard(
                          trip: trip,
                          onDelete: () async {
                            final confirm = await showConfirmDialog(
                              context,
                              title: "Delete Trip",
                              message: "This trip will be permanently deleted.",
                              confirmText: "Delete",
                            );
                            if (!confirm) return;
                            ref
                                .read(tripListProvider.notifier)
                                .deleteTrip(trip.id);
                          },
                          onEdit: () {
                            showAddTripModal(
                              context,
                              trip: trip,
                              onSubmit: (updatedTrip) {
                                ref
                                    .read(tripListProvider.notifier)
                                    .updateTrip(updatedTrip);
                              },
                            );
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
        onDestinationSelected: (_) {},
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
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTripModal(
              onSubmit: (trip) {
                ref.read(tripListProvider.notifier).addTrip(trip);
              },
            ),
          );
        },
        backgroundColor: c.background,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32),
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
