import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:project/core/error/failure_type.dart';
import 'package:project/core/router/app_router.dart';
import 'package:project/core/widgets/failure_widget.dart';
import 'package:go_router/go_router.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().fetchProfile();
    });
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFEAB308), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),

      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            context.go(AppRouter.loginRoute);
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFEAB308)),
              );
            } else if (state is ProfileError) {
              final isUnauthorized = state.type == FailureType.unauthorized;

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FailureWidget(
                          type: state.type,
                          message: state.message,
                          onRetry: isUnauthorized
                              ? () => context.read<ProfileCubit>().logoutUser()
                              : () =>
                                    context.read<ProfileCubit>().fetchProfile(),
                          buttonText: isUnauthorized ? "Go to Sign In" : null,
                          buttonIcon: isUnauthorized ? Icons.login : null,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is ProfileLoaded) {
              final profile = state.profile;
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    FakeGlass(
                      shape: LiquidRoundedSuperellipse(borderRadius: 24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: const Color(0xFF2A2A2A),
                              backgroundImage: profile.avatar != null
                                  ? NetworkImage(profile.avatar!)
                                  : null,
                              child: profile.avatar == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white54,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              profile.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 24),
                            Divider(color: Colors.white.withValues(alpha: 0.1)),
                            _buildInfoRow(
                              Icons.email_outlined,
                              "Email",
                              profile.email,
                            ),
                            Divider(color: Colors.white.withValues(alpha: 0.1)),
                            _buildInfoRow(
                              Icons.phone_outlined,
                              "Phone",
                              profile.phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ProfileCubit>().logoutUser();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Log Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE51937),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        textStyle: const TextStyle(
                          fontFamily: 'Sora',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
