import 'package:calendar_scheduler/component/schedul_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:flutter/material.dart';

import '../component/calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            SizedBox(
              height: 8,
            ),
            TodayBanner(
              selectedDay: selectedDay,
              scheduleCount: 3,
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.separated(
                    itemCount: 100,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 8,
                      );
                    },
                    itemBuilder: (context, index) {
                      return ScheduleCard(
                        startTime: 8,
                        endTime: 12,
                        content: '멋진 개발자되기',
                        color: Colors.red,
                      );
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}
