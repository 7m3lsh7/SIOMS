# How to Test SIOMS Flutter App

Follow these steps to set up the environment and run the application.

## 1. Start the Backend Server

The Flutter app connects to the Node.js backend. You must start it first.

```bash
cd sioms-backend
npm install
npm run dev
```

The backend will run at `http://localhost:5000`.

## 2. Run the Flutter App

Open a new terminal and navigate to the `mobile_app` directory.

### Web (Chrome/Edge)
```bash
cd mobile_app
flutter run -d chrome
```

### Android (Emulator)
Make sure an Android emulator is running.
```bash
cd mobile_app
flutter run
```

### iOS (Simulator)
Make sure the iOS Simulator is running.
```bash
cd mobile_app
flutter run
```

## 3. Demo Credentials

Use the following credentials to log in:

- **Email:** `admin@school.edu.eg`
- **Password:** `admin123`

## 4. Troubleshooting Connection Errors

If you see a "DioException [connection error]", check the following:

1. **Backend Running:** Ensure `npm run dev` is still active in the backend folder.
2. **CORS:** The backend is configured to allow `localhost:3000`. If you run Flutter web on a different port (e.g., `54321`), you might need to update the `cors` origin in `sioms-backend/src/index.js` or run Chrome with security disabled.
3. **Android Emulator IP:** Android emulators use `10.0.2.2` to refer to the host machine's `localhost`. The code handles this automatically in `lib/core/config/env_config.dart`.
4. **Physical Devices:** If testing on a real phone, you must replace `localhost` with your machine's **local IP address** (e.g., `192.168.1.10`) in `env_config.dart` and ensures both devices are on the same WiFi.
