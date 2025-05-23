# Proposed Feature Ideas

## 1. Detailed Hourly Forecast

**Current State:**
The `WeatherDetailVC` includes a `UICollectionView` intended for displaying an hourly forecast. However, it currently appears to be populated with placeholder or repeated data derived from the main daily forecast, rather than actual hour-by-hour weather conditions. The `HourlyCollectionViewCell` is configured with the general `Forecast` object.

**Proposed Enhancement:**
- Modify the `NetworkManager` to fetch detailed hourly forecast data from OpenWeatherMap. The API endpoint for 5-day/3-hour forecast (`/data/2.5/forecast`) already provides hourly data points.
- Create a new Swift `struct` (e.g., `HourlyForecast`) to model the relevant data for each hour (e.g., time, temperature, weather icon/description).
- Update `WeatherDetailVC` to process this hourly data. It might involve filtering the 3-hour interval data to present a more user-friendly hourly view for the selected day.
- Update `HourlyCollectionViewCell` to accept and display data from the new `HourlyForecast` model.
- Ensure the `WeatherDetailVC` correctly passes the appropriate hourly data to the collection view, likely focusing on the next 12-24 hours from the current time or for a selected day from the 5-day forecast.

**Benefits:**
This will provide users with more granular and useful short-term weather information, enhancing the app's utility for daily planning.

## 2. Saved Locations

**Current State:**
The application currently fetches weather based on the user's current GPS location or a searched city. There is no functionality to save and quickly access weather for multiple frequently checked locations.

**Proposed Enhancement:**
- **Storage:** Implement a mechanism to store a list of saved locations. `UserDefaults` could be suitable for simplicity, or Core Data/Realm for a more robust solution if more complex data or querying is anticipated. Each saved location would likely store its name (e.g., "Home", "Work"), latitude, and longitude.
- **UI for Managing Locations:**
    - Add a new screen or section (e.g., "Manage Locations" or accessible via a button on `HomeScreenVC`) where users can add, delete, and reorder their saved locations.
    - Adding a location could reuse the existing city search functionality. Upon selecting a city, an "Add to Saved" button could be presented.
- **Displaying Saved Locations:**
    - Modify `HomeScreenVC` to display weather for saved locations. This could be done in a few ways:
        - Allow the user to select a default saved location to show on launch.
        - Display a list/carousel of saved locations on the `HomeScreenVC`, each showing a summary of its current weather. Tapping one would update the main view or navigate to its `WeatherDetailVC`.
        - If the current location is also a saved location, indicate this.
- **Data Fetching:** The app would need to fetch weather data for all saved locations, possibly in the background or when the app is launched, to keep the `HomeScreenVC` summaries up-to-date. Consider API call limits and data refresh strategies.

**Benefits:**
Users can quickly check the weather for multiple places of interest without needing to search for them each time, significantly improving convenience and personalization.

## 3. Weather Alerts

**Current State:**
The app displays current weather conditions and forecasts but does not provide proactive alerts for significant or hazardous weather conditions.

**Proposed Enhancement:**
- **API Integration:** Investigate if the OpenWeatherMap API (or an alternative/supplementary weather API) provides weather alert data. This data typically includes information on the type of alert (e.g., storm warning, heavy rainfall, high winds, fog), severity, issuing authority, and affected areas. The One Call API from OpenWeatherMap often includes an `alerts` section.
- **Data Modeling:** Create a new Swift `struct` (e.g., `WeatherAlert`) to model the alert data received from the API.
- **Fetching Alerts:** Modify `NetworkManager` to fetch alert data along with regular weather forecasts for the user's current location and any saved locations.
- **Displaying Alerts:**
    - In `WeatherDetailVC` and possibly on `HomeScreenVC` (for the primary/selected location), display a prominent indicator if active alerts are present. This could be an icon, a banner, or a dedicated section.
    - Tapping the alert indicator could show the details of the alert(s), including the description and duration.
- **Push Notifications (Optional - Advanced):**
    - For a more proactive approach, implement push notifications to inform users of critical weather alerts for their saved locations even when the app is not open. This would require setting up a backend server to monitor for alerts and send push notifications via Apple Push Notification service (APNs).
    - Allow users to customize which types of alerts they want to receive notifications for.

**Benefits:**
Increases user safety and preparedness by providing timely warnings about potentially hazardous weather conditions. Makes the app a more critical tool for users concerned about weather impacts.
