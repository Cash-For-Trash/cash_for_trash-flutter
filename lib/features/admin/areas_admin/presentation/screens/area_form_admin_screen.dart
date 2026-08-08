import 'package:cash_for_trash/core/extensions/context_extensions.dart';
import 'package:cash_for_trash/core/localization/app_localizations.dart';
import 'package:cash_for_trash/core/widgets/custom_primary_button.dart';
import 'package:cash_for_trash/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/area_admin_model.dart';
import '../bloc/areas_admin_bloc.dart';
import '../bloc/areas_admin_event.dart';
import '../widgets/map_rectangle_selector_areas_admin_widget.dart';

class AreaFormAdminScreen extends StatefulWidget {
  final AreaAdminModel? existingArea;

  const AreaFormAdminScreen({
    super.key,
    this.existingArea,
  });

  @override
  State<AreaFormAdminScreen> createState() => _AreaFormAdminScreenState();
}

class _AreaFormAdminScreenState extends State<AreaFormAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  bool _isSubmitting = false;

  double _neLat = 26.1700;
  double _neLng = 32.7300;
  double _swLat = 26.1400;
  double _swLng = 32.7000;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingArea?.name ?? '');
    _priceController = TextEditingController(
        text: widget.existingArea?.servicePrice.toString() ?? '20');

    if (widget.existingArea != null) {
      _neLat = widget.existingArea!.northLat;
      _neLng = widget.existingArea!.eastLng;
      _swLat = widget.existingArea!.southLat;
      _swLng = widget.existingArea!.westLng;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveArea() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'name': _nameController.text.trim(),
        'north_lat': _neLat,
        'south_lat': _swLat,
        'east_lng': _neLng,
        'west_lng': _swLng,
        'service_price': double.parse(_priceController.text.trim()),
      };

      setState(() {
        _isSubmitting = true;
      });

      if (widget.existingArea == null) {
        context.read<AreasAdminBloc>().add(CreateAreaAdminEvent(data));
      } else {
        context.read<AreasAdminBloc>().add(UpdateAreaAdminEvent(
              id: widget.existingArea!.id,
              data: data,
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingArea != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? context.tr('edit_address') : context.tr('admin_add_area'),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<AreasAdminBloc, AreasAdminState>(
        listener: (context, state) {
          if (_isSubmitting) {
            if (state is AreasAdminLoadedState && !state.isActionLoading) {
              setState(() {
                _isSubmitting = false;
              });
              context.pop();
            } else if (state is AreasAdminErrorState) {
              setState(() {
                _isSubmitting = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: context.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          final isLoading = _isSubmitting ||
              (state is AreasAdminLoadedState && state.isActionLoading);

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: _nameController,
                    hintText: 'Area Name (e.g. Qena City, Qena)',
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return context.tr('field_required');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFormField(
                    controller: _priceController,
                    hintText: '${context.tr('admin_service_price')} (EGP)',
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return context.tr('field_required');
                      }
                      if (double.tryParse(val) == null) {
                        return context.tr('invalid_number');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    context.tr('admin_select_area_on_map'),
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  MapRectangleSelectorAreasAdminWidget(
                    initialNeLat: _neLat,
                    initialNeLng: _neLng,
                    initialSwLat: _swLat,
                    initialSwLng: _swLng,
                    onBoundsChanged: (neLat, neLng, swLat, swLng) {
                      setState(() {
                        _neLat = neLat;
                        _neLng = neLng;
                        _swLat = swLat;
                        _swLng = swLng;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NE Corner: ${_neLat.toStringAsFixed(4)}, ${_neLng.toStringAsFixed(4)}',
                          style: context.textTheme.bodySmall,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'SW Corner: ${_swLat.toStringAsFixed(4)}, ${_swLng.toStringAsFixed(4)}',
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomPrimaryButton(
                    text: context.tr('admin_save'),
                    isLoading: isLoading,
                    onTap: isLoading ? null : _saveArea,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
