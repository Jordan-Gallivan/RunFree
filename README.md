# RunFree
## RunFree is an all in one running application.  Finally your heart rate, distance, pace, and timer are all on one screen for FREE!

This application initializes with the current and forecast weather local to you.  Local aviation weather is used for the greatest accuracy to help you plan your run before stepping out the door.  Each forecasted line is expandable to view more information at that time with a touch of the screen.

This app syncs with Polar Heart Rate monitors via bluetooth.  Simply press the "Autoconnect" button on the "Run!" screen to get started.

On the "Run!" screen, you can customize which views you'd like to see when running.  Delete, move, or add screens to make for the best experience you can.  

## Design Decisions
### Weather
This app relies heavily on parsing of aviation weather for display to the user.  The decision to utilize aviation weather is largely based on two factors: it is free for use and it is highly accurate.  Aviation weather is published in two forms: current weather known as a [METAR](https://en.wikipedia.org/wiki/METAR) and forecasted weather known as a [TAF](https://en.wikipedia.org/wiki/Terminal_aerodrome_forecast).  These observations and forecasts are based primarily at Airports, which are often less than 30 miles from most locations, allowing for localized weather on demand.

The Weather View is broken into current and forecasted weather.  Most weather applications dont make the wind data readily available.  As a runner myself, I've found high winds can be significantly impactful to a run so it is included as a primary data feature.  The View is adaptable to the current temperature (the color of and type of thermometer icon changes based on temperatures), the weather icon represents the current preciptation or cloud cover, and a detailed description of the current weather phenomena is displayed below.  The forecast lines begin with the current hour and project out 5 hours.  5 Hours is a decent time for an average Marathon, so the forecast timeline is plentiful to avoid nasty weather cells.  Sunrise/Sunset times are displayed where applicable in the forecast.  Lastly, each forecast line is expandable to display the wind and all weather phenomena. 

### Settings
Metric and 12-hour clock formats are easily toggled in the settings view.  Additionally, if the user wishes to use heart rate zones, that can be actived and the bottoms of each zone can be inputted for use as part of the run view.

### Run View
The intent with the run view is to display the things most runners need on the go.  The order the items are displayed is customizable, and views can be removed if they're not in use/wanted.  Currently, the app only supports Polar Heart rate monitors.  This is likely to be expanded upon in future versions.  

The location of the user is updated every second and this data is used to update the elapsed distance (accounting for changes in elevation as well as horizontal distance traveled).  The pace is updated every 5 seconds.

### Licensing and use
All code pertaining to, or referencing the Polar BLE SDK is used in accordance with Polar BLE SDK copyrights and licensing.  

Copyright (c) 2023 RunFree

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
