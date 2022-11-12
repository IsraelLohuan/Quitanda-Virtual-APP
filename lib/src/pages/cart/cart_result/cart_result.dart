import 'package:freezed_annotation/freezed_annotation.dart';
part 'cart_result.freezed.dart';

@freezed
class CartResult<T> with _$CartResult<T> {
  factory CartResult.sucess(T data) = Success;
  factory CartResult.error(String message) = Error;
}