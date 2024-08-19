<p align="center">
  <img alt="Super Liquid Galaxy Controller" src="https://raw.githubusercontent.com/AritraBiswas9788/Public-Assets/main/SLGC%20logo%20with%20title%20-%202.png" height="250px">
</p>  

# Super Liquid Galaxy Controller [SLGC]
### An application made with ❤️ by
* [Aritra Biswas](https://github.com/AritraBiswas9788)
* Mentor:[Yash Raj Bharti](https://github.com/yashrajbharti)
* Organization Admin - Andreu Ibáñez
* Lleida Liquid Galaxy LAB support - Oscar Pena


<h2 align="center">Scan the QR code to Install the Application<h2>
<p align="center">
  <img alt="" src="https://raw.githubusercontent.com/AritraBiswas9788/Public-Assets/main/qr-code.png" height="350px">
</p>

## Table of Contents

- **[About Super Liquid Galaxy Controller](#about-super-liquid-galaxy-controller)**
- **[App Features](#app-features)**
- **[Running Play Store app](#running-play-store-app)**
- **[Building from source](#building-from-source)**
- **[Setting up the rig](#setting-up-the-rig)**
- **[End Credits](#end-credits)**



## About Super Liquid Galaxy Controller

* The Super Liquid Galaxy Controller is a **Google Summer of Code 2024 project with the Liquid Galaxy Organization**. Details can be viewed [Google Summer of Code Post](https://summerofcode.withgoogle.com/programs/2024/projects/RRJe0whD), [Project Proposal](https://docs.google.com/document/d/1WsJxHc1H_4tk-sQ0wDWvnNF9wgeTKJrcfZ-Bv5Ptb88/).
* Super Liquid Galaxy Controller is an app built on the Flutter framework that serves as the primary controller application to interact with the Liquid galaxy rig.
  The project combines, enhances and adds onto the various features of a controller application including POI exploration, Custom KML interactions, Tour Building, Convenient controllers etc.
* The Custom KML Builder allows for interactive presentation of Geo-Data on the Liquid Galaxy platform, a visualization cluster based on Google Earth.
  The Custom Builder, which has an interactive UX where the user can create any KML element with a simple, easy-to-use map-based editor.
* The Map Controller is an easy interaction tool for the panoramic display of Google Earth with the help of Google maps, and it allows us to control the LG and send Orbit movements and various other controls.
  It also has a voice commands feature allowing easy hassle-free controls of the LG rig.


## App Features

* **Tour Builder**: A simple tool allowing for immersive and interactive creation of tours around the globe using the Liquid Galaxy rig. The tours can also be saved and loaded easily. Comes with unique KML visualizations for various types of tours.
* **POI Exploration**: A convenient way to discover and visit countless POIs around the globe by searching based on a state level search of POIs.
* **Map Controller**: Allows easy manipulation of the Liquid Galaxy rig using a Google-maps based map-movements. It also has Voice control and address-based search features.
* **Geo-Quest**: Fun, interactive GeoGuessr-like game to learn simple interactions with a Liquid Galaxy Setup. Surprisingly addictive!
* **KML Builder**: Custom KML Builder that allows for easy creation of any type of Geo-data visualization completely IN APP. Fun to use map editor for KML data.

## Running Play Store app

#### Prerequisites:

* 10-inch Android Tablet

#### Steps:
* Download and install the app using this [Play Store link](https://play.google.com/store/apps/details?id=com.aritra.super_liquid_galaxy_controller). Alternatively, you can scan the QR code showcased at top to download and install the app.
* To connect to the Liquid Galaxy, tap on Settings icon and go to Connection Tab; then fill the details mentioned there:
<p align="center">
  <img alt="" src="https://raw.githubusercontent.com/AritraBiswas9788/Public-Assets/main/settings_lg_connection.png" width="700px">
</p>

* To unlock the full potential of the Super Liquid Galaxy Controller, we will need a free GeoApify Places API Key:
* Go to the GeoApify Projects Dashboard: [GeoApify](https://myprojects.geoapify.com/projects). Create an account if required.
* Click on **Add a new Project**. This will generate an API Key that we can use.
* Tap on Settings icon and go to API Key Tab; then fill the key in the field given there:

<p align="center">
  <img alt="" src="https://raw.githubusercontent.com/AritraBiswas9788/Public-Assets/main/settings_apikey.png" width="700px">
</p>

* Now you can enjoy the wide array of features that the Super Liquid Galaxy Controller offers!

## Building from source

#### Prerequisites:

* Android Studio, Visual Studio Code or another IDE that supports Flutter development
* Flutter SDK
* Android SDK
* Android tablet device or emulator
* Git

Documentation on how to set up Flutter SDK and its environment can be found [here](https://flutter.dev/docs/get-started/install). Make sure to have [Git](https://git-scm.com/) and [Flutter](https://flutter.dev) installed in your machine before proceeding.

#### Steps:

* Clone the repository via the following terminal command:

```bash
$ git clone https://github.com/LiquidGalaxyLAB/Super-Liquid-Galaxy-Controller.git
$ cd Super-Liquid-Galaxy-Controller
```

* After you have successfully cloned the project, set up Google maps API Key as Super Liquid Galaxy Controller uses [Google maps Android API](https://developers.google.com/maps/documentation/android-sdk/overview?hl=pt-br) as the map service. To use Google maps you required an **API KEY**. To get this key you need to:

1. Have a Google Account
2. Create a Google Cloud Project
3. Open Google Cloud Console
4. Enable Maps Android SDK
5. Generate an API KEY

With the key in hands, the next step is placing the key inside the app. Go to *android/app/main* and edit the **AndroidManifest.xml**.

Replace the **PLACE_HERE_YOUR_API_KEY** with the key you just created.

```XML
<application
        android:label="Super Liquid Galaxy Controller"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <meta-data android:name="com.google.android.geo.API_KEY"
            android:value="PLACE_HERE_YOUR_API_KEY"/>
```  

* To run the code, open a terminal and navigate to the project root directory. First you need to install the packages by running:

```bash
$ flutter pub get
```

* Now we check if our devices are connected and if all the environment is correct by the following terminal command:

```bash
$ flutter doctor
```

*  After this, we run our app by using the following command:

> ❗ Remember that you must have a tablet device connected or an android tablet emulator running in order to run the app.

```bash
$ flutter run
```

* To build the APK, use the following terminal command:

```bash
$ flutter build apk
```

> ⓘ  Once done, the APK file may be found into the `/build/app/outputs/flutter-apk/` directory, named `app-release.apk`.

* Finally setup the connection with the Liquid Galaxy in the same way as we did previously.

## Setting up the rig

* The Liquid Galaxy rig while not necessary to operate the Application; is a very essential component to access a lot of features of the Application.
* The Liquid Galaxy system is very simple to setup and extremely well-documented steps can be found here : [Documentation](https://www.liquidgalaxy.eu/2024/05/lg-wiki.html#content-wrapper).
* The Documentation tab gives unparalleled insight into the various ways one can use an LG rig.

## End-Credits

We hope you have fun using this application ❤️




