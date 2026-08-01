import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.heroGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                  ),
                  child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  'HerCare',
                  style: AppTextStyles.display.copyWith(color: Colors.white, fontSize: 34),
                ),
                const SizedBox(height: 12),
                Text(
                  'Track your cycle. Understand your health.\nTake care of yourself.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: Colors.white.withOpacity(0.92), height: 1.5),
                ),
                const Spacer(flex: 3),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 30, offset: const Offset(0, -8)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomButton(
                        text: 'Create Account',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()));
                        },
                      ),
                      const SizedBox(height: 14),
                      CustomButton(
                        text: 'Login',
                        outlined: true,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
