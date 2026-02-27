# Trip Sorting and Filtering Feature

## Overview

Added comprehensive sorting and filtering capabilities to the Wanderly app using Riverpod state management. Users can now filter trips by status (Upcoming, Ongoing, Completed) and sort by various criteria.

## Features Implemented

### ✅ Filtering by Status
- **Upcoming**: Trips that haven't started yet
- **Ongoing**: Trips currently in progress
- **Completed**: Trips that have ended
- **All**: Show all trips (default)

### ✅ Sorting Options
- **Date: Earliest First** (default) - Sort by trip start date ascending
- **Date: Latest First** - Sort by trip start date descending
- **Title: A-Z** - Alphabetical order
- **Title: Z-A** - Reverse alphabetical order
- **Newest First** - Recently created trips first
- **Oldest First** - Oldest created trips first

### ✅ Search Functionality
- Real-time search by trip title
- Works in combination with filters and sorting

### ✅ Active Filters Display
- Shows currently applied filters as chips
- Quick remove button for each filter

## Files Created

### 1. `lib/features/trip/data/trip_enums.dart`
Enums for status and sorting options:
```dart
enum TripStatus {
  upcoming('Upcoming'),
  ongoing('Ongoing'),
  completed('Completed');
}

enum TripSortBy {
  dateAscending('Date: Earliest First'),
  dateDescending('Date: Latest First'),
  titleAscending('Title: A-Z'),
  titleDescending('Title: Z-A'),
  createdNewest('Newest First'),
  createdOldest('Oldest First');
}
```

### 2. `lib/core/utils/trip_date_utils.dart`
Utility class for date parsing and status determination:
- `getStartDate(dateString)` - Extract start date from date range string
- `getEndDate(dateString)` - Extract end date from date range string
- `determineTripStatus(dateString)` - Automatically determine trip status based on current date

### 3. `lib/features/trip/provider/trip_filter_sort_provider.dart`
Riverpod state management for filters and sorting:
- `TripFilterSortState` - State class holding current filters and sort option
- `TripFilterSortNotifier` - Notifier for managing state changes
- `tripFilterSortProvider` - Provider for accessing filter/sort state

### 4. `lib/features/trip/provider/filtered_sorted_trips_provider.dart`
Provider that combines trips with filtering and sorting:
- Watches `tripListProvider` for trips
- Watches `tripFilterSortProvider` for filter/sort state
- Returns filtered and sorted trips

### 5. `lib/features/trip/view/widgets/trip_filter_sort_widget.dart`
UI widget for filter and sort controls:
- Status filter chips
- Sort dropdown
- Real-time state updates

## Files Modified

### 1. `lib/features/trip/view/screens/home_screen.dart`
- Changed from `ConsumerWidget` to `ConsumerStatefulWidget`
- Added filter toggle button
- Integrated `filteredSortedTripsProvider`
- Added active filters display
- Improved empty state messaging
- Added search input with real-time filtering

### 2. `lib/shared/widgets/custom_text_input.dart`
- Added `onChanged` callback parameter
- Allows real-time search input handling

## How It Works

### State Management Flow

```
User Action (Filter/Sort/Search)
    ↓
tripFilterSortProvider (Riverpod State)
    ↓
filteredSortedTripsProvider (Computed Provider)
    ↓
Filtering Logic Applied
    ↓
Sorting Logic Applied
    ↓
UI Updates with Filtered/Sorted Trips
```

### Filtering Process

1. **Status Filter**: Compares trip's determined status with selected filter
2. **Search Filter**: Checks if trip title contains search query (case-insensitive)
3. **Combined**: Both filters applied together (AND logic)

### Sorting Process

Trips are sorted based on selected `TripSortBy` option:
- Date-based: Uses parsed start date from date range string
- Title-based: String comparison
- Created-based: Uses `createdAt` timestamp

### Status Determination

Automatically calculated based on trip dates:
```dart
// Completed: end date is in the past
if (endDate.isBefore(now)) return TripStatus.completed;

// Ongoing: start date is past, end date is future
if (startDate.isBefore(now) && endDate.isAfter(now)) 
  return TripStatus.ongoing;

// Upcoming: start date is in the future
return TripStatus.upcoming;
```

## Usage Examples

### Filter by Status

```dart
// Set filter to show only upcoming trips
ref.read(tripFilterSortProvider.notifier)
    .setStatusFilter(TripStatus.upcoming);

// Clear filter to show all trips
ref.read(tripFilterSortProvider.notifier)
    .setStatusFilter(null);

// Toggle filter (select/deselect)
ref.read(tripFilterSortProvider.notifier)
    .toggleStatusFilter(TripStatus.ongoing);
```

### Change Sort Order

```dart
// Sort by date descending
ref.read(tripFilterSortProvider.notifier)
    .setSortBy(TripSortBy.dateDescending);

// Sort by title A-Z
ref.read(tripFilterSortProvider.notifier)
    .setSortBy(TripSortBy.titleAscending);
```

### Search Trips

