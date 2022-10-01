import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zapdefiapp/common/constants/edge_insets.dart';
import 'package:zapdefiapp/common/injectore.dart';
import 'package:zapdefiapp/presentation/components/elevated_button.dart';
import 'package:zapdefiapp/presentation/components/password_field/password_field_component.dart';
import 'package:zapdefiapp/presentation/login/fill_remaining_space.dart';
import 'package:zapdefiapp/presentation/login/login_provider.dart';

class LoginScreen extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: (_) => Injector.resolve()..router.context = _,
      child: this,
    );
  }

  const LoginScreen({
    super.key,
  });

  Widget _passwordBuilder(final LoginProvider provider) {
    return AppPasswordField(
        autofocus: false,
        isNewPassword: false,
        isEnabled: !provider.isLoading,
        controller: provider.controller);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppEdgeInsets.big.asEdgeInsets(),
          child: FillRemainigSpace(
            toExpand: Align(
              alignment: const Alignment(0, -.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ZapDeFi',
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Manage all your assets in one place',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  _passwordBuilder(provider),
                ],
              ),
            ),
            footer: Padding(
              padding: AppEdgeInsets.big.asEdgeInsetsSymmetric(
                vertical: true,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppElevatedButton(
                    isLoading: provider.isLoading,
                    onTap: provider.isNextEnable ? provider.onNextTapped : null,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
