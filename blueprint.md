# Time Tracker App Blueprint

## Overview

This document outlines the development plan for a Flutter application designed to help users calculate their total work hours by a fixed leave time and compare it to an 8-hour workday.

## Features

*   **Time Input:** Users can input their in-time for the day and the effective work time they have already completed.
*   **Total Work Time Calculation:** The app calculates the total hours a user will have worked if they leave the office at 6:30 PM.
*   **Comparison to 8 Hours:** The app shows how much extra time the user has worked beyond 8 hours, or how much time is remaining to complete 8 hours.
*   **Fixed Departure Time:** The calculation is based on a fixed office departure time of 6:30 PM.

## Development Plan

1.  **Project Setup:**
    *   Create a new Flutter project.
    *   Set up the basic project structure.

2.  **UI Development (`lib/main.dart`):**
    *   Create a user-friendly interface with the following components:
        *   An `AppBar` with the title "Work Hour Calculator".
        *   A `TimePicker` for selecting the day's in-time.
        *   `TextFields` for entering previously completed effective hours and minutes.
        *   An `ElevatedButton` to trigger the calculation.
        *   `Text` widgets to display the total calculated work time and the difference from an 8-hour workday.

3.  **Logic Implementation:**
    *   Create a stateful widget to manage the input values and the calculated results.
    *   Implement the function to calculate the total work time based on:
        *   Day's in-time.
        *   Previously completed effective time.
        *   Fixed leave time of 6:30 PM.
    *   Calculate and display the surplus or deficit compared to 8 hours.

4.  **Styling and Theming:**
    *   Apply a clean and modern theme to the app using `google_fonts`.
    *   Use Material Design components and a card-based layout for a consistent and organized look and feel.

5.  **Testing:**
    *   Add unit and widget tests to verify the accuracy of the calculation logic and the UI behavior.
