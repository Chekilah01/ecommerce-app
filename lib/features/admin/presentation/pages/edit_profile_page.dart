import 'package:final_project/features/auth/domain/entities/gender.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:final_project/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _wilayaController;
  late final TextEditingController _communeController;

  late Gender _selectedGender;

  @override
  void initState() {
    super.initState();

    final state = context.read<AuthBloc>().state;

    if (state is Authenticated) {
      final user = state.user;

      _firstNameController = TextEditingController(text: user.firstName);

      _lastNameController = TextEditingController(text: user.lastName);

      _phoneController = TextEditingController(text: user.phone);

      _wilayaController = TextEditingController(text: user.wilaya);

      _communeController = TextEditingController(text: user.commune);

      _selectedGender = user.gender;
    } else {
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
      _phoneController = TextEditingController();
      _wilayaController = TextEditingController();
      _communeController = TextEditingController();

      _selectedGender = Gender.male;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _wilayaController.dispose();
    _communeController.dispose();

    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      UpdateProfileEvent(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        wilaya: _wilayaController.text.trim(),
        commune: _communeController.text.trim(),
        gender: _selectedGender,
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }

    if (value.trim().length < 8) {
      return 'Enter a valid phone number.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully.')),
          );
          context.pop();
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPersonalInformationSection(),

                    const SizedBox(height: 16),

                    _buildContactInformationSection(),

                    const SizedBox(height: 16),

                    _buildGenderSection(),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark?
                          AppColors.grey:
                          AppColors.lightContainer
                          ,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            :  Text(
                                'Save Changes',
                                style: TextStyle(fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.black
                                :AppColors.info ,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPersonalInformationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _firstNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user),
                labelText: 'First name',
                border: OutlineInputBorder(),
              ),
              validator: _requiredValidator,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _lastNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user),
                labelText: 'Last name',
                border: OutlineInputBorder(),
              ),
              validator: _requiredValidator,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInformationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact & Location',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.call),
                labelText: 'Phone number',
                border: OutlineInputBorder(),
              ),
              validator: _phoneValidator,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _wilayaController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.location),
                labelText: 'Wilaya',
                border: OutlineInputBorder(),
              ),
              validator: _requiredValidator,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _communeController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.location),
                labelText: 'Commune',
                border: OutlineInputBorder(),
              ),
              validator: _requiredValidator,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gender',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<Gender>(
              initialValue: _selectedGender,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.profile_2user),
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: Gender.values.map((gender) {
                return DropdownMenuItem<Gender>(
                  value: gender,
                  child: Text(_formatGender(gender)),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _selectedGender = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatGender(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
    }
  }
}
