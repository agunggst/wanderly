import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wanderly/features/trip/provider/trip_provider.dart';
import 'package:wanderly/features/trip/provider/filtered_sorted_trips_provider.dart';
import 'package:wanderly/features/trip/provider/trip_filter_sort_provider.dart';
import 'package:wanderly/features/trip/data/trip_model.dart';
import 'package:wanderly/features/trip/view/screens/manage_trip_modal.dart';
import 'package:wanderly/core/theme/app_colors.dart';
import 'package:wanderly/core/theme/app_text.dart';
import 'package:wanderly/shared/widgets/confirmation_dialog.dart';
import 'package:wanderly/shared/widgets/custom_app_bar.dart';
import 'package:wanderly/shared/widgets/custom_text_input.dart';
import 'package:wanderly/features/trip/view/widgets/trip_card.dart';
import 'package:wanderly/features/trip/view/widgets/trip_filter_sort_widget.dart';
import 'package:wanderly/features/trip/data/trip_enums.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController searchInputController;
  bool showFilters = true;

  @override
  void initState() {
    super.initState();
    searchInputController = TextEditingController();
  }

  @override
  void dispose() {
    searchInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(filteredSortedTripsProvider);
    final filterSort = ref.watch(tripFilterSortProvider);
    final c = AppColors.of(context);

    return Scaffold(
      appBar: CustomAppBar(height: Adaptive.h(8)),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Toggle
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: CustomTextInput(
            //           label: "",
            //           hint: "Search your adventures...",
            //           controller: searchInputController,
            //           onChanged: (value) {
            //             ref
            //                 .read(tripFilterSortProvider.notifier)
            //                 .setSearchQuery(value);
            //           },
            //         ),
            //       ),
            //       SizedBox(width: Adaptive.w(2)),
            //       GestureDetector(
            //         onTap: () {
            //           setState(() => showFilters = !showFilters);
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             border: Border.all(color: Colors.grey.shade300),
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: Icon(
            //             showFilters ? Icons.filter_list : Icons.filter_list_outlined,
            //             color: c.primary,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Filter and Sort Widget
            if (showFilters)
              const TripFilterSortWidget(),

            // Active Filters Display
            if (filterSort.selectedStatus != null ||
                filterSort.sortBy != TripSortBy.dateAscending)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (filterSort.selectedStatus != null)
                      Chip(
                        label: Text(filterSort.selectedStatus!.displayName),
                        onDeleted: () {
                          ref
                              .read(tripFilterSortProvider.notifier)
                              .setStatusFilter(null);
                        },
                      ),
                    SizedBox(width: Adaptive.w(2)),
                    if (filterSort.sortBy != TripSortBy.dateAscending)
                      Chip(
                        label: Text(filterSort.sortBy.displayName),
                        onDeleted: () {
                          ref
                              .read(tripFilterSortProvider.notifier)
                              .setSortBy(TripSortBy.dateAscending);
                        },
                      ),
                  ],
                ),
              ),

            SizedBox(height: Adaptive.sh(1)),

            // Trips List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: tripsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text(e.toString())),
                  data: (trips) {
                    if (trips.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.luggage_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: Adaptive.sh(2)),
                            Text(
                              "No trips found",
                              style: AppTextStyles.bodyBold(context),
                            ),
                            SizedBox(height: Adaptive.sh(1)),
                            Text(
                              filterSort.selectedStatus != null ||
                                      filterSort.searchQuery.isNotEmpty
                                  ? "Try adjusting your filters"
                                  : "Create your first trip!",
                              style: AppTextStyles.caption(context),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: trips.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final trip = trips[index];

                        return TripCard(
                          trip: trip,
                          onDelete: () async {
                            final confirm = await showConfirmDialog(
                              context,
                              title: "Delete Trip",
                              message:
                                  "This trip will be permanently deleted.",
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
            ),
          ],
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
