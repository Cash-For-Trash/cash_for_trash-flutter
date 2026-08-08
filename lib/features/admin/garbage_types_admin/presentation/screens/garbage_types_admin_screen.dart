import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:cash_for_trash/core/routing/app_routes.dart';
import '../bloc/garbage_types_admin_bloc.dart';
import '../bloc/garbage_types_admin_event.dart';
import '../widgets/garbage_type_card_garbage_types_admin_widget.dart';

class GarbageTypesAdminScreen extends StatefulWidget {
  const GarbageTypesAdminScreen({super.key});

  @override
  State<GarbageTypesAdminScreen> createState() =>
      _GarbageTypesAdminScreenState();
}

class _GarbageTypesAdminScreenState extends State<GarbageTypesAdminScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<GarbageTypesAdminBloc>()
        .add(const GetGarbageTypesAdminEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_garbage_types'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(AppRoutes.adminGarbageTypeFormScreen);
          if (context.mounted) {
            context
                .read<GarbageTypesAdminBloc>()
                .add(const GetGarbageTypesAdminEvent());
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(context.tr('admin_add_garbage_type')),
      ),
      body: BlocBuilder<GarbageTypesAdminBloc, GarbageTypesAdminState>(
        builder: (context, state) {
          if (state is GarbageTypesAdminLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GarbageTypesAdminLoadedState) {
            if (state.garbageTypes.isEmpty) {
              return CustomErrorOrEmptyWidget(
                isError: false,
                title: context.tr('empty_no_items'),
                message: context.tr('empty_no_items_desc'),
                icon: Icons.recycling_rounded,
                actionLabel: context.tr('admin_add_garbage_type'),
                onAction: () async {
                  await context.push(AppRoutes.adminGarbageTypeFormScreen);
                  if (context.mounted) {
                    context
                        .read<GarbageTypesAdminBloc>()
                        .add(const GetGarbageTypesAdminEvent());
                  }
                },
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<GarbageTypesAdminBloc>()
                    .add(const GetGarbageTypesAdminEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: state.garbageTypes.length,
                itemBuilder: (context, index) {
                  final type = state.garbageTypes[index];
                  return GarbageTypeCardGarbageTypesAdminWidget(
                    item: type,
                    onTap: () async {
                      await context.push(AppRoutes.adminGarbageTypeFormScreen,
                          extra: type);
                      if (context.mounted) {
                        context
                            .read<GarbageTypesAdminBloc>()
                            .add(const GetGarbageTypesAdminEvent());
                      }
                    },
                    onDelete: () {
                      context
                          .read<GarbageTypesAdminBloc>()
                          .add(DeleteGarbageTypeAdminEvent(type.id));
                    },
                  );
                },
              ),
            );
          } else if (state is GarbageTypesAdminErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context
                    .read<GarbageTypesAdminBloc>()
                    .add(const GetGarbageTypesAdminEvent());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
