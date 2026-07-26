import 'package:cash_for_trash/features/address/data/model/address_model.dart';
import 'package:cash_for_trash/features/maps/data/model/create_address_request_model.dart';
import 'package:cash_for_trash/features/maps/data/model/selected_location_model.dart';
import 'package:cash_for_trash/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:cash_for_trash/features/maps/presentation/screens/widgets/details_section_address_form_widget.dart';
import 'package:cash_for_trash/features/maps/presentation/screens/widgets/header_address_form_widget.dart';
import 'package:cash_for_trash/features/maps/presentation/screens/widgets/save_button_address_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddressFormScreen extends StatefulWidget {
  final SelectedLocationModel selectedLocation;
  final AddressModel? existingAddress;

  const AddressFormScreen({
    super.key,
    required this.selectedLocation,
    this.existingAddress,
  });

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _locationController;
  late final TextEditingController _buildingNumController;
  late final TextEditingController _floorController;
  late final TextEditingController _additionalNoteController;

  bool get _isEditMode => widget.existingAddress != null;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(
      text: widget.existingAddress?.location ?? widget.selectedLocation.displayAddress,
    );
    _buildingNumController = TextEditingController(
      text: widget.existingAddress?.buildingNum.toString() ?? '',
    );
    _floorController = TextEditingController(
      text: widget.existingAddress?.floor ?? '',
    );
    _additionalNoteController = TextEditingController(
      text: widget.existingAddress?.additionalNote ?? '',
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _buildingNumController.dispose();
    _floorController.dispose();
    _additionalNoteController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateAddressRequestModel(
      location: _locationController.text.trim(),
      latitude: widget.selectedLocation.latitude.toString(),
      longitude: widget.selectedLocation.longitude.toString(),
      buildingNum: int.parse(_buildingNumController.text.trim()),
      floor: _floorController.text.trim(),
      additionalNote: _additionalNoteController.text.trim(),
    );

    context.read<MapsBloc>().add(
          MapsSaveAddressEvent(
            request: request,
            existingAddressId: widget.existingAddress?.addressId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapsBloc, MapsState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        final isSaving = state is MapsAddressSavingState;
        return Scaffold(
          body: Column(
            children: [
              HeaderAddressFormWidget(isEditMode: _isEditMode),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DetailsSectionAddressFormWidget(
                          locationController: _locationController,
                          buildingNumController: _buildingNumController,
                          floorController: _floorController,
                          additionalNoteController: _additionalNoteController,
                        ),
                        SizedBox(height: 24.h),
                        SaveButtonAddressFormWidget(
                          isLoading: isSaving,
                          onPressed: () => _onSave(context),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, MapsState state) {
    if (state is MapsAddressSavedState) {
      context.pop<AddressModel>(state.savedAddress);
    } else if (state is MapsAddressSaveErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
