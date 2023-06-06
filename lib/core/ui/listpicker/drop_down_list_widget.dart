import 'package:amwal_pay_sdk/core/resources/assets/app_assets_paths.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_cubit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bottom_select_list.dart';

class DropDownListWidget<T> extends StatelessWidget {
  final String? widgetTitle;
  final void Function(T) onSelected;
  final void Function() onDone;
  final String Function(T?) nameMapper;
  final List<T> dropDownListItems;
  final DropDownListCubit<T> cubit;
  final String hintText;
  final String? name;
  final Border? border;
  final BorderRadius? borderRadius;
  final void Function()? onCancel;

  const DropDownListWidget({
    Key? key,
    this.widgetTitle,
    required this.onSelected,
    required this.dropDownListItems,
    required this.nameMapper,
    required this.cubit,
    required this.hintText,
    required this.onDone,
    required this.name,
    this.onCancel,
    this.border,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    return Material(
      child: Container(
        color: lightGeryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widgetTitle != null)
              Text(
                widgetTitle!,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (widgetTitle != null)
              const SizedBox(
                height: 5,
              ),
            InkWell(
              onTap: () async => await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxHeight: mediaQuerySize.height * 0.45,
                ),
                builder: (context) {
                  int? initialIndex;
                  if (cubit.state != null) {
                    final index = dropDownListItems.indexOf(cubit.state as T);
                    if (index != -1) {
                      initialIndex = index;
                    }
                  }
                  return BottomSelectList<T>(
                    nameMapper: nameMapper,
                    initialItemIndex: initialIndex,
                    onDone: () {
                      Navigator.of(context).pop();
                      if (cubit.state == null) {
                        onSelected(dropDownListItems.first);
                      }
                      onDone();
                    },
                    onCancel: () {
                      cubit.updateState(null);
                      onCancel?.call();
                      Navigator.of(context).pop();
                    },
                    onChanged: (item) {
                      onSelected(item);
                      cubit.updateState(item);
                    },
                    onClicked: (item) {
                      onSelected(item);
                      cubit.updateState(item);
                    },
                    listItems: dropDownListItems,
                    name: name,
                  );
                },
              ),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: whiteColor,
                  border: border,
                  borderRadius: borderRadius,
                ),
                child: BlocBuilder<DropDownListCubit<T?>, T?>(
                    bloc: cubit,
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              state != null ? nameMapper(state) : hintText,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            AppAssets.downArrowIcon,
                            package: 'amwal_pay_sdk',
                          )
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
