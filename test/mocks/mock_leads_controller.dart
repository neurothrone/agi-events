import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:agi_events/src/core/models/models.dart';
import 'package:agi_events/src/features/leads/shared/data/leads_controller.dart';

class MockLeadsController extends Mock implements LeadsController {
  @override
  Future<void> fetchLeadsByEventId(String eventId) async {
    state = const AsyncValue.data([]);
  }

  @override
  Future<void> addLeadManually({
    required Event event,
    required String firstName,
    required String lastName,
    required String company,
    required String email,
    String? phone,
    String? position,
    String? address,
    String? zipCode,
    String? city,
    String? product,
    String? seller,
    Function(String)? onError,
  }) async {}
}
