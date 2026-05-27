import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedRole = 'student';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(userProvider.translate('loginTitle'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(userProvider.translate('loginSubtitle'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildRoleSelector(userProvider),
            const SizedBox(height: 20),
            if (_selectedRole != 'teacher') ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: userProvider.translate(_selectedRole == 'student'
                      ? 'studentName'
                      : 'parentName'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _studentIdController,
                decoration: InputDecoration(
                  labelText: userProvider.translate('studentId'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
            if (_selectedRole == 'teacher') ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: userProvider.translate('teacherName'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: userProvider.translate('teacherPin'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _handleLogin(context, userProvider),
              child: Text(userProvider.translate('loginButton')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelector(UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(userProvider.translate('loginRoleLabel')),
        const SizedBox(height: 8),
        Row(
          children: [
            _roleChip(userProvider, 'student',
                userProvider.translate('studentLogin')),
            const SizedBox(width: 8),
            _roleChip(
                userProvider, 'parent', userProvider.translate('parentLogin')),
            const SizedBox(width: 8),
            _roleChip(userProvider, 'teacher',
                userProvider.translate('teacherLogin')),
          ],
        ),
      ],
    );
  }

  Widget _roleChip(UserProvider userProvider, String role, String label) {
    final selected = _selectedRole == role;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() {
          _selectedRole = role;
        });
      },
    );
  }

  Future<void> _handleLogin(
      BuildContext context, UserProvider userProvider) async {
    final navigator = Navigator.of(context);
    final name = _nameController.text.trim();
    final studentId = _studentIdController.text.trim();
    final pin = int.tryParse(_pinController.text.trim());

    if (_selectedRole == 'student') {
      if (name.isEmpty || studentId.isEmpty) {
        _showMessage(context, 'Please enter student name and ID.');
        return;
      }
      await userProvider.loginStudent(name, studentId);
      if (!context.mounted) return;
      navigator.pushReplacementNamed(AppRoutes.home);
      return;
    }

    if (_selectedRole == 'parent') {
      if (name.isEmpty || studentId.isEmpty) {
        _showMessage(context, 'Please enter parent name and student ID.');
        return;
      }
      await userProvider.loginParent(name, studentId);
      if (!context.mounted) return;
      navigator.pushReplacementNamed(AppRoutes.parentDashboard);
      return;
    }

    if (_selectedRole == 'teacher') {
      if (name.isEmpty || pin == null) {
        _showMessage(context, 'Please enter teacher name and PIN.');
        return;
      }
      if (!userProvider.validateTeacherPin(pin)) {
        _showMessage(context, 'Invalid teacher PIN.');
        return;
      }
      await userProvider.loginTeacher(name);
      if (!context.mounted) return;
      navigator.pushReplacementNamed(AppRoutes.teacherDashboard);
      return;
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
