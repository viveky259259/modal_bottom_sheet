import 'package:example/main.dart';
import 'package:example/modals/modal_inside_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// Stateful widget that lets you create a bottom sheet which can change
/// state based on the switch.
class ModalInsideModalWithStateChangeNotifier extends StatefulWidget {
  final bool reverse;

  const ModalInsideModalWithStateChangeNotifier(
      {Key? key, this.reverse = false})
      : super(key: key);

  @override
  State<ModalInsideModalWithStateChangeNotifier> createState() =>
      _ModalInsideModalWithStateChangeNotifierState();
}

class _ModalInsideModalWithStateChangeNotifierState
    extends State<ModalInsideModalWithStateChangeNotifier> {
  bool switchValue = true;

  @override
  void initState() {
    // This piece of code is written here so that we can open the bottomsheet
    // with the bottomsheet in a non-dismissible state.
    // Note : This is just for demo.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bottomSheetStateNotifier.value = BottomSheetState.nonDismissible;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          leading: Container(), middle: Text('Modal Page')),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Lock the Bottom Sheet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Switch(
                  value: switchValue,
                  onChanged: (value) {
                    if (value) {
                      bottomSheetStateNotifier.value =
                          BottomSheetState.nonDismissible;
                    } else {
                      bottomSheetStateNotifier.value =
                          BottomSheetState.dismissible;
                    }
                    setState(() {
                      switchValue = value;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView(
                reverse: widget.reverse,
                shrinkWrap: true,
                controller: ModalScrollController.of(context),
                physics: ClampingScrollPhysics(),
                children: ListTile.divideTiles(
                    context: context,
                    tiles: List.generate(
                      100,
                      (index) => ListTile(
                          title: Text('Item $index'),
                          onTap: () => showCupertinoModalBottomSheet(
                                expand: true,
                                isDismissible: false,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    ModalInsideModal(reverse: widget.reverse),
                              )),
                    )).toList(),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
