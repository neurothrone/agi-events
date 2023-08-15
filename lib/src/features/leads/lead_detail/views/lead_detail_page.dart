import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../shared/data/leads_controller.dart';
import '../widgets/lead_delete_button.dart';
import '../widgets/contact_information.dart';
import '../widgets/lead_detail_header_text.dart';
import '../widgets/lead_detail_page_app_bar.dart';
import '../widgets/custom_alert_dialog.dart';

class LeadDetailPage extends StatefulWidget {
  const LeadDetailPage({
    super.key,
    required this.lead,
  });

  final Lead lead;

  static MaterialPageRoute<void> route({required Lead lead}) =>
      MaterialPageRoute(
        builder: (context) => LeadDetailPage(
          lead: lead,
        ),
      );

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  late TextEditingController _productController;
  late TextEditingController _sellerController;
  late TextEditingController _notesController;

  late FocusNode _productNode;
  late FocusNode _sellerNode;
  late FocusNode _notesNode;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initNodes();
  }

  void _initControllers() {
    _productController = TextEditingController(text: widget.lead.product ?? "");
    _sellerController = TextEditingController(text: widget.lead.seller ?? "");
    _notesController = TextEditingController(text: widget.lead.notes ?? "");
  }

  void _initNodes() {
    _productNode = FocusNode();
    _sellerNode = FocusNode();
    _notesNode = FocusNode();
  }

  void _disposeOfControllers() {
    _productController.dispose();
    _sellerController.dispose();
    _notesController.dispose();
  }

  void _disposeOfNodes() {
    _productNode.dispose();
    _sellerNode.dispose();
    _notesNode.dispose();
  }

  @override
  void dispose() {
    _disposeOfControllers();
    _disposeOfNodes();
    super.dispose();
  }

  Future<void> _saveChanges(WidgetRef ref) async {
    await ref.read(leadsControllerProvider.notifier).updateLeadNotes(
          widget.lead.copyWith(
            product: _productController.text,
            seller: _sellerController.text,
            notes: _notesController.text,
          ),
        );
  }

  bool _hasUnsavedChanges() {
    final String product = widget.lead.product ?? "";
    final String seller = widget.lead.seller ?? "";
    final String leadNotes = widget.lead.notes ?? "";

    return [
      product != _productController.text,
      seller != _sellerController.text,
      leadNotes != _notesController.text,
    ].any((unsavedChange) => unsavedChange);
  }

  Future<void> _onCancelSaveChanges(WidgetRef ref) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    final navigator = Navigator.of(context);

    // Temporarily disable the text field's focus when the dialog appears
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    final showUnsavedChangesDialog = _hasUnsavedChanges();
    if (showUnsavedChangesDialog) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: "You have unsaved changes",
            content: "Do you want to save them?",
            backgroundColor: AppConstants.lighterBlack,
            cancelText: "Discard",
            confirmText: "Save",
            cancelColor: AppConstants.destructive,
            confirmColor: AppConstants.primaryBlue,
            isConfirmProminent: true,
            onCancel: () {
              // Do nothing
            },
            onConfirm: () {
              _saveChanges(ref);
            },
          );
        },
      );
    }

    navigator.pop();
  }

  Future<void> _onConfirmSaveChanges(WidgetRef ref) async {
    _saveChanges(ref);
    Navigator.of(context).pop();
  }

  Future<void> _onDelete(WidgetRef ref) async {
    final navigator = Navigator.of(context);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Delete Lead",
          content: "This will delete your Lead from the database. "
              "Are you sure?",
          backgroundColor: AppConstants.lighterBlack,
          cancelText: "Cancel",
          confirmText: "Delete",
          cancelColor: AppConstants.primaryBlue,
          confirmColor: AppConstants.destructive,
          isCancelProminent: true,
          onCancel: () {},
          onConfirm: () {
            // Delete Lead and pop navigator
            ref.read(leadsControllerProvider.notifier).deleteLead(widget.lead);
            navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer(
          builder: (_, ref, __) {
            return LeadDetailPageAppBar(
              onCancel: () => _onCancelSaveChanges(ref),
              onSave: () => _onConfirmSaveChanges(ref),
            );
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContactInformation(lead: widget.lead),
                        const SizedBox(height: 40.0),
                        const LeadDetailHeaderText(
                          title: "Additional Information",
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
                            FocusScope.of(context).requestFocus(_notesNode);
                          },
                          controller: _sellerController,
                          focusNode: _sellerNode,
                          labelText: "Seller",
                          hintText: "Enter seller",
                          textInputAction: TextInputAction.next,
                          isRequired: false,
                          fieldKey: const Key("sellerField"),
                        ),
                        const SizedBox(height: 20.0),
                        CustomTextFormField(
                          onFieldSubmitted: (_) {
                            _notesNode.unfocus();
                          },
                          controller: _notesController,
                          focusNode: _notesNode,
                          labelText: "Notes",
                          hintText: "Enter your notes here...",
                          textInputAction: TextInputAction.done,
                          maxLines: 10,
                          isRequired: false,
                        ),
                        const SizedBox(height: 40.0),
                        const Spacer(),
                        Consumer(
                          builder: (context, ref, __) {
                            return Align(
                              alignment: Alignment.center,
                              child: LeadDeleteButton(
                                onPressed: () => _onDelete(ref),
                                label: "Delete Lead",
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                height: 50.0,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
