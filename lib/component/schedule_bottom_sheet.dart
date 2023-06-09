import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleBottomSheet({required this.selectedDate, Key? key})
      : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formkey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;
  int? selectedId;
  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2 + bottomInsets,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInsets),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formkey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(
                      onSavedStart: (String? val) {
                        startTime = int.parse(val!);
                      },
                      onSavedEnd: (String? val) {
                        endTime = int.parse(val!);
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    _Content(
                      onSaved: (String? val) {
                        content = val;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    FutureBuilder<List<CategoryColor>>(
                        future: GetIt.I<LocalDatabase>().getCategoryColors(),
                        builder: (context, snapshot) {
                          if (selectedId == null &&
                              snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            selectedId = snapshot.data![0].id;
                          }

                          return _ColorPicker(
                            colors: snapshot.hasData ? snapshot.data! : [],
                            selectedId: selectedId,
                            colorIdSetter: (int id) {
                              setState(() {
                                selectedId = id;
                              });
                            },
                          );
                          //   _ColorPicker(
                          //   colors: snapshot.hasData ? snapshot.data! : [],
                          //   selectedId: selectedId!,
                          //   colorIdSetter: (int id) {},
                          // );
                        }),
                    _SaveButton(onPressed: onSavePressed),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavePressed() {
    if (formkey.currentState == null) {
      return;
    }
    if (formkey.currentState!.validate()) {
      print('에러가 없습니다');
      formkey.currentState?.save();
      GetIt.I<LocalDatabase>().createSchedule(
        SchedulesCompanion(
          date: Value(widget.selectedDate),
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          colorId: Value(selectedId!),
        ),
      );
      Navigator.of(context).pop();
    } else {
      print('에러가 있습니다.');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onSavedStart;
  final FormFieldSetter<String> onSavedEnd;
  const _Time({required this.onSavedStart, required this.onSavedEnd, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            isTime: true,
            label: '시작시간',
            onSaved: onSavedStart,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: CustomTextField(
            isTime: true,
            label: '마감시간',
            onSaved: onSavedEnd,
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  const _Content({required this.onSaved, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        isTime: false,
        label: '내용',
        onSaved: onSaved,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SaveButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            onPressed: onPressed,
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}

typedef ColorIdSetter = void Function(int val);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedId;
  final ColorIdSetter colorIdSetter;
  const _ColorPicker(
      {required this.colorIdSetter,
      required this.selectedId,
      required this.colors,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors
          .map(
            (e) => GestureDetector(
              onTap: () {
                colorIdSetter(e.id);
              },
              child: renderColor(e, selectedId == e.id),
            ),
          )
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool selectedId) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: selectedId
            ? Border.all(
                color: Colors.black,
                width: 4,
              )
            : null,
        color: Color(
          int.parse('FF${color.hexCode}', radix: 16),
        ),
      ),
    );
  }
}
