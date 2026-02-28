import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String _step = 'login'; // 'login', 'register', 'verify'
  final _emailController = TextEditingController(text: 'admin@school.edu.eg');
  final _passwordController = TextEditingController(text: 'admin123');

  // Register controllers
  final _regNameController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _verifyCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient/Depth
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF020408), Color(0xFF0D121F)],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: GlassContainer(
                      width: 70,
                      height: 70,
                      borderRadius: 20,
                      child: const Center(
                        child: Icon(Icons.hub_rounded, color: Colors.white, size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('SIOMS', style: TextStyle(fontFamily: 'Sora', fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 40),

                  // Step Switcher
                  if (_step != 'verify')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: GlassContainer(
                      borderRadius: 15,
                      opacity: 0.05,
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          _buildTabItem('login', 'Sign In'),
                          _buildTabItem('register', 'Request Access'),
                        ],
                      ),
                    ),
                  ),

                  // Dynamic Form based on step
                  GlassContainer(
                    padding: const EdgeInsets.all(32),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildForm(authState),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String step, String label) {
    final isSelected = _step == step;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _step = step),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSub,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AuthState authState) {
    if (_step == 'login') return _buildLoginForm(authState);
    if (_step == 'register') return _buildRegisterForm();
    return _buildVerifyForm();
  }

  Widget _buildLoginForm(AuthState authState) {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Welcome Back', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Sora')),
        const SizedBox(height: 8),
        const Text('Enter your credentials to continue', style: TextStyle(color: AppColors.textSub, fontSize: 13)),
        const SizedBox(height: 32),
        _buildTextField(controller: _emailController, label: 'Email', icon: Icons.alternate_email_rounded),
        const SizedBox(height: 16),
        _buildTextField(controller: _passwordController, label: 'Password', icon: Icons.lock_outline_rounded, isPassword: true),
        if (authState.error != null) ...[
          const SizedBox(height: 16),
          Text(authState.error!, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
        ],
        const SizedBox(height: 32),
        GlassButton(
          label: authState.isLoading ? 'Verifying...' : 'Sign In',
          onPressed: () => ref.read(authProvider.notifier).login(_emailController.text, _passwordController.text),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      key: const ValueKey('register'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Request Access', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Sora')),
        const SizedBox(height: 8),
        const Text('Submit your details for admin approval', style: TextStyle(color: AppColors.textSub, fontSize: 13)),
        const SizedBox(height: 32),
        _buildTextField(controller: _regNameController, label: 'Full Name', icon: Icons.person_outline_rounded),
        const SizedBox(height: 16),
        _buildTextField(controller: _regEmailController, label: 'Work Email', icon: Icons.email_outlined),
        const SizedBox(height: 32),
        GlassButton(
          label: 'Submit Request',
          onPressed: () async {
            try {
              await ref.read(authRepositoryProvider).registerRequest({
                'name': _regNameController.text,
                'email': _regEmailController.text,
                'requestedRole': 'Employee',
              });
              setState(() => _step = 'verify');
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          },
        ),
      ],
    );
  }

  Widget _buildVerifyForm() {
    return Column(
      key: const ValueKey('verify'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: Icon(Icons.mark_email_read_rounded, color: AppColors.primary, size: 48)),
        const SizedBox(height: 24),
        const Text('Verify Email', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Sora')),
        const SizedBox(height: 8),
        const Text('Enter the 6-digit code sent to your email', style: TextStyle(color: AppColors.textSub, fontSize: 13)),
        const SizedBox(height: 32),
        _buildTextField(controller: _verifyCodeController, label: 'Verification Code', icon: Icons.pin_rounded),
        const SizedBox(height: 32),
        GlassButton(
          label: 'Verify Code',
          onPressed: () async {
            try {
              await ref.read(authRepositoryProvider).verifyEmail(_regEmailController.text, _verifyCodeController.text);
              setState(() => _step = 'login');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email verified! Pending admin approval.')));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          },
        ),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _step = 'register'),
            child: const Text('Go back', style: TextStyle(color: AppColors.textSub)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSub, fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
