import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../data/leads_controller.dart';

class AddLeadForm extends StatefulWidget {
  const AddLeadForm({
    super.key,
  });

  @override
  State<AddLeadForm> createState() => _AddLeadFormState();
}

class _AddLeadFormState extends State<AddLeadForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();

  // Initially form is not valid since all fields are empty
  final ValueNotifier<bool> _isFormValid = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _addFormValidationListeners();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _addFormValidationListeners() {
    _firstNameController.addListener(() {
      _isFormValid.value = _isAllRequiredInputValid();
    });
    _lastNameController.addListener(() {
      _isFormValid.value = _isAllRequiredInputValid();
    });
    _companyController.addListener(() {
      _isFormValid.value = _isAllRequiredInputValid();
    });
    _emailController.addListener(() {
      _isFormValid.value = _isAllRequiredInputValid();
    });
  }

  bool _isAllRequiredInputValid() {
    final isFormNotValid = [
      _firstNameController.text.isEmpty,
      _lastNameController.text.isEmpty,
      _companyController.text.isEmpty,
      _emailController.text.isEmpty,
    ].any((isNotValid) => isNotValid);

    return !isFormNotValid;
  }

  void _addLead(WidgetRef ref) {
    ref.read(leadsControllerProvider.notifier).addLead(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          company: _companyController.text,
          email: _emailController.text,
          phone:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          position:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          address:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          zipCode:
              _phoneController.text.isNotEmpty ? _phoneController.text : null,
          city: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // OriginalTextFormField(
          //   controller: _lastNameController,
          //   label: "Last Name",
          //   hintText: "Enter last name",
          // ),
          CustomTextFormField(
            controller: _firstNameController,
            labelText: "First Name",
            hintText: "Enter first name",
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _lastNameController,
            labelText: "Last Name",
            hintText: "Enter last name",
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _companyController,
            labelText: "Company",
            hintText: "Enter company",
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _emailController,
            labelText: "E-mail",
            hintText: "Enter e-mail",
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _phoneController,
            labelText: "Phone",
            hintText: "Enter phone number",
            keyboardType: TextInputType.phone,
            isRequired: false,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _addressController,
            labelText: "Address",
            hintText: "Enter address",
            keyboardType: TextInputType.streetAddress,
            isRequired: false,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _zipCodeController,
            labelText: "Zip code",
            hintText: "Enter zip code",
            isRequired: false,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _cityController,
            labelText: "City",
            hintText: "Enter city",
            isRequired: false,
          ),
          const SizedBox(height: 40.0),
          ValueListenableBuilder(
            valueListenable: _isFormValid,
            builder: (_, bool isFormValid, __) {
              return Consumer(
                builder: (context, WidgetRef ref, child) {
                  return PrimaryButton(
                    onPressed: isFormValid ? () => _addLead(ref) : null,
                    label: "Next",
                    height: 60.0,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
