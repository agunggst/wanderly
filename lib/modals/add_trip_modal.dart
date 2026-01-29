import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wanderly/data/trip_model.dart';
import 'package:wanderly/helper/date_range_to_string_formatter.dart';
import 'package:wanderly/helper/parse_date_range.dart';
import 'package:wanderly/style/app_colors.dart';
import 'package:wanderly/style/app_text.dart';

class AddTripModal extends StatefulWidget {
  final Trip? trip;
  final Function(Trip) onSubmit;

  const AddTripModal({
    super.key,
    this.trip,
    required this.onSubmit,
  });

  @override
  State<AddTripModal> createState() => _AddTripModalState();
}

class _AddTripModalState extends State<AddTripModal> {
  late TextEditingController titleController;
  DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.trip?.title ?? '',
    );

    if (widget.trip != null) {
      selectedRange = parseDateRange(widget.trip!.date);
    }
  }

  void submit() {
    if (titleController.text.isEmpty || selectedRange == null) return;

    final trip = Trip(
      title: titleController.text,
      date: dateRangeToStringFormatter(selectedRange!),
      imageUrl: widget.trip?.imageUrl ??
          'https://picsum.photos/600/400?${Random().nextInt(20)}',
      status: 'Planning',
      members: widget.trip?.members ??
          [
            'https://i.pravatar.cc/100?${Random().nextInt(10)}',
            'https://i.pravatar.cc/100?${Random().nextInt(10)}',
          ],
    );

    widget.onSubmit(trip);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final c = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DRAG HANDLE
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            Text(
              widget.trip == null ? "Add New Trip" : "Edit Trip",
              style: AppTextStyles.bodyBold(context),
            ),

            const SizedBox(height: 16),

            /// TITLE
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Trip title",
                filled: true,
                fillColor: c.textPrimary.withValues(alpha: .08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// DATE RANGE
            GestureDetector(
              onTap: () async {
                final now = DateTime.now();

                final result = await showDateRangePicker(
                  context: context,
                  firstDate: now,
                  lastDate: DateTime(now.year + 2),
                );

                if (result != null) {
                  setState(() {
                    selectedRange = result;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: c.textPrimary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedRange == null
                          ? "Select date range"
                          : dateRangeToStringFormatter(selectedRange!),
                      style: AppTextStyles.body(context),
                    ),
                    const Icon(Icons.date_range),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Save Trip",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
