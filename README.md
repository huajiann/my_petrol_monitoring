# Malaysia Petrol Price Monitoring System

A Flutter web application that monitors petrol prices in Malaysia, compliant with the Malaysia Government Design System.

🌐 **Live Demo**: [https://huajiann.github.io/my_petrol_monitoring](https://huajiann.github.io/my_petrol_monitoring)

## Features

### ✅ Petrol Type Monitoring

The system monitors three main fuel types in Malaysia:

1. **RON 95** – Regular petrol with a 95 octane rating

   - Most commonly used fuel type
   - Affordable pricing for the general public

2. **RON 97** – Premium petrol with a 97 octane rating

   - Higher octane for performance vehicles
   - Premium pricing with better engine performance

3. **Diesel** – Diesel fuel for vehicles
   - Commercial and heavy vehicles
   - Separate pricing structure

### ✅ (Not so) Real-time Price Display

- Current prices for all three fuel types
- Price change indicators (increase/decrease/stable)
- Visual trending arrows and color coding
- Last updated timestamp
- Pull-to-refresh functionality

### ✅ Historical Price Charts

- Interactive line charts showing price trends
- 30-day historical data visualization
- Tooltip showing exact dates and prices
- Selectable fuel types for detailed analysis
- Smooth animations and responsive design

### ✅ Web Responsive Design

- Optimized for web browsers
- Mobile-friendly responsive layout
- Touch-friendly interface
- Progressive Web App capabilities

## Technical Features

### Architecture

- **Flutter Framework** – Cross-platform development
- **Provider Pattern** – State management
- **Repository Pattern** – Data layer abstraction
- **Cached Data** – Offline capability with SharedPreferences

### Dependencies

- `fl_chart` – Professional chart visualization
- `provider` – State management solution
- `shared_preferences` – Local data caching
- `http` – API communication
- `intl` – Date formatting and localization
- `google_fonts` – Inter font family for Malaysia Government Design System compliance

### Data Management

- Local caching for offline access
- Automatic refresh capabilities
- Error handling with user feedback

## Malaysia Government Design System Implementation

This application follows the Malaysia Government Design System (MYDS) guidelines. For more information: [Visit here.](https://design.digital.gov.my/en)

## Usage

1. **View Current Prices**: The main screen displays current prices for all fuel types.
2. **Select Fuel Type**: Tap on any fuel card to view its detailed chart.
3. **View Price History**: The chart shows 30 days of price trends.
4. **Refresh Data**: Pull down or tap the refresh button to update prices.
5. **Analyze Trends**: Use interactive tooltips to see exact prices and dates.

## Running the Application

```bash
# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on mobile device
flutter run
```

## Data Source

Data sources are from [data.gov.my](https://data.gov.my/data-catalogue/fuelprice). Do note that the data might not be updated in real-time.

## Future Enhancements

- Fuel station locator
- Price predictions and trend analysis
- Push notifications for significant price changes
- Multi-language support (Bahasa Malaysia, English, Chinese, Tamil)
- Real-time data updates

_P.S. Contributions are welcome!_

---

> **Note:** This website is not affiliated with any Malaysia Government website. It demonstrates compliance with Malaysian government design standards while providing a functional and user-friendly petrol price monitoring system.
