import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:wanderly/core/theme/app_colors.dart';
import 'package:wanderly/core/theme/app_text.dart';
import 'package:wanderly/features/trip/data/trip_enums.dart';
import 'package:wanderly/features/trip/provider/trip_filter_sort_provider.dart';

class TripFilterSortWidget extends ConsumerWidget {
  const TripFilterSortWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterSort = ref.watch(tripFilterSortProvider);
    final c = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Filter Chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Status',
                style: AppTextStyles.bodyBold(context),
              ),
              SizedBox(height: Adaptive.sh(1)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // "All" chip
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: const Text('All'),
                        selected: filterSort.selectedStatus == null,
                        onSelected: (_) {
                          ref
                              .read(tripFilterSortProvider.notifier)
                              .setStatusFilter(null);
                        },
                        backgroundColor: Colors.transparent,
                        selectedColor: c.primary.withValues(alpha: 0.2),
                        side: BorderSide(
                          color: filterSort.selectedStatus == null
                              ? c.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    // Status chips
                    ...TripStatus.values.map((status) {
                      final isSelected = filterSort.selectedStatus == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(status.displayName),
                          selected: isSelected,
                          onSelected: (_) {
                            ref
                                .read(tripFilterSortProvider.notifier)
                                .toggleStatusFilter(status);
                          },
                          backgroundColor: Colors.transparent,
                          selectedColor: c.primary.withValues(alpha: 0.2),
                          side: BorderSide(
                            color: isSelected
                                ? c.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Adaptive.sh(2)),

        // Sort Dropdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort by',
                style: AppTextStyles.bodyBold(context),
              ),
              SizedBox(height: Adaptive.sh(0.5)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<TripSortBy>(
                  value: filterSort.sortBy,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: TripSortBy.values.map((sortBy) {
                    return DropdownMenuItem(
                      value: sortBy,
                      child: Text(sortBy.displayName),
                    );
                  }).toList(),
                  onChanged: (sortBy) {
                    if (sortBy != null) {
                      ref
                          .read(tripFilterSortProvider.notifier)
                          .setSortBy(sortBy);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Adaptive.sh(1.5)),
      ],
    );
  }
}