```dart
// Set search query
ref.read(tripFilterSortProvider.notifier)
    .setSearchQuery('Summer');

// Clear search
ref.read(tripFilterSortProvider.notifier)
    .setSearchQuery('');
```

### Reset All Filters

```dart
ref.read(tripFilterSortProvider.notifier).reset();
```

### Watch Filtered Trips

```dart
// In a widget
final filteredTrips = ref.watch(filteredSortedTripsProvider);

filteredTrips.when(
  data: (trips) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

## UI Components

### Filter Toggle Button
- Located next to search input
- Shows filter icon
- Toggles filter panel visibility

### Status Filter Chips
- "All" chip to show all trips
- Individual chips for each status
- Selected state highlighted
- Tap to select/deselect

### Sort Dropdown
- Dropdown menu with all sort options
- Shows current selection
- Tap to change sort order

### Active Filters Display
- Shows currently applied filters as chips
- Each chip has a delete button
- Quick way to remove individual filters

### Empty State
- Shows different messages based on filters
- "No trips found" with suggestion to adjust filters
- "Create your first trip!" when no filters applied

## Performance Considerations

### Efficient Filtering
- Filtering happens in a computed provider (only recalculates when dependencies change)
- No unnecessary rebuilds
- Riverpod handles memoization

### Date Parsing
- Date parsing happens once per trip
- Results can be cached if needed
- Efficient string parsing with error handling

### Search Performance
- Case-insensitive search
- Works on trip title only
- Real-time updates with debouncing possible

## Testing Scenarios

### Test Status Filtering
1. Create trips with different date ranges
2. Click filter button to show filter panel
3. Select "Upcoming" - should show only future trips
4. Select "Ongoing" - should show current trips
5. Select "Completed" - should show past trips
6. Click "All" - should show all trips

### Test Sorting
1. Create multiple trips with different titles and dates
2. Change sort order from dropdown
3. Verify trips reorder correctly
4. Try different sort options

### Test Search
1. Type in search box
2. Trips filter in real-time
3. Clear search - all trips reappear
4. Search works with filters applied

### Test Combined Filters
1. Select status filter
2. Enter search query
3. Both filters applied together
4. Remove one filter - other still active

## API Reference

### TripFilterSortNotifier Methods

```dart
// Set status filter
void setStatusFilter(TripStatus? status)

// Set sort option
void setSortBy(TripSortBy sortBy)

// Set search query
void setSearchQuery(String query)

// Reset all filters and sort
void reset()

// Toggle status filter
void toggleStatusFilter(TripStatus status)
```

### TripDateUtils Methods

```dart
// Get start date from date range string
static DateTime? getStartDate(String dateString)

// Get end date from date range string
static DateTime? getEndDate(String dateString)

// Determine trip status based on dates
static TripStatus determineTripStatus(String dateString)
```

### Providers

```dart
// Filter and sort state
final tripFilterSortProvider = StateNotifierProvider<...>

// Filtered and sorted trips
final filteredSortedTripsProvider = Provider<AsyncValue<List<Trip>>>
```

## File Structure

```
lib/
├── core/
│   └── utils/
│       └── trip_date_utils.dart                    ✨ NEW
├── features/
│   └── trip/
│       ├── data/
│       │   └── trip_enums.dart                     ✨ NEW
│       ├── provider/
│       │   ├── trip_filter_sort_provider.dart      ✨ NEW
│       │   └── filtered_sorted_trips_provider.dart ✨ NEW
│       └── view/
│           ├── screens/
│           │   └── home_screen.dart                ✏️ MODIFIED
│           └── widgets/
│               └── trip_filter_sort_widget.dart    ✨ NEW
└── shared/
    └── widgets/
        └── custom_text_input.dart                  ✏️ MODIFIED
```

## Future Enhancements

1. **Advanced Filtering**
   - Filter by number of members
   - Filter by date range
   - Filter by trip status (Planning, Confirmed, etc.)

2. **Saved Filters**
   - Save favorite filter combinations
   - Quick access to saved filters

3. **Sorting Enhancements**
   - Sort by trip duration
   - Sort by number of members
   - Custom sort order

4. **Search Improvements**
   - Search by location
   - Search by members
   - Full-text search

5. **Analytics**
   - Track most used filters
   - Track most used sort options
   - User preferences

## Troubleshooting

### Filters not working
- Check that `tripFilterSortProvider` is being watched
- Verify `filteredSortedTripsProvider` is used instead of `tripListProvider`
- Check browser console for errors

### Status not updating
- Ensure trip dates are in correct format
- Check `TripDateUtils.determineTripStatus()` logic
- Verify current date/time is correct

### Search not working
- Check `onChanged` callback is connected
- Verify search query is being set in provider
- Check search is case-insensitive

### Performance issues
- Limit number of trips displayed
- Implement pagination
- Use `debounce` for search input

## Support

For issues or questions:
1. Check the implementation files
2. Review Riverpod documentation: https://riverpod.dev
3. Check Flutter documentation: https://flutter.dev
