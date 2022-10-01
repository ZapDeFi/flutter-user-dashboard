import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zapdefiapp/presentation/main/main_router.dart';

class MainProvider extends ChangeNotifier {
  final MainRouter router;

  final _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final List<Map<String, Object>> _presetBasicRaw = [];
  List<Map<String, Object>> get rawPresetBasic => _presetBasicRaw;

  bool _isCheckedForCondition = false;
  bool get isCheckedForCondition => _isCheckedForCondition;

  final List<String> _conditionList = <String>[
    'None',
    'Arithmetic',
    'Aggregate',
    'Action'
  ];
  List<String> get conditionList => _conditionList;

  String _conditionValue = 'None';
  String get conditionValue => _conditionValue;


  String _arithmeticValue = '+';
  String get arithmeticValue => _arithmeticValue;
  String _arithmeticTotalValue = '';
  String get arithmeticTotalValue => _arithmeticTotalValue;

  final _arithmeticLeftController = TextEditingController();
  final _arithmeticRightController = TextEditingController();
  TextEditingController get arithmeticLeftController => _arithmeticLeftController;
  TextEditingController get arithmeticRightController => _arithmeticRightController;

  String _selectedNodeId = '';
  String get selectedNodeId => _selectedNodeId;

  final _conditionLeftController = TextEditingController();
  final _conditionRightController = TextEditingController();
  final _conditionMiddleController = TextEditingController();
  TextEditingController get conditionLeftController => _conditionLeftController;
  TextEditingController get conditionRightController => _conditionRightController;
  TextEditingController get conditionMiddleController => _conditionMiddleController;

  MainProvider({
    required this.router,
  }) {
    _initRootNote();
    _arithmeticCalculation();
  }

  void didSelectNode(String id){
    _selectedNodeId = id;
  }

  void calculationLogic(){
    if (double.tryParse(_arithmeticLeftController.text) == null || double.tryParse(_arithmeticRightController.text) == null) {
      return;
    }

    if (_arithmeticValue == '+'){
      double total = double.parse(_arithmeticLeftController.text) + double.parse(_arithmeticRightController.text);
      _arithmeticTotalValue = total.toString();
    }
    if (_arithmeticValue == '-'){
      double total = double.parse(_arithmeticLeftController.text) - double.parse(_arithmeticRightController.text);
      _arithmeticTotalValue = total.toString();
    }
    if (_arithmeticValue == '*'){
      double total = double.parse(_arithmeticLeftController.text) * double.parse(_arithmeticRightController.text);
      _arithmeticTotalValue = total.toString();
    }
    if (_arithmeticValue == '/'){
      double total = double.parse(_arithmeticLeftController.text) / double.parse(_arithmeticRightController.text);
      _arithmeticTotalValue = total.toString();
    }
    notifyListeners();
  }

  void _arithmeticCalculation(){
      _arithmeticLeftController.addListener(() {
        calculationLogic();
      });
      _arithmeticRightController.addListener(() {
        calculationLogic();
      });
  }

  void changeCondition(String value) {
    _conditionValue = value;
    notifyListeners();
  }

  void changeArithmeticCondition(String value) {
    _arithmeticValue = value;
    notifyListeners();
  }

  void _initRootNote() {
    const uuidInstant = Uuid();
    final uuid = uuidInstant.v4();

    _presetBasicRaw.add({
      "id": uuid,
      "zap_type": "ROOT",
      "children": [],
    });
    notifyListeners();
  }

  void changeCheckListCondition(bool value) {
    _isCheckedForCondition = value;
    notifyListeners();
  }

  void addNewNode() {
    final selectedNode = _presetBasicRaw
        .firstWhere((element) => element['id'] == _selectedNodeId);
    final selectedNodeIndex = _presetBasicRaw
        .indexWhere((element) => element['id'] == _selectedNodeId);
    var selectedNodeNext = selectedNode['children'] as List;

    const uuidInstant = Uuid();
    final uuid = uuidInstant.v4();
    final zapType = _conditionValue.toUpperCase();

    final newNode = {
      "id": uuid,
      "zap_type": zapType,
      "children": [],
    };

    if (zapType == 'ARITHMETIC'){
      if (double.tryParse(_arithmeticLeftController.text) == null || double.tryParse(_arithmeticRightController.text) == null) {
        return;
      }

      newNode['data'] = {
        "operator": _arithmeticValue,
        "left": '\$${_arithmeticLeftController.text}',
        "right": '\$${_arithmeticRightController.text}',
        "result": '\$$_arithmeticTotalValue'
      };

      print(newNode);
    }

    Map<String, Object> currentNodForRoot = {
      "id": uuid,
    };

    if (
      _conditionLeftController.text.isNotEmpty &&
      _conditionRightController.text.isNotEmpty && 
      _conditionMiddleController.text.isNotEmpty) {
        currentNodForRoot['condition'] = {
          "right": _conditionRightController.text,
          "left": _conditionLeftController.text,
          "operator": _conditionMiddleController.text
        };
    }

    selectedNodeNext.add(currentNodForRoot);
    selectedNode['children'] = selectedNodeNext;
    _presetBasicRaw[selectedNodeIndex] = selectedNode;
    _presetBasicRaw.add(newNode);
    notifyListeners();
  }
}
