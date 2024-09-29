import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_cubit.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_widget.dart';
import 'package:amwal_pay_sdk/features/currency_field/cubit/currency_cubit.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/request/currency_request.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/resources/color/colors.dart';

class CurrencyField extends StatefulWidget {
  final double? width;
  final double? height;
  final void Function(CurrencyData?) onChanged;

  const CurrencyField({
    Key? key,
    this.width,
    this.height,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  late CurrencyCubit cubit;
  CurrencyData? _currencyData;
  CurrencyData? _defaultCurrency;

  @override
  void initState() {
    super.initState();
    cubit = WalletInjector.instance.getIt.get<CurrencyCubit>();
    _getCurrency();
  }

  Future<void> _getCurrency() async {
    const request = CurrencyRequest();
    await cubit.getCurrencies(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrencyCubit, ICubitState<CurrenciesResponse>>(
      bloc: cubit,
      listener: (_, state) {
        state.whenOrNull(success: (value) {
          _defaultCurrency =
              value.data?.where((element) => element.idN == 512).first;
          widget.onChanged(_defaultCurrency);
        });
      },
      builder: (_, state) {
        final currencies = state.mapOrNull(
          success: (value) => value.uiModel.data
              ?.where((element) => element.idN == 512)
              .toList(),
        );
        if (currencies != null && currencies.isNotEmpty) {
          _defaultCurrency = currencies.first;
          widget.onChanged(_defaultCurrency);
        }

        return (currencies?.length ?? 0) > 1
            ? SizedBox(
                width: widget.width,
                height: widget.height,
                child: DropDownListWidget<CurrencyData>(
                  name: '',
                  widgetTitle: 'currency_label'.translate(context),
                  hintText: 'currency_label'.translate(context),
                  cubit: DropDownListCubit(
                    initialValue: _currencyData ?? _defaultCurrency,
                  ),
                  nameMapper: (item) {
                    return item!.name;
                  },
                  onDone: () => setState(
                    () => widget.onChanged(_currencyData ?? _defaultCurrency),
                  ),
                  onCancel: () => setState(() {
                    _currencyData = null;
                    _defaultCurrency = null;
                    widget.onChanged(null);
                  }),
                  onSelected: (item) {
                    _currencyData = item;
                    widget.onChanged(_currencyData);
                  },
                  dropDownListItems: currencies ?? const [],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        _defaultCurrency?.name ?? '',
                        style: const TextStyle(
                          color: black2Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                    ],
                  ),
                ],
              );
      },
    );
  }
}
