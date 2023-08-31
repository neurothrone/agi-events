import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../routing/routing.dart';
import '../../shared/data/leads_controller.dart';

class AddLeadForm extends StatefulWidget {
  const AddLeadForm({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  State<AddLeadForm> createState() => _AddLeadFormState();
}

class _AddLeadFormState extends State<AddLeadForm> {
  // region Fields

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();

  late FocusNode _firstNameNode;
  late FocusNode _lastNameNode;
  late FocusNode _companyNode;
  late FocusNode _emailNode;
  late FocusNode _phoneNode;
  late FocusNode _addressNode;
  late FocusNode _zipCodeNode;
  late FocusNode _cityNode;

  // Initially form is not valid since all fields are empty
  final ValueNotifier<bool> _isFormValid = ValueNotifier(false);

  // endregion

  // region Methods

  @override
  void initState() {
    super.initState();
    _initNodes();
    _addFormValidationListeners();
  }

  void _initNodes() {
    _firstNameNode = FocusNode();
    _lastNameNode = FocusNode();
    _companyNode = FocusNode();
    _emailNode = FocusNode();
    _phoneNode = FocusNode();
    _addressNode = FocusNode();
    _zipCodeNode = FocusNode();
    _cityNode = FocusNode();
  }

  void _disposeOfNodes() {
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _companyNode.dispose();
    _emailNode.dispose();
    _phoneNode.dispose();
    _addressNode.dispose();
    _zipCodeNode.dispose();
    _cityNode.dispose();
  }

  void _disposeOfControllers() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
  }

  @override
  void dispose() {
    _disposeOfControllers();
    _disposeOfNodes();
    super.dispose();
  }

  void _addFormValidationListeners() {
    _firstNameController.addListener(() {
      _isFormValid.value = _isAnyInputValid();
    });
    _lastNameController.addListener(() {
      _isFormValid.value = _isAnyInputValid();
    });
    _companyController.addListener(() {
      _isFormValid.value = _isAnyInputValid();
    });
    _emailController.addListener(() {
      _isFormValid.value = _isAnyInputValid();
    });
    _phoneController.addListener(() {
      _isFormValid.value = _isAnyInputValid();
    });
    _addressController.addListener(() {
      _isFormValid.value = _isAnyInputValid();
    });
    _zipCodeController.addListener(() {
      _isFormValid.value = _isAnyInputValid();
    });
    _cityController.addListener(() {
      _isFormValid.value = _isAnyInputValid();
    });
  }

  bool _isAnyInputValid() {
    final isFormValid = [
      _firstNameController.text.isNotEmpty,
      _lastNameController.text.isNotEmpty,
      _companyController.text.isNotEmpty,
      _emailController.text.isNotEmpty,
      _phoneController.text.isNotEmpty,
      _addressController.text.isNotEmpty,
      _zipCodeController.text.isNotEmpty,
      _cityController.text.isNotEmpty,
    ].any((isValid) => isValid);

    return isFormValid;
  }

  Future<void> _addLead(WidgetRef ref) async {
    final Lead? lead = await ref
        .read(leadsControllerProvider.notifier)
        .addLeadManually(
          event: widget.event,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          company: _companyController.text,
          email: _emailController.text,
          phone:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          address: _addressController.text.isNotEmpty
              ? _addressController.text
              : null,
          zipCode: _zipCodeController.text.isNotEmpty
              ? _zipCodeController.text
              : null,
          city: _cityController.text.isNotEmpty ? _cityController.text : null,
          onError: (_) {
            showSnackbar(
              message: "Failed to save Lead. Please try again.",
              context: context,
            );
          },
        );

    // Pop the AddLeadSheet and navigate directly to LeadDetailPage
    // with the new Lead
    if (lead != null && context.mounted) {
      context.pop();
      context.pushNamed(AppRoute.leadDetail.name, extra: lead);
    }
  }

  // endregion

  // region UI

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_lastNameNode);
            },
            controller: _firstNameController,
            focusNode: _firstNameNode,
            labelText: "First Name",
            hintText: "Enter first name",
            textInputAction: TextInputAction.next,
            isRequired: false,
            fieldKey: const Key("firstNameField"),
          ),
          const SizedBox(height: AppSizes.s20),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_companyNode);
            },
            controller: _lastNameController,
            focusNode: _lastNameNode,
            labelText: "Last Name",
            hintText: "Enter last name",
            textInputAction: TextInputAction.next,
            isRequired: false,
            fieldKey: const Key("lastNameField"),
          ),
          const SizedBox(height: AppSizes.s20),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_emailNode);
            },
            controller: _companyController,
            focusNode: _companyNode,
            labelText: "Company",
            hintText: "Enter company",
            textInputAction: TextInputAction.next,
            isRequired: false,
            fieldKey: const Key("companyField"),
          ),
          const SizedBox(height: AppSizes.s20),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_phoneNode);
            },
            controller: _emailController,
            focusNode: _emailNode,
            labelText: "E-mail",
            hintText: "Enter e-mail",
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
            isRequired: false,
            fieldKey: const Key("emailField"),
          ),
          const SizedBox(height: AppSizes.s20),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_addressNode);
            },
            controller: _phoneController,
            focusNode: _phoneNode,
            labelText: "Phone",
            hintText: "Enter phone number",
            keyboardType: Platform.isIOS
                ? const TextInputType.numberWithOptions(signed: true)
                : TextInputType.phone,
            textInputAction: TextInputAction.next,
            isRequired: false,
          ),
          const SizedBox(height: AppSizes.s20),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_zipCodeNode);
            },
            controller: _addressController,
            focusNode: _addressNode,
            labelText: "Address",
            hintText: "Enter address",
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            isRequired: false,
          ),
          const SizedBox(height: AppSizes.s20),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_cityNode);
            },
            controller: _zipCodeController,
            focusNode: _zipCodeNode,
            labelText: "Zip code",
            hintText: "Enter zip code",
            textInputAction: TextInputAction.next,
            isRequired: false,
          ),
          const SizedBox(height: AppSizes.s20),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              _cityNode.unfocus();
            },
            controller: _cityController,
            focusNode: _cityNode,
            labelText: "City",
            hintText: "Enter city",
            textInputAction: TextInputAction.done,
            isRequired: false,
            fieldKey: const Key("cityField"),
          ),
          const SizedBox(height: AppSizes.s40),
          ValueListenableBuilder(
            valueListenable: _isFormValid,
            builder: (_, bool isFormValid, __) {
              return Consumer(
                builder: (context, WidgetRef ref, child) {
                  return PrimaryButton(
                    onPressed: isFormValid ? () => _addLead(ref) : null,
                    label: "Next",
                    height: 60.0,
                    backgroundColor: AppConstants.primaryBlueLighter,
                    uniqueKey: const Key("nextButton"),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

// endregion
}
