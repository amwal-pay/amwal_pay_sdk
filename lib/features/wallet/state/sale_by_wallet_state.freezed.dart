// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_by_wallet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SaleByWalletState {
  int get page => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int page, bool verified) initial,
    required TResult Function(int page, bool verified) verified,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int page, bool verified)? initial,
    TResult? Function(int page, bool verified)? verified,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int page, bool verified)? initial,
    TResult Function(int page, bool verified)? verified,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Verified value) verified,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Verified value)? verified,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SaleByWalletStateCopyWith<SaleByWalletState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaleByWalletStateCopyWith<$Res> {
  factory $SaleByWalletStateCopyWith(
          SaleByWalletState value, $Res Function(SaleByWalletState) then) =
      _$SaleByWalletStateCopyWithImpl<$Res, SaleByWalletState>;
  @useResult
  $Res call({int page, bool verified});
}

/// @nodoc
class _$SaleByWalletStateCopyWithImpl<$Res, $Val extends SaleByWalletState>
    implements $SaleByWalletStateCopyWith<$Res> {
  _$SaleByWalletStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? verified = null,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $SaleByWalletStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int page, bool verified});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$SaleByWalletStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? verified = null,
  }) {
    return _then(_$_Initial(
      null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(this.page, {this.verified = false});

  @override
  final int page;
  @override
  @JsonKey()
  final bool verified;

  @override
  String toString() {
    return 'SaleByWalletState.initial(page: $page, verified: $verified)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, verified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int page, bool verified) initial,
    required TResult Function(int page, bool verified) verified,
  }) {
    return initial(page, this.verified);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int page, bool verified)? initial,
    TResult? Function(int page, bool verified)? verified,
  }) {
    return initial?.call(page, this.verified);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int page, bool verified)? initial,
    TResult Function(int page, bool verified)? verified,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(page, this.verified);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Verified value) verified,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Verified value)? verified,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements SaleByWalletState {
  const factory _Initial(final int page, {final bool verified}) = _$_Initial;

  @override
  int get page;
  @override
  bool get verified;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_VerifiedCopyWith<$Res>
    implements $SaleByWalletStateCopyWith<$Res> {
  factory _$$_VerifiedCopyWith(
          _$_Verified value, $Res Function(_$_Verified) then) =
      __$$_VerifiedCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int page, bool verified});
}

/// @nodoc
class __$$_VerifiedCopyWithImpl<$Res>
    extends _$SaleByWalletStateCopyWithImpl<$Res, _$_Verified>
    implements _$$_VerifiedCopyWith<$Res> {
  __$$_VerifiedCopyWithImpl(
      _$_Verified _value, $Res Function(_$_Verified) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? verified = null,
  }) {
    return _then(_$_Verified(
      null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Verified implements _Verified {
  const _$_Verified(this.page, {this.verified = true});

  @override
  final int page;
  @override
  @JsonKey()
  final bool verified;

  @override
  String toString() {
    return 'SaleByWalletState.verified(page: $page, verified: $verified)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Verified &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, verified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VerifiedCopyWith<_$_Verified> get copyWith =>
      __$$_VerifiedCopyWithImpl<_$_Verified>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int page, bool verified) initial,
    required TResult Function(int page, bool verified) verified,
  }) {
    return verified(page, this.verified);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int page, bool verified)? initial,
    TResult? Function(int page, bool verified)? verified,
  }) {
    return verified?.call(page, this.verified);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int page, bool verified)? initial,
    TResult Function(int page, bool verified)? verified,
    required TResult orElse(),
  }) {
    if (verified != null) {
      return verified(page, this.verified);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Verified value) verified,
  }) {
    return verified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Verified value)? verified,
  }) {
    return verified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Verified value)? verified,
    required TResult orElse(),
  }) {
    if (verified != null) {
      return verified(this);
    }
    return orElse();
  }
}

abstract class _Verified implements SaleByWalletState {
  const factory _Verified(final int page, {final bool verified}) = _$_Verified;

  @override
  int get page;
  @override
  bool get verified;
  @override
  @JsonKey(ignore: true)
  _$$_VerifiedCopyWith<_$_Verified> get copyWith =>
      throw _privateConstructorUsedError;
}
