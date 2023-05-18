import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatelessWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height / 2 + bottomInsets,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInsets),
        child: Column(
          children: [
            TextField(),
          ],
        ),
      ),
    );
  }
}
