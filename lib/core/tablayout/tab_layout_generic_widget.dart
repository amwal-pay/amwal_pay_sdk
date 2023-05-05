import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/tablayout/tab_layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabLayoutGenericWidget extends StatelessWidget {
  const TabLayoutGenericWidget({
    Key? key,
    required this.tabsValues,
    required this.onTabSelected,
    required this.tabLayoutCubit,
  }) : super(key: key);

  final List<String> tabsValues;
  final void Function(int) onTabSelected;
  final TabLayoutCubit tabLayoutCubit;

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    return Material(
      child: Container(
        width: mediaQuerySize.width,
        height: 50,
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 2,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: darkGeryColor,
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: tabsValues.map(
            (e) {
              return Expanded(
                child: InkWell(
                  onTap: () {
                    final selectedTab = tabsValues.indexOf(e);
                    tabLayoutCubit.setState(selectedTab);
                    onTabSelected(selectedTab);
                  },
                  child: BlocBuilder<TabLayoutCubit, int>(
                    bloc: tabLayoutCubit,
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          color: state == tabsValues.indexOf(e)
                              ? whiteColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            6,
                          ),
                        ),
                        margin: const EdgeInsets.all(4),
                        child: Center(
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
