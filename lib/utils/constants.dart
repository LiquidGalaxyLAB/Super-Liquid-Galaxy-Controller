import 'dart:math';

import '../generated/assets.dart';
class Constants {
  static double appBarHeight = 80;
  static int zoomInDuration = 15;
  static double tabBarWidthDivider = 5;
  static double splashAspectRatio = 467/ 816;
  static double lgZoomScale = 130000000.0;
  static double appZoomScale = 11;
  static double tourZoomScale = 16;
  static double orbitZoomScale = 13;
  static double defaultZoomScale = 2;
  static double dashboardUIRoundness = 20;
  static double dashboardUISpacing = 10;
  static double dashboardUIHeightFactor = 0.65;
  static Duration animationDuration = const Duration(milliseconds: 375);
  static double animationDurationDouble = 375;
  static Duration screenshotDelay = const Duration(milliseconds: 1000);
  static double animationDistance = 50;
  static double orbitRange = 40000;
  static double tabBarTextSize = 17;
  static double appBarTextSize = 18;
  static double homePageTextSize = 17;
  static double dashboardTextSize = 16;
  static double tourTextSize = 17;
  static double geoQuestTime = 90;
  static String logosUrl = "https://raw.githubusercontent.com/AritraBiswas9788/Public-Assets/main/slgc_logos.png";
  static double dashboardChartTextSize = 17;
  static List<String> tourismCategories = [
    "city_gate",
    "archaeological_site",
    "sights",
    "attraction",
    "temple",
    "memorial",
    "place_of_worship",
    "artwork",
    "viewpoint",
    "monument",
    "castle",
    "ruines",
    "tomb",
    "shrine",
    "wayside_cross",
    "chapel",
    "fort",
    "tower",
    "locomotive",
    "battlefield",
    "boundary_stone",
    "default"
  ];
  static List<String> assetPaths = [
    Assets.placeIconsGate,
    Assets.placeIconsArchaeology,
    Assets.placeIconsSights,
    Assets.placeIconsSights,
    Assets.placeIconsTemple,
    Assets.placeIconsObelisk,
    Assets.placeIconsTemple,
    Assets.placeIconsSights,
    Assets.placeIconsObelisk,
    Assets.placeIconsCastle,
    Assets.placeIconsArchaeology,
    Assets.placeIconsTombstone,
    Assets.placeIconsShrine,
    Assets.placeIconsTombstone,
    Assets.placeIconsChapel,
    Assets.placeIconsCastle,
    Assets.placeIconsObelisk,
    Assets.placeIconsObelisk,
    Assets.placeIconsObelisk,
    Assets.placeIconsStrategy,
    Assets.placeIconsObelisk,
    Assets.placeIconsObelisk,
  ];
  static List<String> driveLinks = [
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZ-kdMhCaY_ysFwvrQZ2wFi59GGO1sG1uXgKfKqYE51gJuso55NfN1JO-YJEOLluR2Bc39c4bZZJQ5Rl_EPqA1R55o4sPaxJas=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpiham1Y8vwGy__aSh5Agilq7jH9nG5Pkt-4OyEwHCIOVtrwAOCy0Gtl_lnaoRq4UrHEHipBgSuyAlGBGNqXqThUDwBq-wfYbPQmk=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihYZVq3sB-pYElSP5HD8x3nEvpBc7sYp6hI3cgTJujMwjCky3XG6KsegRKX1qGsv2aEn_y3mhkADON9iuV5nSQl58jeb3Fu6xyo=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihYZVq3sB-pYElSP5HD8x3nEvpBc7sYp6hI3cgTJujMwjCky3XG6KsegRKX1qGsv2aEn_y3mhkADON9iuV5nSQl58jeb3Fu6xyo=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZj0UuY4B-R8-8cE-QNo-2igGsXTBVPCAcCihDGiM758_44AwD_MPy2zwWNqGRFf5fQH7W4KsL4laKjeRpX43ztqNOwJpt1iPk=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZj0UuY4B-R8-8cE-QNo-2igGsXTBVPCAcCihDGiM758_44AwD_MPy2zwWNqGRFf5fQH7W4KsL4laKjeRpX43ztqNOwJpt1iPk=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihYZVq3sB-pYElSP5HD8x3nEvpBc7sYp6hI3cgTJujMwjCky3XG6KsegRKX1qGsv2aEn_y3mhkADON9iuV5nSQl58jeb3Fu6xyo=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihbFpUtfXr04utyedHC-Tz2s9RY6ULSo2tjUlwABBHhQb7EZkNLK0QcYnXXZLYS75Ziy876_x9hvuUYiT53Xe1p5GtSx0v7qfQ=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpiham1Y8vwGy__aSh5Agilq7jH9nG5Pkt-4OyEwHCIOVtrwAOCy0Gtl_lnaoRq4UrHEHipBgSuyAlGBGNqXqThUDwBq-wfYbPQmk=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihaNNyPPJDxXMGDcJ9C9n_JQUvIsVcafdZ8aNjX1wl5hH2sJIkiKbfNVPxyNaRfuGHXR_nkNdP6dyXFSPt-_RGYiCoo_UZOzbjY=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihaSfSe3jzooiRbbZNsFu1TRqoJF7PcRMCYrtxl8nsCpnSQ9KQYXv_sXTlSqNZwiQLbiVKBSvbmYClyMWNq3615sE3VSUC6HOA=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihaNNyPPJDxXMGDcJ9C9n_JQUvIsVcafdZ8aNjX1wl5hH2sJIkiKbfNVPxyNaRfuGHXR_nkNdP6dyXFSPt-_RGYiCoo_UZOzbjY=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpiha5-63-c-xRurvPgI1_7dV-MWQZtavqsBrmsgSCdNfAPfAUW4VbZFOzlWq5Cyhb03f6gJL_TPEofyEo9v5_V_6OTgLHmaaWLLQ=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihbFpUtfXr04utyedHC-Tz2s9RY6ULSo2tjUlwABBHhQb7EZkNLK0QcYnXXZLYS75Ziy876_x9hvuUYiT53Xe1p5GtSx0v7qfQ=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihYSerDcmGEApOlb9pFrQkcV6mYsVsVKCcpQ4RjMLA7Zv7AlyW7KAEfFl0cbS0-h2A7srMw9RYNumz0rKMm9isP93dFdmzAo8Lw=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560",
    "https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560",
  ];

