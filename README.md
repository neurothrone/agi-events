# AGI Events

## Supported Platforms and Versions

Android:

- Minimum Supported Version: Android 5.0 (Lollipop) - API Level 21

iOS:

- Minimum Supported Version: iOS 11.0

Note:

- While these versions are the minimum requirements, we recommend always using the app on the
  latest version of the OS for the best experience.

## Directory Structure of `lib`

### `src`

The primary source directory containing core components, features, and infrastructure elements.

### `core`

Foundational utilities, constants, and shared components utilized throughout the application.

- **`constants`**: Constants employed across the app.
- **`interfaces`**: Abstract type definitions and contracts.
- **`models`**: Data models encapsulating business logic.
- **`theme`**: Application-wide theme data for consistent styling.
- **`utils`**: Utility functions and helpers.
- **`widgets`**: Custom widgets reused in various parts of the app.

### `features`

Distinct functionalities or modules within the application.

- **`csv`**: Operations related to CSV file generation and sharing.
- **`events`**: Components and logic associated with event management.
- **`leads`**: Components and logic related to lead management, further subdivided into:
    - **`add_lead`**: Components for adding a new lead.
    - **`lead_detail`**: Detailed view and associated logic for individual leads.
    - **`my_leads`**: Components and logic pertaining to a user's personal leads.
    - **`shared`**: Components and logic shared across the `leads` feature.
- **`qr_scan`**: Functionality related to QR code scanning.

### `infrastructure`

Infrastructure layer of the application, including data storage and external service integrations.

- **`database`**: Logic, queries, and utilities related to database operations.
- **`firebase`**: Functionality and logic tied to Firebase integration.
- **`prototypes`**: Prototypes, mock data, and logic for development and prototyping.

### `app.dart`

Holds the primary application widget.
Typically, wraps the entire app with provider scope, routers, and other foundational setup.

### `main.dart`

The application's entry point. Initializes and runs the app.
