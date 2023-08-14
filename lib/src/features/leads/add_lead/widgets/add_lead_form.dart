import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _productController = TextEditingController();
  final _sellerController = TextEditingController();

  late FocusNode _firstNameNode;
  late FocusNode _lastNameNode;
  late FocusNode _companyNode;
  late FocusNode _emailNode;
  late FocusNode _phoneNode;
  late FocusNode _addressNode;
  late FocusNode _zipCodeNode;
  late FocusNode _cityNode;
  late FocusNode _productNode;
  late FocusNode _sellerNode;

  // Initially form is not valid since all fields are empty
  final ValueNotifier<bool> _isFormValid = ValueNotifier(false);

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
    _productNode = FocusNode();
    _sellerNode = FocusNode();
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
    _productNode.dispose();
    _sellerNode.dispose();
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
    ref.read(leadsControllerProvider.notifier).addLeadManually(
          event: widget.event,
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
          product: _productController.text.isNotEmpty
              ? _productController.text
              : null,
          seller:
              _sellerController.text.isNotEmpty ? _sellerController.text : null,
        );
    Navigator.pop(context);
  }

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
            key: const Key("firstNameField"),
            controller: _firstNameController,
            focusNode: _firstNameNode,
            labelText: "First Name",
            hintText: "Enter first name",
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_companyNode);
            },
            key: const Key("lastNameField"),
            controller: _lastNameController,
            focusNode: _lastNameNode,
            labelText: "Last Name",
            hintText: "Enter last name",
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_emailNode);
            },
            key: const Key("companyField"),
            controller: _companyController,
            focusNode: _companyNode,
            labelText: "Company",
            hintText: "Enter company",
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_phoneNode);
            },
            key: const Key("emailField"),
            controller: _emailController,
            focusNode: _emailNode,
            labelText: "E-mail",
            hintText: "Enter e-mail",
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20.0),
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
          const SizedBox(height: 20.0),
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
          const SizedBox(height: 20.0),
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
          const SizedBox(height: 20.0),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_productNode);
            },
            controller: _cityController,
            focusNode: _cityNode,
            labelText: "City",
            hintText: "Enter city",
            textInputAction: TextInputAction.next,
            isRequired: false,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_sellerNode);
            },
            controller: _productController,
            focusNode: _productNode,
            labelText: "Product(s)",
            hintText: "Enter your product(s)",
            textInputAction: TextInputAction.next,
            isRequired: false,
          ),
          const SizedBox(height: 20.0),
          CustomTextFormField(
            onFieldSubmitted: (_) {
              _sellerNode.unfocus();
            },
            controller: _sellerController,
            focusNode: _sellerNode,
            labelText: "Seller",
            hintText: "Enter seller",
            textInputAction: TextInputAction.done,
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
                    backgroundColor: AppConstants.primaryBlueLighter,
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
