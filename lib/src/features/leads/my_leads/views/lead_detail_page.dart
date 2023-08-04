import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_text_form_field.dart';

class LeadDetailPage extends StatelessWidget {
  const LeadDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lead"),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Save",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contact Information",
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text("Anders Andersson"),
              SizedBox(height: 10.0),
              Text("AddBrand"),
              SizedBox(height: 10.0),
              Text("anders.andersson@example.com"),
              SizedBox(height: 10.0),
              Text("tel: 123456789"),
              SizedBox(height: 40.0),
              Text(
                "Additional Information",
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 10.0),
              CustomTextFormField(
                hintText: "Enter text here...",
                maxLines: 10,
                isRequired: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
