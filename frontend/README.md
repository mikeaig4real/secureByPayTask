# SecureByPay - Flutter Web Frontend

A responsive Flutter Web application implementing the SecureByPay logistics and payments dashboard from Figma specifications.

---

## Key Features

- **Pixel-Accurate Design**: Faithfully translates Figma styles, color tokens, typography (Plus Jakarta Sans), and card layouts.
- **Pure Component Architecture**:
  - `StatusBadge`: Pure stateless component for shipment status badges (`In-Transit`, `Delayed`, `Delivered`, `Cancelled`).
  - `NigeriaFlagIcon`: Pure vector component for Nigerian flag indicators.
  - `SectionHeader`: Pure stateless section title with action button or filter widget.
  - `PlaceholderView`: Pure widget for screens and sub-modules under development.
  - `EmptyStateWidget`: Pure widget for empty data states.
  - `SidebarNavItem`: Pure navigation item widget for drawer navigation.
  - `AuthLegalFooter`: Pure legal disclaimer link footer shared across authentication screens.
- **Responsive Layout**:
  - **Desktop** (`> 1024px`): Fixed navigation sidebar, multi-column dashboard grid, header with live user profile.
  - **Tablet** (`768px – 1024px`): Adaptive two-column grid with drawer navigation.
  - **Mobile** (`< 768px`): Stacked single-column layout, bottom sheets, mobile-first navigation drawer.
- **Interactive Capabilities**:
  - Spline growth chart with dynamic time-range filter (`Year`, `Month`, `Week`).
  - Interactive wallet funding dialog with real-time balance updates.
  - Direct shipment payment flow with status reflection (`In-Transit`, `Delayed`, `Paid`).
  - Form validation with reactive loading states and error banners.
- **Provider Architecture**: Separation between pure presentational widgets, connected container widgets, and reactive stores (`AuthStore`, `DashboardStore`).

---

## Environment Setup

The application reads compile-time configuration through Dart environment defines.

Create a `.env` file from the provided template:

```powershell
Copy-Item .env.example .env
```

Default variables:
```properties
API_URL=http://localhost:5000/api
TOKEN_STORAGE_KEY=securebypay_jwt_token
ENVIRONMENT=development
LOG_LEVEL=info
```

---

## Development & Testing

```powershell
# 1. Install packages
flutter pub get

# 2. Run unit, model, and widget tests
flutter test

# 3. Analyze code quality
flutter analyze

# 4. Run on Chrome (port 3000)
flutter run -d chrome --web-port=3000 --dart-define-from-file=.env

# 5. Build for production deployment (relative API for single-host hosting)
flutter build web --release --dart-define=API_URL=/api
```
