import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zapdefiapp/data/login/models/token_list_model.dart';
import 'package:zapdefiapp/presentation/main/main_router.dart';

class MainProvider extends ChangeNotifier {
  final MainRouter router;
  final _cancelToken = CancelToken();

  int uuid = 1;

  final _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final List<Map<String, Object>> _presetBasicRaw = [];
  List<Map<String, Object>> get rawPresetBasic => _presetBasicRaw;

  bool get addNodeButtonEnabled => _conditionValue != 'None';

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
  TextEditingController get arithmeticLeftController =>
      _arithmeticLeftController;
  TextEditingController get arithmeticRightController =>
      _arithmeticRightController;

  String _selectedNodeId = '';
  String get selectedNodeId => _selectedNodeId;

  final _conditionLeftController = TextEditingController();
  final _conditionRightController = TextEditingController();
  final _conditionMiddleController = TextEditingController();
  TextEditingController get conditionLeftController => _conditionLeftController;
  TextEditingController get conditionRightController =>
      _conditionRightController;
  TextEditingController get conditionMiddleController =>
      _conditionMiddleController;

  //Swap
  final List<String> _actionList = <String>[
    'None',
    'Swap',
  ];
  List<String> get actionList => _actionList;

  String _actionValue = 'None';
  String get actionValue => _actionValue;

  String _swapWalletItemSelected = 'Peercoin';
  String get swapWalletItemSelected => _swapWalletItemSelected;

  String _forWalletItemSelected = 'Peercoin';
  String get forWalletItemSelected => _forWalletItemSelected;

  final _swapAmountController = TextEditingController();
  TextEditingController get swapAmountController => _swapAmountController;

  final walletItems = [
    TokensModel(
      chainId: 1,
      name: "Peercoin",
      address: "0x044d078F1c86508e13328842Cc75AC021B272958",
      decimals: 18,
      symbol: "PPC",
      logoURI: "https://s2.coinmarketcap.com/static/img/coins/64x64/5.png",
    ),
    TokensModel(
      chainId: 1,
      name: "Public Index Network",
      address: "0xc1f976B91217E240885536aF8b63bc8b5269a9BE",
      decimals: 18,
      symbol: "PIN",
      logoURI: "https://s2.coinmarketcap.com/static/img/coins/64x64/64.png",
    ),
    TokensModel(
      chainId: 1,
      name: "Magic Internet Money",
      address: "0x99d8a9c45b2eca8864373a26d1459e3dff1e17f3",
      decimals: 18,
      symbol: "MIM",
      logoURI: "https://s2.coinmarketcap.com/static/img/coins/64x64/162.png",
    ),
  ];

  MainProvider({
    required this.router,
  }) {
    _initRootNote();
    _arithmeticCalculation();
  }

  void changeForValueItem(String value) {
    _forWalletItemSelected = value;
    notifyListeners();
  }

  void changeSwapValueItem(String value) {
    _swapWalletItemSelected = value;
    notifyListeners();
  }

  void changeAction(String value) {
    _actionValue = value;
    notifyListeners();
  }

  void didSelectNode(String id) {
    _selectedNodeId = id;
  }

  void calculationLogic() {
    final textLeft = _arithmeticLeftController.text;
    final finalTextLeft = _tagValueInterceptor(textLeft);
    if (finalTextLeft != textLeft) {
      _arithmeticLeftController.text = finalTextLeft;
      notifyListeners();
    }

    final textRight = _arithmeticRightController.text;
    final finalTextRight = _tagValueInterceptor(textRight);
    if (finalTextRight != textRight) {
      _arithmeticRightController.text = finalTextRight;
      notifyListeners();
    }

    if (double.tryParse(_arithmeticLeftController.text) == null ||
        double.tryParse(_arithmeticRightController.text) == null) {
      return;
    }

    if (_arithmeticValue == '+') {
      double total = double.parse(_arithmeticLeftController.text) +
          double.parse(_arithmeticRightController.text);
      _arithmeticTotalValue = total.toString();
    }
    if (_arithmeticValue == '-') {
      double total = double.parse(_arithmeticLeftController.text) -
          double.parse(_arithmeticRightController.text);
      _arithmeticTotalValue = total.toString();
    }
    if (_arithmeticValue == '*') {
      double total = double.parse(_arithmeticLeftController.text) *
          double.parse(_arithmeticRightController.text);
      _arithmeticTotalValue = total.toString();
    }
    if (_arithmeticValue == '/') {
      double total = double.parse(_arithmeticLeftController.text) /
          double.parse(_arithmeticRightController.text);
      _arithmeticTotalValue = total.toString();
    }
    notifyListeners();
  }

