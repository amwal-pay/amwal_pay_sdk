import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';

class BottomSelectList<T> extends StatefulWidget {
  const BottomSelectList({
    Key? key,
    required this.listItems,
    required this.nameMapper,
    required this.onChanged,
    required this.onClicked,
    required this.onDone,
    required this.onCancel,
    required this.name,
    this.initialItemIndex,
  }) : super(key: key);

  final List<T> listItems;
  final String Function(T) nameMapper;
  final void Function(T) onChanged;
  final void Function(T) onClicked;
  final void Function() onDone;
  final void Function() onCancel;
  static const double _itemHeight = 50;
  final int? initialItemIndex;
  final String? name;

  @override
  State<BottomSelectList<T>> createState() => _BottomSelectListState<T>();
}

class _BottomSelectListState<T> extends State<BottomSelectList<T>> {
  late FixedExtentScrollController _scrollController;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController();
    selectedIndex = widget.initialItemIndex ?? 0;
    _scrollController.jumpToItem(selectedIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: lightGeryColor2,
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: widget.onCancel,
                  child: Text(
                    'cancel',
                  ),
                ),
                InkWell(
                  onTap: widget.onDone,
                  child: Text(
                    'done',
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x77A6A6A6),
                    Color(0x41FFFFFF),
                    Color(0x5FFFFFFF),
                    Color(0x5FFFFFFF),
                    Color(0xB2FFFFFF),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ClickableListWheelScrollView(
                scrollController: _scrollController,
                itemHeight: BottomSelectList._itemHeight,
                itemCount: widget.listItems.length,
                onItemTapCallback: (index) {
                  widget.onClicked(widget.listItems[index]);
                  // Navigator.pop(context);
                },
                child: ListWheelScrollView.useDelegate(
                  controller: _scrollController,
                  itemExtent: BottomSelectList._itemHeight,
                  diameterRatio: 100,
                  physics: const FixedExtentScrollPhysics(),
                  overAndUnderCenterOpacity: 0.5,
                  perspective: 0.001,
                  onSelectedItemChanged: (index) {
                    widget.onChanged(widget.listItems[index]);
                    setState(() => selectedIndex = index);
                  },
                  // useMagnifier: true,
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? darkGeryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 50,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 3,
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 7,
                              child: Center(
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.name != ''
                                            ? '${widget.name} - ${widget.nameMapper(widget.listItems[index])}'
                                            : widget.nameMapper(
                                                widget.listItems[index],
                                              ),
                                        style: TextStyle(
                                          color: selectedIndex == index
                                              ? blackColor
                                              : greyColor,
                                          fontSize:
                                              selectedIndex == index ? 16 : 14,
                                          fontWeight: selectedIndex == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: selectedIndex == index ? 3 : 2,
                              child: const SizedBox(),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: widget.listItems.length,
                  ),
                  magnification: 1.2,
                  squeeze: .8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
