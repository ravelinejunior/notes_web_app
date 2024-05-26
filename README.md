# Notes Web App

This is a Flutter-based notes application designed to demonstrate the use of provider state management, API integration, and PDF generation. The app allows users to create, edit, delete, and view notes with tags. It also includes functionality for sorting, searching, and printing notes.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [API Setup](#api-setup)
- [Folder Structure](#folder-structure)
- [Dependencies](#dependencies)

## Features

- Create, edit, delete, and view notes
- Add tags to notes
- Sort notes by title, created date, and version
- Search notes by title or content
- Generate and print notes as PDFs
- Interactive splash screen and animations for empty states

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (>= 3.3.4)
- [Node.js](https://nodejs.org/) (if using a Node.js server for the API)
- [Dart SDK](https://dart.dev/get-dart)

### Installation

1. **Clone the repository:**

   ```sh
   git clone https://github.com/ravelinejunior/notes_web_app
   cd notes_web_app
   ```

2. **Install dependencies:**

   ```sh
   flutter pub get
   ```

3. **Set up the Node.js server:**

   Make sure to set up and run your Node.js server as detailed in the [API Setup](#api-setup) section.

## Usage

To run the application, use the following command:

```sh
flutter run
```

This command will launch the app on your connected device or emulator.

## API Setup

The app relies on an API for managing notes. Ensure you have a Node.js server set up and running before using the app. Follow these steps:

1. **Navigate to the server directory:**

   ```sh
   cd notes_backend
   ```

2. **Start the server:**

   ```sh
   node server_index.js
   ```

   Make sure the server is running and accessible at the specified URL in your `NotesApiService`.

## Folder Structure

The project follows a standard Flutter project structure. Here are the main directories and files:

- `lib/`: Contains the main source code
  - `src/`: Main application code
    - `data/`: Data layer including API services
    - `domain/`: Domain layer including models and providers
    - `screen/`: UI screens
    - `utils/`: Utility classes and functions
- `assets/`: Contains static assets like animations

## Dependencies

The project uses several dependencies, including:

- `provider`: State management
- `http`: HTTP requests
- `mockito`: Testing utilities
- `pdf`: PDF generation
- `printing`: Printing utilities
- `lottie`: Animations
