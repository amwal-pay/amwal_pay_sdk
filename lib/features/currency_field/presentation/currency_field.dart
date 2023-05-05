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
          _defaultCurrency = value.data?.first;
          widget.onChanged(_defaultCurrency);
        });
      },
      builder: (_, state) {
        final currencies = state.mapOrNull(
          success: (value) => value.uiModel.data,
        );
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: DropDownListWidget<CurrencyData>(
            widgetTitle: 'currency_label'.translate(context),
            hintText: 'OMR',
            cubit: DropDownListCubit(
              initialValue: _currencyData ?? _defaultCurrency,
            ),
            nameMapper: (item) {
              return item!.name;
            },
            onDone: () => setState(
              () => widget.onChanged(_currencyData),
            ),
            onCancel: () => setState(() {
              _currencyData = null;
              widget.onChanged(_defaultCurrency);
            }),
            onSelected: (item) => _currencyData = item,
            dropDownListItems: currencies ?? const [],
          ),
        );
      },
    );
  }
}
