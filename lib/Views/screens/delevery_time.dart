import 'package:flutter/material.dart';
import 'package:hezmaa/Services/get_time.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:intl/intl.dart';

class DeliveryTimeWidget extends StatefulWidget {
  final Function(DateTime, int?) onDateSelected;

  const DeliveryTimeWidget({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  _DeliveryTimeWidgetState createState() => _DeliveryTimeWidgetState();
}

class _DeliveryTimeWidgetState extends State<DeliveryTimeWidget> {
  DateTime? selectedDate;
  int? selectedButtonIndex;
  int? selectedTimeId;
  List<Map<String, dynamic>> availableTimes = [];

  final TimeService timeService = TimeService();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedButtonIndex = null;
  }

  Future<void> _onDateButtonPressed(int daysToAdd, int buttonIndex) async {
    setState(() {
      if (selectedButtonIndex == buttonIndex) {
        selectedButtonIndex = null;
        availableTimes = [];
        selectedTimeId = null;
      } else {
        selectedButtonIndex = buttonIndex;
      }
    });

    // تحديد التاريخ بناءً على الأزرار
    selectedDate = DateTime.now().add(Duration(days: daysToAdd));
    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

    final times = await timeService.fetchTime(formattedDate);

    setState(() {
      availableTimes = List<Map<String, dynamic>>.from(times);
      selectedTimeId = null;
    });

    if (selectedDate != null) {
      widget.onDateSelected(selectedDate!, selectedTimeId);
    }
  }

  Widget _buildDateButton(String dayLabel, int daysToAdd, int buttonIndex) {
    bool isSelected = selectedButtonIndex == buttonIndex;
    DateTime displayedDate = DateTime.now().add(Duration(days: daysToAdd));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          _onDateButtonPressed(daysToAdd, buttonIndex);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(backgroundcolor2) : Colors.white,
          side: BorderSide(color: Color(backgroundcolor2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Text(
              dayLabel,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontFamily: 'STVBold',
              ),
            ),
            Text(
              DateFormat('dd/MM').format(displayedDate),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontFamily: 'STVBold',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotSection() {
    if (availableTimes.isEmpty) {
      return Center(
        child: Text(
          'لا توجد أوقات متاحة للتاريخ المختار.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontFamily: 'STVBold',
          ),
        ),
      );
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          for (int i = 0; i < availableTimes.length; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedTimeId = availableTimes[i]['id'];
                });
                if (selectedDate != null && selectedTimeId != null) {
                  widget.onDateSelected(selectedDate!, selectedTimeId);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: selectedTimeId == availableTimes[i]['id']
                      ? Colors.green
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  '${availableTimes[i]['time_start']} - ${availableTimes[i]['time_end']}',
                  style: TextStyle(
                    color: selectedTimeId == availableTimes[i]['id']
                        ? Colors.white
                        : Colors.black,
                    fontFamily: 'STVBold',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'وقت التوصيل المفضل',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'STVBold',
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDateButton('اليوم', 0, 0),
                _buildDateButton('غداً', 1, 1),
                _buildDateButton('الأحد', 2, 2),
                _buildDateButton('الاثنين', 3, 3),
                _buildDateButton('الثلاثاء', 4, 4),
                _buildDateButton('الأربعاء', 5, 5),
                _buildDateButton('الخميس', 6, 6),
                _buildDateButton('الجمعة', 7, 7),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (selectedButtonIndex != null) _buildTimeSlotSection(),
      ],
    );
  }
}