  static String testKml = '''<?xml version="1.0" encoding="UTF-8"?> <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom"><Document> <name>About Data</name> <Style id="about_style">   <BalloonStyle>     <textColor>ff000000</textColor>     <text>        <![CDATA[<div style="text-align: center; font-size: 20px; font-weight: bold; vertical-align: middle;">Imambara</div>]]><![CDATA[        <html>          <body>            <table width="600" border="0" cellspacing="0" cellpadding="5" style="font-size: 14px; margin: auto; text-align: center;" border=1 frame=void rules=rows>              <tr>                <td align="center">                  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/%E0%A6%B9%E0%A7%8B%E0%A6%B8%E0%A7%87%E0%A6%A8%E0%A7%80_%E0%A6%A6%E0%A6%BE%E0%A6%B2%E0%A6%BE%E0%A6%A8_%E0%A6%A2%E0%A6%BE%E0%A6%95%E0%A6%BE_10.jpg/2048px-%E0%A6%B9%E0%A7%8B%E0%A6%B8%E0%A7%87%E0%A6%A8%E0%A7%80_%E0%A6%A6%E0%A6%BE%E0%A6%B2%E0%A6%BE%E0%A6%A8_%E0%A6%A2%E0%A6%BE%E0%A6%95%E0%A6%BE_10.jpg" alt="main picture" height="400" width="600" style="margin-bottom: 10px;" />                </td>              </tr>              <tr>                <td>                  <p><b>Imambara</b></p>                  <p>K N ROAD, Murshidabad - 742149, West Bengal, India</p>                  <p>A husayniyya is a congregation hall for Twelver Shia Muslim commemoration ceremonies, especially those associated with the Mourning of Muharram. Husayniyya is a multipurpose hall for the mourning of  Muharram and other commemoration rituals of Shia that gets its name from Husayn ibn Ali, the grandson of Muhammad.== Terminology ==A husayniyya is different from a mosque. The name comes from Husayn ibn Ali, the third of the Twelve Imams and the grandson of the Islamic prophet Muhammad. Husayn was martyred at the Battle of Karbala on 10 October 680 CE during the reign of Ubayd Allah ibn Ziyad. The Shia commemorate his martyrdom every year on Ashura, the 10th day of Muharram. There are also other ceremonies which are held during the year in husayniyyas, including religious commemorations unrelated to Ashura. and may not necessarily hold jumu'ah (Friday congregational prayer).In South Asia, a husayniyya can also be referred to as an imambara, imambargah, or ashurkhana....</p>                </td>              </tr>            </table>            <h3 style="margin-top: 20px; text-align: center;">Nearby POIs</h3>            <table width="600" border="0" cellspacing="0" cellpadding="5" style="font-size: 14px; margin: auto; text-align: center;" border=1 frame=void rules=rows>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihYZVq3sB-pYElSP5HD8x3nEvpBc7sYp6hI3cgTJujMwjCky3XG6KsegRKX1qGsv2aEn_y3mhkADON9iuV5nSQl58jeb3Fu6xyo=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>Hazar Duari Premises</b></p>                  <p>K N ROAD, Murshidabad - 742149, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihYZVq3sB-pYElSP5HD8x3nEvpBc7sYp6hI3cgTJujMwjCky3XG6KsegRKX1qGsv2aEn_y3mhkADON9iuV5nSQl58jeb3Fu6xyo=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>Imambara</b></p>                  <p>K N ROAD, Murshidabad - 742149, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihbFpUtfXr04utyedHC-Tz2s9RY6ULSo2tjUlwABBHhQb7EZkNLK0QcYnXXZLYS75Ziy876_x9hvuUYiT53Xe1p5GtSx0v7qfQ=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>K N ROAD</b></p>                  <p>Murshidabad - 742149, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihYZVq3sB-pYElSP5HD8x3nEvpBc7sYp6hI3cgTJujMwjCky3XG6KsegRKX1qGsv2aEn_y3mhkADON9iuV5nSQl58jeb3Fu6xyo=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>Hazar Duari</b></p>                  <p>K N ROAD, Murshidabad - 742149, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihYZVq3sB-pYElSP5HD8x3nEvpBc7sYp6hI3cgTJujMwjCky3XG6KsegRKX1qGsv2aEn_y3mhkADON9iuV5nSQl58jeb3Fu6xyo=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>Jain Family Merchant House 1850’s</b></p>                  <p>NH312, Jiaganj, Murshidabad - 742149, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>MOTIJHEEL ECO PARK</b></p>                  <p>Murshidabad - 742149, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>Ashis Sarkar Shop</b></p>                  <p>NH312, Jiaganj, Murshidabad - 742149, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>Berhampore - 742101</b></p>                  <p>West Bengal, India</p>                </td>              </tr>            </table>          </body>        </html>      ]]>      <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>      <screenXY x="1" y="1" xunits="fraction" yunits="fraction"/>      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>      <size x="0" y="0" xunits="fraction" yunits="fraction"/>     </text>     <bgColor>ffffffff</bgColor>   </BalloonStyle> </Style> <Placemark id="ab">    <name> POI DETAILS </name>   <description>   </description>   <LookAt>     <longitude>88.2686455</longitude>     <latitude>24.1883567</latitude>     <heading>0.0</heading>     <tilt>45.0</tilt>     <range>4062500.0</range>   </LookAt>   <styleUrl>#about_style</styleUrl>   <gx:balloonVisibility>1</gx:balloonVisibility>   <Point>     <coordinates>88.2686455,24.1883567,0</coordinates>   </Point> </Placemark></Document></kml>''';
  static String testKml1 = '''<?xml version="1.0" encoding="UTF-8"?> <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom"><Document> <name>About Data</name> <Style id="about_style">   <BalloonStyle>     <textColor>ff000000</textColor>     <text>        <![CDATA[<div style="text-align: center; font-size: 20px; font-weight: bold; vertical-align: middle;">Karnasuvarna</div>]]><![CDATA[        <html>          <body>            <table width="600" border="0" cellspacing="0" cellpadding="5" style="font-size: 14px; margin: auto; text-align: center;" border=1 frame=void rules=rows>              <tr>                <td align="center">                  <img src="https://upload.wikimedia.org/wikipedia/commons/d/d6/Karnasubarna_debaditya_chatterjee.jpg" alt="main picture" height="400" width="600" style="margin-bottom: 10px;" />                </td>              </tr>              <tr>                <td>                  <p><b>Karnasuvarna</b></p>                  <p>Berhampore - 742101, West Bengal, India</p>                  <p>Karnasuvarna or Karnasubarna was an ancient city, located in the present day Berhampore CD block in the Berhampore subdivision of Murshidabad district, West Bengal, India. It was the capital of Gauda Kingdom.== Geography ===== Area overview ===The area shown in the map alongside, covering Berhampore and Kandi subdivisions, is spread across both the natural physiographic regions of the district, Rarh and Bagri. The headquarters of Murshidabad district, Berhampore, is in this area. The ruins of Karnasubarna, the capital of Shashanka, the first important king of ancient Bengal who ruled in the 7th century, is located 9.6 kilometres (6.0 mi) south-west of Berhampore. The entire area is overwhelmingly rural with over 80% of the population living in the rural areas.Note: The map alongside presents some of the notable locations in the subdivisions. All places marked in the map are linked in the larger full screen map.== History ==Karnasuvarna (meaning 'made beautiful by Karna' or ...</p>                </td>              </tr>            </table>            <h3 style="margin-top: 20px; text-align: center;">Nearby POIs</h3>            <table width="600" border="0" cellspacing="0" cellpadding="5" style="font-size: 14px; margin: auto; text-align: center;" border=1 frame=void rules=rows>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpiham1Y8vwGy__aSh5Agilq7jH9nG5Pkt-4OyEwHCIOVtrwAOCy0Gtl_lnaoRq4UrHEHipBgSuyAlGBGNqXqThUDwBq-wfYbPQmk=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>Karnasuvarna</b></p>                  <p>Berhampore - 742101, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>NEW KUMAR HOSTEL</b></p>                  <p>SINHA PARA ROAD, Berhampore - 742101, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>SINHA PARA ROAD</b></p>                  <p>Berhampore - 742101, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>MAIN HOSTEL</b></p>                  <p>SINHA PARA ROAD, Berhampore - 742101, West Bengal, India</p>                </td>              </tr>              <tr>                <td colspan="2" align="center">                  <img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihZl0DNwud6VrTDNqdXSq3PwXjLgYYOOxwjiwyFT60Q_mHGAzmB9Ewu1DhRJp7bwPTrWED4d5mfUz5TMwYGKcTim82ZV1cTRROg=s2560" alt="picture" height="100" style="float: left; margin-right: 10px;" />                  <p><b>Nabarun Samity Park</b></p>                  <p>Berhampore - 742101, West Bengal, India</p>                </td>              </tr>            </table>          </body>        </html>      ]]>      <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>      <screenXY x="1" y="1" xunits="fraction" yunits="fraction"/>      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>      <size x="0" y="0" xunits="fraction" yunits="fraction"/>     </text>     <bgColor>ffffffff</bgColor>   </BalloonStyle> </Style> <Placemark id="ab">    <name> POI DETAILS </name>   <description>   </description>   <LookAt>     <longitude>88.1909089</longitude>     <latitude>24.0302684</latitude>     <heading>0.0</heading>     <tilt>45.0</tilt>     <range>4062500.0</range>   </LookAt>   <styleUrl>#about_style</styleUrl>   <gx:balloonVisibility>1</gx:balloonVisibility>   <Point>     <coordinates>88.1909089,24.0302684,0</coordinates>   </Point> </Placemark></Document></kml>''';

}
extension ZoomLG on num {
  double get zoomLG =>
      Constants.lgZoomScale / pow(2, this); // Formula to match zoom of GMap with LG
}

extension RigCalculator on num {
  int get rightMostRig => (this ~/ 2 +1);
  int get leftMostRig => (this ~/ 2 +2);
}

