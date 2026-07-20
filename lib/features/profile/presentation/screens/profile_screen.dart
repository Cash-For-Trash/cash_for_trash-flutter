import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:cash_for_trash/core/widgets/custom_confirmation_dialog.dart';
import 'package:cash_for_trash/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cash_for_trash/features/profile/presentation/bloc/profile_event.dart';
import 'package:cash_for_trash/features/profile/presentation/bloc/profile_state.dart';
import 'package:cash_for_trash/features/profile/presentation/widgets/header_profile_section.dart';
import 'package:cash_for_trash/features/profile/presentation/widgets/logout_button_profile_widget.dart';
import 'package:cash_for_trash/features/profile/presentation/widgets/menu_group_profile_section.dart';
import 'package:cash_for_trash/features/profile/presentation/widgets/stats_grid_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileDataEvent());
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: context.tr('logout_confirm_title'),
        message: context.tr('logout_confirm_message'),
        confirmText: context.tr('yes'),
        cancelText: context.tr('no'),
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          context.read<ProfileBloc>().add(LogoutEvent());
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogoutSuccessState) {
            context.go(AppRoutes.loginScreen);
          } else if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          String userFullName = '';
          String userEmail = '';

          if (state is ProfileLoadedState) {
            userFullName = '${state.firstName} ${state.lastName}'.trim();
            userEmail = state.email;
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Segment
                    HeaderProfileSection(
                      name: userFullName,
                      email: userEmail,
                    ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      child: Column(
                        children: [
                          // Stats grid card layout
                          const StatsGridProfileSection(),
                          
                          SizedBox(height: 16.h),
                          
                          // Account group
                          MenuGroupProfileSection(
                            groupTitle: context.tr('my_account'),
                            items: [
                              ProfileMenuItem(
                                title: context.tr('order_history'),
                                subtitle: '12 ${context.tr('orders')}',
                                icon: Icons.receipt_long_rounded,
                                onTap: () {},
                              ),
                              ProfileMenuItem(
                                title: context.tr('my_subscription'),
                                subtitle: context.tr('free_plan'),
                                icon: Icons.workspace_premium_rounded,
                                onTap: () {},
                              ),
                              ProfileMenuItem(
                                title: context.tr('notifications'),
                                subtitle: '3 unread',
                                icon: Icons.notifications_active_rounded,
                                onTap: () {},
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 16.h),
                          
                          // Preferences group
                          MenuGroupProfileSection(
                            groupTitle: context.tr('preferences'),
                            items: [
                              ProfileMenuItem(
                                title: context.tr('language'),
                                subtitle: context.tr('arabic'),
                                icon: Icons.translate_rounded,
                                onTap: () {},
                              ),
                              ProfileMenuItem(
                                title: context.tr('privacy'),
                                subtitle: context.tr('data_settings'),
                                icon: Icons.lock_outline_rounded,
                                onTap: () {},
                              ),
                              ProfileMenuItem(
                                title: context.tr('settings'),
                                icon: Icons.settings_rounded,
                                onTap: () {},
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 16.h),
                          
                          // Support group
                          MenuGroupProfileSection(
                            groupTitle: context.tr('support'),
                            items: [
                              ProfileMenuItem(
                                title: context.tr('technical_support'),
                                subtitle: context.tr('available_24_7'),
                                icon: Icons.support_agent_rounded,
                                onTap: () {},
                              ),
                              ProfileMenuItem(
                                title: context.tr('rate_app'),
                                subtitle: context.tr('help_us_improve'),
                                icon: Icons.rate_review_rounded,
                                onTap: () {},
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 24.h),
                          
                          // Logout button
                          LogoutButtonProfileWidget(
                            onTap: () => _showLogoutConfirmation(context),
                          ),
                          
                          SizedBox(height: 48.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (state is ProfileLoadingState)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}