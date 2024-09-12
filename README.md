# 491B-AI Student Assistant App (ASAAPP)

## Overview
The **AI Student Assistant App (ASAAPP)** is an AI-driven platform designed to assist students in managing their academic workload efficiently. By leveraging AI technologies, ASAAPP helps students track assignments, receive study recommendations, and manage their time effectively. ASAAPP is built using **Flutter** for cross-platform mobile app development, integrating various AI-based features to provide students with a personalized assistant experience.

---

## Features

- **Task Management**: Create, edit, and track tasks and assignments with ease.
- **Study Recommendations**: Receive AI-driven study plans and resource suggestions based on your academic calendar.
- **Reminders & Notifications**: Stay on top of deadlines with automated reminders.
- **Intelligent Search**: Use natural language queries to find information within the app.
- **Calendar Integration**: View your academic schedule and important dates in an interactive calendar.
- **Seamless Syncing**: Synchronize tasks and events with Firebase for real-time updates across devices.
- **AI Support**: Get recommendations and reminders tailored to your needs using AI algorithms.

---

## Technologies Used

- **Flutter**: Cross-platform development framework used to build the app.
- **Firebase**: Backend services for data storage and real-time synchronization.
- **OpenAI API**: AI integration for study recommendations and personalized assistant features.
- **CI/CD**: Continuous Integration and Continuous Deployment for fast and reliable updates.
- **UML/SW Design**: Used for software architecture and design principles.

---

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/oscararenas12/ASAAP.git
   cd ASAAP
   
2. Install dependencies:
    ```bash
   flutter pub get
    
3. Set up environment variables:
   - Create a .env file in the root directory and add the required API keys (e.g., OpenAI API Key, Firebase credentials).
  
4. Run the app on your emulator or device:
   ```bash
   flutter run
   
## Folder Structure
-  /lib: Contains the main app source code.
-  /components: Reusable components like widgets and utilities.
-  /screens: Screens for different features of the app.
-  /models: Data models used across the app.
-  /services: Contains the logic for integrating AI, Firebase, etc.
-  /utils: Helper functions and utilities.

## Getting Started with Firebase
1. Set up a Firebase project and enable Firestore, Authentication, and any other services you need.
2. Update the Firebase configuration in your app to match your project.
3. Ensure proper authentication methods (Google Sign-In, Email/Password) are set up within the Firebase console.

## Usage
# Task Management
-  Navigate to the "Tasks" tab to create, edit, or delete your assignments and tasks.
-  Set deadlines and receive reminders as the deadlines approach.
# AI Study Assistance
-  Based on your schedule and upcoming tasks, the assistant will suggest study times and relevant materials.
# Calendar
-  View all tasks and deadlines in the "Calendar" section, where you can manage your academic timeline visually.

License
This project is licensed under the MIT License - see the LICENSE file for details.
