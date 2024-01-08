# RunFree

# Purpose
This application is designed to be an all-in-one running application displaying all necessary features a runner needs in a fully customizable interface.  Simply boot up the app, note the highly accurate local weather and get going with the push of a button.

# Background
Most off-the-shelf running applications still require at least one additional interface to track things like distance, time, pace, heart rate, and current weather.  This app looks to solve that by reducing the number of clicks to get going, while allowing the user to customize the interface to their liking.

This project began as an exploration of Swift, specific to iOS development, and evolved into a fully functional application that is free to use.  

# Design
This application follows the Swift and SwiftUI functional programming paradigms.  The application is broken into three primary components: Weather, Run, and Settings.  Additional groups are utilized for larger sub-components such as Heart Rate, the Persistent Storage Models, and Auxiliary Namespaces.  

## Weather
The decision to utilize aviation weather is predicated on the fact that it is highly accurate and requires simple string parsing.  At first glance, the nomenclature is not intuitive, but the formatting is rigid and decipherable with the considerable external resources available.  Aviation weather is available in two forms, [METARs](https://en.wikipedia.org/wiki/METAR) which reflect the current weather, and [TAFs](https://en.wikipedia.org/wiki/Terminal_aerodrome_forecast) which reflect the forecasted weather.  These are either observed or automated at airports, referred extensively throughout at “stations.”  

The fetching and parsing of the current and forecasted weather utilize numerous helper structs, enums, and functions, detailed below in a sequential order.  

### FetchWeather 
`FetchWeather` is an asynchronous helper class to initialize fetching METARs and TAFs as well as sunrise and sunset data.  The results of the method calls are stored in the result attribute, which reflects the status of the requested method.  
1. The initial call to `FetchWeather` calls the `reload()` function, which initializes the users current location and begins calls to web APIs for generating METARs, TAFs, and sunrise and sunset data.  
2. The sunrise/sunset data is retrieved from [sunrisesunset.org](sunrisesunset.org/api) for the current and following day for use in parsing of the TAF.  The data is stored in `SunriseSunset` objects
3. All stations within a constant value distance from the user are retrieved through [aviationweather.gov](https://aviationweather.gov/data/api/) and stored in a min-heap priority queue (detailed in the Appendix A).  The queue stores each element as an `Airport` Struct which maintains the meta-data associated with each station including: whether the station has a METAR and/or TAF, distance to the user, and the stations latitude and longitude.   
4. The stations are iterated through in increasing order until a METAR and TAF can be fetched.  This is reliant on the condition that the respective station has a METAR/TAF and that said METAR/TAF can be fetched from aviationweather.gov.  These are stored in a `METAR` and TAF struct respectively, which are detailed below.
5. Following the successful generation of  `METAR`, `TAF`, and `SunriseSunset` objects, `FetchWeather.reload()` returns a `Weather` struct within the `.result(Weather)` state of the `FetchWeather` result enum.  Should an exception be caught, `FetchWeather.reload()` sets the `.result()` state to the respective error for display to the user.

### Sunrise/Sunset
Sunrise and sunset data is not only important when making a pre-run decision, it can be used to further enhance the UI for display of weather information.  SwiftUI, through the use of SF Symbols, allows for icons highly customizable imagery reflective of the current time of day. 

The sunrise and sunset data are stored as Date objects within the `SunriseSunset` struct for easy comparison to forecast times.  

### WeatherParser
`WeatherParser` is a static enum namespace containing helper methods to aid in parsing METAR and TAF lines of data.  The external public facing function, `parseWeather(weather:metar:)` takes as arguments the an array of string data from a METAR or TAF, as well as the Boolean argument `isMetar` to indicate the parsing of a METAR line.  With the exception of temperature data, both METARs and TAFs contain some or all of the below data:
 - Prevailing winds, both direction and speed in knots
 - Sky conditions (amount of cloud coverage)
 - Weather Conditions (precipitation)
 - Temperature and Dew point (only METARs)

`parseWeather(weather:metar:)`, through the use private helper methods, parses each element into its component weather data and returns a tuple containing the data.

### METAR
`METAR` is the primary struct through which the current weather is parsed and stored for display to the user.  All component data contained within a METAR is stored as publicly accessible attributes.  METARs store temperature in degrees Celsius and wind speed in knots.  When these attributes are accessed, the Boolean value of `isMetric` determines if the temperature is returned as degrees Fahrenheit or Celsius, and wind speed as miles per hour or kilometers per hour.  

### TAF
`TAF` is the primary struct through which the forecasted weather is parsed and stored for display to the user.  TAF leverages the struct `Forecast` which contains as optionals all weather data for the respective time period.  

Each line of a TAF indicates a change in the forecasted weather.  Becoming lines indicate the weather will change to this forecasted line at some time between the indicated interval.  Temporary lines indicate the forecasted weather will reflect the following line during the indicated interval.  From lines indicate the weather will transition to, and remain at the following forecasted state at the indicated time.  Lastly, Probable lines, are akin to Temporary lines with the additional annotation of the probability of the forecasted line occurring.  

Upon initialization, the forecast window in generated and the initial array of `Forecast` structs is created, by instantiating a `Forecast` struct with the appropriate time.  Utilizing the `SunriseSunset` object, additional Forecast elements are inserted into the array at the respective times.  The TAF is then parsed via `WeatherParser` and all information is stored in the array of `Forecast structs` for display to the user.

### UI
The current and forecasted weather are displayed to the user by utilizing two primary View components: `CurrentWeatherView(metar:colorScheme:)` and `ForecastLine(forecast:colorScheme:expandedView:)`.  
`CurrentWeatherView(metar:colorScheme:)` takes as an argument the `METAR` object created by a successful `FetchWeather.reload()` call.  Numerous SF Symbols are rendered depending on the users display settings, so the additional argument of `colorScheme` indicates whether the user has selected dark mode.  

`ForecastLine(forecast:colorScheme:expandedView:)` is called within the body of a `ForEach(_:id:content:)` structure for each Forecast element within the array of Forecasts generated by TAF in a successful `FetchWeather.reload()` call.  By default, the forecasted time, prevailing weather condition, and associated image are displayed.  If the winds exceed 20 knots or there is a probability associated with the forecasted line, that information is displayed.  Each row (with the exception of sunrise and sunset rows) are selectable to display more weather information to the user, including wind information and all weather conditions.  

[Weather View English Units](/DesignDocImages/WeatherScreenEnlish.png)
Weather View (English Units)

[Weather View Metric Units ](/DesignDocImages/WeatherScreenMetric.png)
Weather View (Metric Units)

[Weather View English Expanded](/DesignDocImages/WeatherScreenExpanded.png)
Weather View with expanded forecast

## Run
The running interface is designed to be highly customizable with 5 component views: Elapsed Timer, Elapsed Distance, Current Pace, Heart Rate, and Heart Rate Zone.  The ordering of these components on the screen, the size of the displayed text, the visibility of the component title, and the color of the text are all customizable.  

### AppData
`AppData` publishes the primary state variables for use in the `RunView` as well as the navigation path.  The function `activateElapsedTimer()` is called when the user starts the run by clicking the “Run!” button on the `RunView`.  This function initializes a `Timer` which updates the elapsed timer every 100ms, the location ever 1000ms, and the pace every 5000ms.  

The elapsed timer and updates of the above attributes can be paused by calling `pauseElapsedTimer()`.  This function invalidates the `Timer` and toggles the variables `timerPaused` and `timerActive`.  This maintains the current elapsed time and distance.  

The timer and updates can be stopped by calling `deactivateElapsedTimer()`.  This also invalidates the `Timer` and zeros out the elapsed time and distance.  

`AppData` also serves as the `Location Manger` for the application to allow querying of the users current location for use in the elapsed distance and pace.

### Elapsed Timer
The elapsed timer is rendered through `ElapsedTimerView`.  This view calculates the seconds, minutes, and hour components of the elapsed time and displays them to the user via a `Text` view.  This view’s color and size are customizable.

### Elapsed Distance
The elapsed distance is rendered through `DistanceView`.  This view displays the elapsed distance to within 0.01 miles or 10 meters depending on whether the user has selected metric units.  The selected distance (miles or kilometers) are displayed next to the elapsed distance.  This view’s color and size are customizable.

### Current Pace
`AppData` calculates the current pace every five seconds as a measure of seconds / meter.  When queried from AppData through the function call `pace(metric:)`, the value is returned in seconds/mile or seconds/kilometer.  `PaceView` adjusts to minutes/mile or minutes/kilometer and displays this value to the user.  The selected min/km or min/mi are displayed next to the current pace.  This view’s color and size are customizable.

### Heart Rate
`HeartRateView` utilizes the Polar BLE SDK (Appendix B) to display the users heart rate.  A polar device can be in one of three states, `disconnected`, `connecting`, and `connected`.  `HeartRateView` displays the appropriate information for each state, and when connected the current heart rate is displayed.  If the user has not enabled Bluetooth pairing, an advisory message is displayed.  This view’s color and size are customizable.

### Zone
`ZoneView` utilizes the Polar BLE SDK as well as the user defined heart rate zones to display the current heart rate zone to the user.  This view displays a custom Progress view as well as the text indication of current heart rate.  The bounds for this custom Progress view are the bottom of zone1 to 5% above zone5.  This view’s color and sizes are not customizable.  `HeartRateZoneSettings` and its use in the Settings Model are discussed in more detail in the Persistent Storage section.

### UI
`RunView` is the primary view through which the user interacts with, and views the component running views described above.  The component views are stored as `RunComponentModels`, which are detailed in the Persistent Storage section.  The key attribute of those models for display to the user is the `isVisible` variable.  When true, this component is displayed to the user.  Additionally, the `index` attribute of the model indicates the positioning of the component relative to the other components, where index 0 is the top of the screen.  

Each component reflects a single `RunComponentView`.  The title of the view is displayed to the right with the Views primary feature displayed in the center.  The title visibility can be toggled, and the customizable features described for each component are done so in this view.  
// Run View

### Editing the View and Components
The default Edit functionality of the `List` has been overridden to allow for updating the Persistent Storage Models.  
- **Move**: users can reorder the component views via the `.onMove` modifier of the `List`.  When this modifier is selected, the indices of the moved components are updated and stored in the model.  
- **Delete**: Users can delete components from the view through the `.onDelete` modifier of the `List`. When this modifier is selected, the component views that are selected to be deleted have their respective `isVisible` attribute set to false.  These componets are then moved to the end of the array by updating their indices.  
- **Customize the Components**: Users can modify the color, size, and title visibility of the component through the `.onTapGesture` modifier of the component. Doing so sets the `selectedRunComponent` to the component that was tapped, and this component is modified via a the `RunComponentSettingsView` which is displayed as a sheet at the bottom of the screen.  
- **Add RunComponents**: Users can add components that have been deleted via a custom + button that is visible when edit mode is activated.  Doing so displays a sheet on the bottom of the screen the components that are currently “deleted.”  When the user taps on any of these components, they are added to the RunView by setting the isVisible attribute to true.

// edit active

// Customize components

// Add Run Components

## User Settings
User Settings are maintained in the `SettingsModel` within the Persistent Storage of the application.  Users can toggle the following Boolean values:
- `metric`: when true, all applicable data within the application is displayed in metric units(degrees Celsius, kilometers, min/km, kph).  When false, all applicable data with the application is displayed in English Standard Units (degrees Fahrenheit, miles, mph, min/mi).
- `twelveHourClock`: when true, times are displayed in the 12-hour format.  When false, all times are displayed in the 24-hour format.
- `useHeartRateZones`: when true, the user is required to enter non-zero integer values for their heart rate zones in increasing sequential order, where zone1 < zone2 < zone3 < zone4 < zone5.  This is validated when the user attempts to exit the settings page.
  
If the user has toggled useHeartRateZones to true, the are required to input their heart rate zone values in the provided `TextFields`.  When the user attempts to exit the settings page, thes values are validated.  Any failed validation is displayed to the user in an alert box with expounding information as to why the validation failed.  Users are given the option to correct the invalid zones, or toggle `useHeartRateZones` to false.

// Settings View

// Alert View

# Persistent Storage
All user settings and Run View customizations are stored via `RunComponentModels` and a single `SettingsModel` in the applications `modelContainer`.  This model container is accessed via model context and queries using the [SwiftData API](https://developer.apple.com/documentation/swiftdata).  

Upon App initialization, the model container is verified to be non-empty.  In the case that this is the users first use of the application, default run components are added to the model container as well as a single `SettingsModel` with defaulted false values.  Upon future application starts, the Settings context is validated to only contain a single value and additionally, should the user have shut down the application while inputting heart rate zones, the heart rate zones are validated.  Should this validation fail, the zones are zeroized and useHeartRateZones is set to false.  

## SettingsModel
All user settings accessible and modifiable in the Settings View are stored and queried from the single `SettingsModel`.  Because SwiftData does not currently support storing a single model to be queried, when accessing this model, the `modelContext` is accessed and the `SettingsModel` queried.  The resultant array is verified to have only a single value through safeguarding throughout the applications development.  The first element in the array is therefore force unwrapped each time it is used.  With the exception of JSON Parsing and situations that will be discussed in the `RunComponentModel`, this is the only force unwrapping of a value in the application.  

## RunComponenetModel
Each component view described in the Run View section above is identified by a `RunComponentModel` in the model context.  The primitive data types used for customization are intuitive however the use of enums and `Color` objects withing a Model in SwiftData is rife with issues.  As a work around, string values for the `runComponentType` and `componentColor` are used.  These strings are passed as raw values to their respective enum.  This requires force unwrapping of the return values and safeguards thorugh out the application validate that only non-error producing values are passed as arguments to these enum initializers.  

# Error Handling
# Testing

# Appendix
## A. Priority Queue
For this application, a Priority Queue object was created utilizing a min-heap data structure.  This data structure takes any Comparable type and returns the minimum element in the queue when polled.  `PriorityQueue `offers the following functions:

`add(_:)` Add an element to the priority queue.  This method returns true if the element was successfully added.  The heap property is maintained after insertion of elements

`peek()` Returns the minimum element in the queue without removing it or nil if the queue is empty. 

`poll()` Removes and returns the minimum element in the queue, or nil if the queue is empty.  The min-heap property is restored upon removal of the element.

Lastly, an iterator, `PriorityQueueIterator` is available to allow users to iterate through the queue in increasing order without modifying the original queue.  

## B. Polar BLE SDK
This application utilizes the [Polar BLE SDK](https://github.com/polarofficial/polar-ble-sdk) for all interaction with Polar Heart Rate devices.  All code within the application is used in accordance with the Polar Copyright.  


## C. Acronyms
METAR - Meteorological Terminal Aviation Routine Weather Report
TAF - Terminal Aerodrome Forecast
UI - User Interface


