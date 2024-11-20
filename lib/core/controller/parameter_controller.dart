import 'package:flutter/cupertino.dart';
import 'package:test_managment/model/db%20models/parameter_values_model.dart';

class ParameterController with ChangeNotifier {
  List<ParameterValuesModel>? _listOfParametersValueList;
  List<ParameterValuesModel>? get listOfParametersValueList =>
      _listOfParametersValueList;



}
