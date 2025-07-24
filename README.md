# Malaysia Petrol Price Monitoring System

A Flutter web application that monitors petrol prices in Malaysia, compliant with the Malaysia Government Design System.

🌐 **Live Demo**: [https:/huajiann.github.io/my_petrol_monitoring](https://huajiann.github.io/my_petrol_monitoring)

## Features

### ✅ Malaysia Government Design System Compliance

- Uses official Malaysia government color scheme:
  - Primary Blue (#003B5C) - Main navigation and headers
  - Secondary Blue (#0066CC) - Interactive elements
  - Gold Accent (#FFD700) - Premium petrol highlights
  - Malaysia Red (#CC0000) - Price increase indicators
- Typography following government standards
- Card-based layout with proper spacing and elevation

### ✅ Petrol Type Monitoring

The system monitors three main fuel types in Malaysia:

1. **RON 95** - Regular petrol with 95 octane rating

   - Most commonly used fuel type
   - Affordable pricing for general public

2. **RON 97** - Premium petrol with 97 octane rating

   - Higher octane for performance vehicles
   - Premium pricing with better engine performance

3. **Diesel** - Diesel fuel for vehicles
   - Commercial and heavy vehicles
   - Separate pricing structure

### ✅ Real-time Price Display

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

- **Flutter Framework** - Cross-platform development
- **Provider Pattern** - State management
- **Repository Pattern** - Data layer abstraction
- **Cached Data** - Offline capability with SharedPreferences

### Dependencies

- `fl_chart` - Professional chart visualization
- `provider` - State management solution
- `shared_preferences` - Local data caching
- `http` - API communication
- `intl` - Date formatting and localization

### Data Management

- Mock data generation for demonstration
- Local caching for offline access
- Automatic refresh capabilities
- Error handling with user feedback

## Malaysia Government Design System Implementation

This application follows the Malaysia Government Design System guidelines:

1. **Color Palette**

   - Consistent use of government-approved colors
   - Proper contrast ratios for accessibility
   - Color-coded information hierarchy

2. **Typography**

   - Clear font hierarchy
   - Readable font sizes and weights
   - Proper spacing and line heights

3. **Layout**

   - Clean, card-based design
   - Proper margins and padding
   - Consistent component spacing

4. **Accessibility**

   - High contrast text and backgrounds
   - Touch-friendly interactive elements
   - Clear visual feedback for interactions

5. **User Experience**
   - Intuitive navigation
   - Loading states and error handling
   - Responsive design for all devices

## Usage

1. **View Current Prices**: The main screen displays current prices for all fuel types
2. **Select Fuel Type**: Tap on any fuel card to view its detailed chart
3. **View Price History**: The chart shows 30 days of price trends
4. **Refresh Data**: Pull down or tap the refresh button to update prices
5. **Analyze Trends**: Use interactive tooltips to see exact prices and dates

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

Currently uses mock data that simulates realistic petrol price variations. In a production environment, this would connect to official Malaysian government APIs or petroleum company data sources.

## Deployment to GitHub Pages

This project is configured for automatic deployment to GitHub Pages using GitHub Actions.

### Automatic Deployment

1. Push your code to the `main` branch
2. GitHub Actions will automatically build and deploy the app
3. Your app will be available at: `https://yourusername.github.io/my_petrol_monitoring/`

### Manual Build (Optional)

To build locally for testing:

```bash
# On Windows
.\scripts\build-gh-pages.bat

# On macOS/Linux
./scripts/build-gh-pages.sh
```

### Setup Instructions

1. **Fork/Clone this repository** to your GitHub account
2. **Enable GitHub Pages** in your repository settings:
   - Go to Settings → Pages
   - Source: Deploy from a branch
   - Branch: `gh-pages` (will be created automatically)
3. **Update the repository name** in `.github/workflows/deploy.yml` if different
4. **Push to main branch** to trigger the first deployment

### Configuration

- The app is configured to work with GitHub Pages using the base href `/my_petrol_monitoring/`
- GitHub Actions workflow is located in `.github/workflows/deploy.yml`
- Build artifacts are automatically deployed to the `gh-pages` branch

## Future Enhancements

- Real API integration with official government data
- Regional price variations
- Fuel station locator
- Price predictions and trends analysis
- Push notifications for significant price changes
- Multi-language support (Bahasa Malaysia, English, Chinese, Tamil)

---

This application demonstrates compliance with Malaysian government design standards while providing a functional and user-friendly petrol price monitoring system.
