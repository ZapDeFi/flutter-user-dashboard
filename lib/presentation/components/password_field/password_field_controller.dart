part of 'password_field_component.dart';

class PasswordFieldController extends ChangeNotifier {
  final TextEditingController _textController;
  final TextEditingController _emailController;

  PasswordFieldController({
    final String? email,
    final String? password,
  })  : _textController = TextEditingController(text: password),
        _emailController = TextEditingController(text: email) {
    _initPasswordListener();
  }

  String get password => _textController.text;

  bool _passwordVisible = false;
  bool get isPasswordVisible => _passwordVisible;
  void changeVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  bool _minEightChar = false;
  bool _hasCapLetter = false;
  bool _hasNumber = false;
  bool _hasLowerLatter = false;
  bool _isPasswordValid = false;
  bool get minEightChar => _minEightChar;
  bool get hasCapLetter => _hasCapLetter;
  bool get hasNumber => _hasNumber;
  bool get hasLowerLatter => _hasLowerLatter;
  bool get isPasswordValid => _isPasswordValid;
  void _initPasswordListener() {
    _textController.addListener(() {
      final numRegEx = RegExp('[0-9]');
      final capRegEx = RegExp(r'(?=.*[A-Z])\w+');
      final lowRegEx = RegExp(r'(?=.*[a-z])\w+');

      _hasNumber = password.contains(numRegEx);
      _hasCapLetter = password.contains(capRegEx);
      _hasLowerLatter = password.contains(lowRegEx);
      _minEightChar = password.length >= 8;
      _isPasswordValid =
          _hasNumber && _hasCapLetter && _hasLowerLatter && _minEightChar;

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
