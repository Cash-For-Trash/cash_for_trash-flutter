import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/customers_admin_bloc.dart';
import '../bloc/customers_admin_event.dart';
import '../bloc/customers_admin_state.dart';
import '../widgets/customer_card_customers_admin_widget.dart';

class CustomersAdminScreen extends StatefulWidget {
  const CustomersAdminScreen({super.key});

  @override
  State<CustomersAdminScreen> createState() => _CustomersAdminScreenState();
}

class _CustomersAdminScreenState extends State<CustomersAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CustomersAdminBloc>().add(const GetCustomersAdminEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('admin_customers'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<CustomersAdminBloc, CustomersAdminState>(
        builder: (context, state) {
          if (state is CustomersAdminLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomersAdminLoadedState) {
            if (state.customers.isEmpty) {
              return CustomErrorOrEmptyWidget(
                isError: false,
                title: context.tr('empty_no_items'),
                message: context.tr('empty_no_items_desc'),
                icon: Icons.people_outline_rounded,
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<CustomersAdminBloc>()
                    .add(const GetCustomersAdminEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: state.customers.length,
                itemBuilder: (context, index) {
                  final customer = state.customers[index];
                  return CustomerCardCustomersAdminWidget(
                    customer: customer,
                    onTap: () {
                      context
                          .read<CustomersAdminBloc>()
                          .add(GetCustomerDetailAdminEvent(customer.id));
                    },
                  );
                },
              ),
            );
          } else if (state is CustomersAdminErrorState) {
            return CustomErrorOrEmptyWidget(
              isError: true,
              errorMessage: state.errorMessage,
              onRetry: () {
                context
                    .read<CustomersAdminBloc>()
                    .add(const GetCustomersAdminEvent());
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
