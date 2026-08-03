import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cash_for_trash/core/routing/app_routes.dart';
import '../bloc/areas_admin_bloc.dart';
import '../bloc/areas_admin_event.dart';
import '../bloc/areas_admin_state.dart';
import '../widgets/area_card_areas_admin_widget.dart';

class AreasAdminScreen extends StatefulWidget {
  const AreasAdminScreen({super.key});

  @override
  State<AreasAdminScreen> createState() => _AreasAdminScreenState();
}

class _AreasAdminScreenState extends State<AreasAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AreasAdminBloc>().add(const GetAreasAdminEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_areas'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.adminAreaFormScreen);
        },
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(context.tr('admin_add_area')),
      ),
      body: BlocBuilder<AreasAdminBloc, AreasAdminState>(
        builder: (context, state) {
          if (state is AreasAdminLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AreasAdminLoadedState) {
            if (state.areas.isEmpty) {
              return CustomErrorOrEmptyWidget(
                isError: false,
                title: context.tr('empty_no_items'),
                message: context.tr('empty_no_items_desc'),
                icon: Icons.map_outlined,
                actionLabel: context.tr('admin_add_area'),
                onAction: () {
                  context.push(AppRoutes.adminAreaFormScreen);
                },
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AreasAdminBloc>().add(const GetAreasAdminEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: state.areas.length,
                itemBuilder: (context, index) {
                  final area = state.areas[index];
                  return AreaCardAreasAdminWidget(
                    area: area,
                    onTap: () {
                      context.push(AppRoutes.adminAreaFormScreen, extra: area);
                    },
                    onDelete: () {
                      context
                          .read<AreasAdminBloc>()
                          .add(DeleteAreaAdminEvent(area.id));
                    },
                  );
                },
              ),
            );
          } else if (state is AreasAdminErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context.read<AreasAdminBloc>().add(const GetAreasAdminEvent());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
