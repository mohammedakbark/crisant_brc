import 'package:flutter/cupertino.dart';
import 'package:test_managment/model/parameter_values_model.dart';

class ParameterController with ChangeNotifier {
  List<ParameterValuesModel>? _listOfParametersValueList;
  List<ParameterValuesModel>? get listOfParametersValueList =>
      _listOfParametersValueList;



}
