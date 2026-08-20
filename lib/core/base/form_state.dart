import 'package:river_blog/core/base/base_state.dart';

abstract class FormState extends BaseState {
  const new();

  FormState copyWith();
  FormState copyWithoutErrors();
}
