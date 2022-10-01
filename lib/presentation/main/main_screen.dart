import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphite/core/matrix.dart';
import 'package:graphite/graphite.dart';
import 'package:provider/provider.dart';
import 'package:zapdefiapp/presentation/main/main_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
  });

  Widget _nodeItem(BuildContext context, String id) {
    final provider = context.watch<MainProvider>();
    final item =
        provider.rawPresetBasic.firstWhere((element) => element["id"]! == id);
    final name = item['zap_type'].toString();
    // final left = item['left'].toString();
    // final right = item['right'].toString();
    // final condition = item['condition'].toString();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          // Text(
          //   '$left $condition $right',
          //   textAlign: TextAlign.center,
          //   style: const TextStyle(
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  Widget _checklist(MainProvider provider) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: provider.isCheckedForCondition,
          onChanged: (bool? value) {
            provider.changeCheckListCondition(value!);
          },
        ),
        const SizedBox(width: 8),
        const Text('Enable Condition'),
      ],
    );
  }

  Widget _conditionView(MainProvider provider) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: provider.conditionLeftController,
            decoration: const InputDecoration(hintText: "Left"),
          ),
        ),
        Expanded(
          child: TextField(
            controller: provider.conditionMiddleController,
            decoration: const InputDecoration(hintText: "condition"),
          ),
        ),
        Expanded(
          child: TextField(
            controller: provider.conditionRightController,
            decoration: const InputDecoration(hintText: "Right"),
          ),
        ),
      ],
    );
  }

  Widget _dropDownView(MainProvider provider) {
    return DropdownButton<String>(
      value: provider.conditionValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        provider.changeCondition(value!);
      },
      items:
          provider.conditionList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _arithConditionView(MainProvider provider) {
    final List<String> _conditionList = <String>['+', '-', '*', '/'];
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: provider.arithmeticLeftController,
            decoration: const InputDecoration(hintText: "Left"),
          ),
        ),
        Expanded(
          child: DropdownButton<String>(
            value: provider.arithmeticValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              provider.changeArithmeticCondition(value!);
            },
            items: _conditionList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
         Expanded(
          child: TextField(
            controller: provider.arithmeticRightController,
            decoration: const InputDecoration(hintText: "Right"),
          ),
        ),
        Text('= ${provider.arithmeticTotalValue}'),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final provider = context.watch<MainProvider>();
        return SizedBox(
          width: double.maxFinite,
          child: ListView(
            children: [
              _checklist(provider),
              if (provider.isCheckedForCondition) 
                _conditionView(provider),
              const SizedBox(
                height: 12,
              ),
              _dropDownView(provider),
              if (provider.conditionValue == 'Arithmetic')
                _arithConditionView(provider),
              ElevatedButton(
                onPressed: () {
                  provider.addNewNode();
                  Navigator.pop(context);
                },
                child: Text('Add New Node'),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();

    List<Map<String, Object>> newList = [];

    for (var element in provider.rawPresetBasic) {
      if (element.containsKey('id') && element.containsKey('children')) {
        final children = element["children"] as List<dynamic>;
        final test = children.map((item) {
          final id = item as Map;
          return id['id'];
        },).toList();

        print('TEST $test');

        newList.add({'id': element["id"]!, 'next': test});
      }
    }

    const jsonEncoder = JsonEncoder();
    final stringArray = jsonEncoder.convert(newList);

    print(stringArray);

    return Scaffold(
      body: SafeArea(
        child: DirectGraph(
          list: nodeInputFromJson(stringArray),
          cellWidth: 200.0,
          cellPadding: 24.0,
          onNodePanDown: (details, node) {
            provider.didSelectNode(node.id);
            _showBottomSheet(context);
          },
          orientation: MatrixOrientation.Vertical,
          builder: (context, node) {
            return Container(
              width: 200,
              height: 80,
              color: Colors.black,
              child: _nodeItem(context, node.id),
            );
          },
        ),
      ),
    );
  }
}