  void _arithmeticCalculation() {
    _arithmeticLeftController.addListener(() {
      calculationLogic();
    });
    _arithmeticRightController.addListener(() {
      calculationLogic();
    });

    _conditionRightController.addListener(() {
      final text = _conditionRightController.text;
      final finalText = _tagValueInterceptor(text);
      if (finalText != text) {
        _conditionRightController.text = finalText;
        notifyListeners();
      }
    });

    _conditionLeftController.addListener(() {
      final text = _conditionLeftController.text;
      final finalText = _tagValueInterceptor(text);
      if (finalText != text) {
        _conditionLeftController.text = finalText;
        notifyListeners();
      }
    });
  }

  void changeCondition(String value) {
    _conditionValue = value;
    _actionValue = 'None';
    notifyListeners();
  }

  void changeArithmeticCondition(String value) {
    _arithmeticValue = value;
    notifyListeners();
  }

  void _initRootNote() {
    _presetBasicRaw.add({
      "id": uuid.toString(),
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

    uuid++;
    final bumpUuid = uuid;
    final newUuid = bumpUuid.toString();
    final zapType = _conditionValue.toUpperCase();

    final newNode = {
      "id": newUuid,
      "zap_type": zapType,
      "children": [],
    };

    if (zapType == 'ARITHMETIC') {
      if (double.tryParse(_arithmeticLeftController.text) == null ||
          double.tryParse(_arithmeticRightController.text) == null) {
        return;
      }

      newNode['data'] = {
        "operator": _arithmeticValue,
        "left": _arithmeticLeftController.text,
        "right": _arithmeticRightController.text,
        "result": _arithmeticTotalValue
      };
    }

    if (zapType == 'ACTION') {
      final swapItem =
          walletItems.firstWhere((e) => e.name == _swapWalletItemSelected);
      final sawpForItem =
          walletItems.firstWhere((e) => e.name == _forWalletItemSelected);
      newNode['data'] = {
        "token_from_address": swapItem.address,
        "token_to_address": sawpForItem.address,
        "token_from_amount": _swapAmountController.text,
        "action_type": "SWAP_EXACT_ETH_FOR_TOKENS"
      };
    }

    Map<String, Object> currentNodForRoot = {
      "id": newUuid,
    };

    if (_isCheckedForCondition == true &&
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

    _clear();
    notifyListeners();
  }

  void _clear() {
    _isCheckedForCondition == false;
    _conditionLeftController.text = '';
    _conditionRightController.text = '';
    _conditionMiddleController.text = '';
    _arithmeticLeftController.text = '';
    _arithmeticRightController.text = '';
    _arithmeticTotalValue = '';
    _conditionValue = 'None';
    _arithmeticValue = '+';
    _selectedNodeId = '';
  }

  String _tagValueInterceptor(String input) {
    if (input.contains('\$')) {
      final newInput = input.replaceAll('\$', '');
      final selectedNode = _presetBasicRaw
          .firstWhere((element) => element['id'] == _selectedNodeId);

      final tags = selectedNode['tag_value'] as List<Set<Object>>;
      final value =
          tags.map((e) => (e.first == newInput.toUpperCase()) ? e.last : input);
      return value.first.toString();
    } else {
      return input;
    }
  }

  void play() async {
  try {
    const jsonEncoder = JsonEncoder();
    final stringArray = jsonEncoder.convert(_presetBasicRaw);
    
    var response = await Dio().put(
      'http://www.google.com',
      data: stringArray,
    );

    print(response);

    var responsePost = await Dio().post(
      'http://www.google.com'
    );
    print(responsePost);
  } catch (e) {
    print(e);
  }
  }

    void get() async {
  try {
    var response = await Dio().get(
      'http://www.google.com'
    );
    print(response);
  } catch (e) {
    print(e);
  }
  }
}
