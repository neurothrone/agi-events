import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../shared/data/leads_controller.dart';
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

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  // region Fields

  late TextEditingController _productController;
  late TextEditingController _sellerController;
  late TextEditingController _notesController;

  late FocusNode _productNode;
  late FocusNode _sellerNode;
  late FocusNode _notesNode;

  // endregion

  // region Methods

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

  Future<void> _onBackPressed(WidgetRef ref) async {
    _saveChanges(ref);
    Navigator.of(context).pop();
  }

  Future<void> _onDeletePressed(WidgetRef ref) async {
    final navigator = Navigator.of(context);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Are you sure?",
          content: "Do you really want to delete this lead?",
          backgroundColor: AppConstants.lighterBlack,
          cancelText: "Cancel",
          confirmText: "Delete",
          cancelForegroundColor: Colors.grey.shade900,
          cancelBackgroundColor: Colors.grey,
          confirmBackgroundColor: AppConstants.destructive,
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

  // endregion

  // region UI

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer(
          builder: (_, ref, __) {
            return LeadDetailPageAppBar(
              onBackPressed: () => _onBackPressed(ref),
              onDeletePressed: () => _onDeletePressed(ref),
            );
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior: Platform.isIOS
                  ? ScrollViewKeyboardDismissBehavior.onDrag
                  : ScrollViewKeyboardDismissBehavior.manual,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.s20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContactInformation(lead: widget.lead),
                        const SizedBox(height: AppSizes.s40),
                        const LeadDetailHeaderText(
                          title: "Additional Information",
                        ),
                        const SizedBox(height: AppSizes.s20),
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
                        const SizedBox(height: AppSizes.s20),
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
                        const SizedBox(height: AppSizes.s20),
                        CustomTextFormField(
                          controller: _notesController,
                          focusNode: _notesNode,
                          labelText: "Notes",
                          hintText: "Enter your notes here...",
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          isRequired: false,
                          // scrollPadding: EdgeInsets.symmetric(
                          //   vertical: MediaQuery.viewInsetsOf(context).bottom,
                          // ),
                        ),
                        // const SizedBox(height: AppSizes.s40),
                        // const Spacer(),
                        // Consumer(
                        //   builder: (context, ref, __) {
                        //     return Align(
                        //       alignment: Alignment.center,
                        //       child: LeadDeleteButton(
                        //         onPressed: () => _onDeletePressed(ref),
                        //         label: "Delete",
                        //         width: MediaQuery.sizeOf(context).width * 0.4,
                        //         height: AppSizes.s48,
                        //       ),
                        //     );
                        //   },
                        // ),
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

    if (Platform.isAndroid) {
      return Consumer(
        builder: (_, ref, __) {
          return WillPopScope(
            onWillPop: () async {
              _onBackPressed(ref);
              return true;
            },
            child: scaffold,
          );
        },
      );
    }

    return scaffold;
  }

// endregion
}
