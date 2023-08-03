import 'package:flutter/material.dart';

import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';

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

  void _addLead() {}

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
            label: "First Name",
            hintText: "Enter first name",
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _lastNameController,
            label: "Last Name",
            hintText: "Enter last name",
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _companyController,
            label: "Company",
            hintText: "Enter company",
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _emailController,
            label: "E-mail",
            hintText: "Enter e-mail",
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _phoneController,
            label: "Phone",
            hintText: "Enter phone number",
            isRequired: false,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _addressController,
            label: "Address",
            hintText: "Enter address",
            isRequired: false,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _zipCodeController,
            label: "Zip code",
            hintText: "Enter zip code",
            isRequired: false,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            controller: _cityController,
            label: "City",
            hintText: "Enter city",
            isRequired: false,
          ),
          const SizedBox(height: 40.0),
          PrimaryButton(
            onPressed: _addLead,
            label: "Next",
            height: 60.0,
          ),
        ],
      ),
    );
  }
}
