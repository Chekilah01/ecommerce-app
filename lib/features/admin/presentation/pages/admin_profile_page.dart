import 'package:final_project/core/config/app_mode_settings.dart';
import 'package:final_project/features/auth/domain/entities/user_entity.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:final_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:final_project/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  Future<void> _pickProfileImage(
    BuildContext context,
    ImageSource source,
  ) async {
    final imagePicker = ImagePicker();

    final image = await imagePicker.pickImage(source: source, imageQuality: 80);

    if (image == null || !context.mounted) {
      return;
    }

    context.read<AuthBloc>().add(UpdateProfileImageEvent(image));
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Change Profile Picture',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(Iconsax.camera),
                  title: const Text('Take a photo'),
                  subtitle: const Text('Use your camera'),
                  onTap: () {
                    Navigator.pop(sheetContext);

                    _pickProfileImage(context, ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: const Icon(Iconsax.gallery),
                  title: const Text('Choose from gallery'),
                  subtitle: const Text('Select an existing photo'),
                  onTap: () {
                    Navigator.pop(sheetContext);

                    _pickProfileImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, value, child) {
              final isDark = value == ThemeMode.dark;
              return IconButton(
                onPressed: () {
                  themeNotifier.value = isDark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
                icon: Icon(isDark ? Iconsax.sun_1 : Iconsax.moon),
                tooltip: isDark
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! Authenticated) {
            return const Center(child: Text('Unable to load profile.'));
          }

          final user = state.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),

                _buildProfileHeader(context, user),

                const SizedBox(height: 32),

                _buildAccountInformationCard(context, user),

                const SizedBox(height: 16),

                _buildLocationCard(context, user),

                const SizedBox(height: 24,),

                _buildEditProfileButton(context),

                const SizedBox(height: 16),

                _buildLogoutButton(context),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserEntity user) {
    final fullName = '${user.firstName} ${user.lastName}';

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 62,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: user.imageUrl != null
                  ? NetworkImage(user.imageUrl!)
                  : AssetImage('assets/images/default_profile_picture.jpg'),
            ),

            Positioned(
              right: -2,
              bottom: -2,
              child: InkWell(
                onTap: () => _showImageSourceSheet(context),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Text(
          fullName,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),

        const SizedBox(height: 6),

        Card(
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkContainer
                  : AppColors.lightContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.success,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInformationCard(BuildContext context, UserEntity user) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionTitle(
              context,
              icon: Iconsax.profile_circle,
              title: 'Account Information',
            ),

            const SizedBox(height: 20),

            _buildInfoRow(
              context,
              icon: Iconsax.sms,
              label: 'Email',
              value: user.email,
            ),

            const Divider(height: 24),

            _buildInfoRow(
              context,
              icon: Iconsax.call,
              label: 'Phone',
              value: user.phone,
            ),

            const Divider(height: 24),

            _buildInfoRow(
              context,
              icon: Iconsax.user,
              label: 'Gender',
              value: user.gender.name,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, UserEntity user) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionTitle(
              context,
              icon: Iconsax.location,
              title: 'Location',
            ),

            const SizedBox(height: 20),

            _buildInfoRow(
              context,
              icon: Iconsax.map,
              label: 'Wilaya',
              value: user.wilaya,
            ),

            const Divider(height: 24),

            _buildInfoRow(
              context,
              icon: Iconsax.location,
              label: 'Commune',
              value: user.commune,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),

        const SizedBox(width: 10),

        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.lightContainer
                : AppColors.dark,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<AuthBloc>().add(const LogoutEvent());
        },
        icon: const Icon(Iconsax.logout),
        label: const Text('Log Out'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          foregroundColor: Theme.of(context).colorScheme.error,
          side: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Navigate to Edit Profile screen or open modal
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profile'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 0,
        ),
      ),
    );
  }
}
