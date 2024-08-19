import 'package:super_liquid_galaxy_controller/data_class/coordinate.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/data_class/place_info.dart';

import 'constants.dart';

class BalloonGenerator {
  static screenOverlayImage(String imageUrl, double factor) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document id ="logo">
         <name>SUPER LIQUID GALAXY CONTROLLER</name>
             <Folder>
                  <name>Splash Screen</name>
                  <ScreenOverlay>
                      <name>Logo</name>
                      <Icon><href>$imageUrl</href> </Icon>
                      <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
                      <screenXY x="0.025" y="0.95" xunits="fraction" yunits="fraction"/>
                      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
                      <size x="1000" y="${1000 * factor}" xunits="pixels" yunits="pixels"/>
                  </ScreenOverlay>
             </Folder>
    </Document>
</kml>''';

  static screenOverlayLogos(String imageUrl) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document id ="logo">
         <name>SUPER LIQUID GALAXY CONTROLLER</name>
             <Folder>
                  <name>Splash Screen</name>
                  <ScreenOverlay>
                      <name>Logo</name>
                      <Icon><href>$imageUrl</href> </Icon>
                      <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
                      <screenXY x="0.025" y="0.95" xunits="fraction" yunits="fraction"/>
                      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
                      <size x="0" y="0" xunits="pixels" yunits="fraction"/>
                  </ScreenOverlay>
             </Folder>
    </Document>
</kml>''';

  static blankBalloon() => '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>None</name>
 <Style id="blank">
   <BalloonStyle>
     <textColor>ffffffff</textColor>
     <text></text>
     <bgColor>ff15151a</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="bb">
   <description></description>
   <styleUrl>#blank</styleUrl>
   <gx:balloonVisibility>0</gx:balloonVisibility>
   <Point>
     <coordinates>0,0,0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';

  static listBalloonForTours(List<PlaceInfo> list,int slaveNo, MapPosition pos) {
    String html =
        "      <![CDATA[\n" +
        "        <html>\n" +
            "<h2 style=\"margin-top: 20px; text-align: center;\">Nearby POIs</h2>\n" +
        "          <body>\n" +

        "            <table width=\"400\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px;\" border=1 frame=void rules=rows>\n";
    List<PlaceInfo> nearbyPois = [];
    nearbyPois.addAll(list);
    int i =0;
    for(PlaceInfo p in nearbyPois)
    {
      i++;
      html += "              <tr>\n" +
          "                <td colspan=\"2\" align=\"center\">\n" +
          "                <img src=\"" + p.getImageLink() + "\" alt=\"picture\" height=\"100\" style=\"float: left; margin-right: 10px;\" />\n" +
          "                  <p><b>" + p.getTitle() + "</b> "+"</p>\n" +
          "                  <p>" + p.getAddress() + "</p>\n" +
          "                </td>\n" +
          "              </tr>\n";
      if(i==7) {
        break;
      }
    }


    html += "            </table>\n" +
        "          </body>\n" +
        "        </html>\n" +
        "      ]]>\n" +
        "      <overlayXY x=\"0\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <screenXY x=\"1\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <rotationXY x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <size x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" ;

    return balloon(pos ,html,"Nearby Places");

  }

  static poiBalloonForTours(PlaceInfo place, MapPosition pos) {

    String html = "<![CDATA[<div style=\"text-align: center; font-size: 20px; font-weight: bold; vertical-align: middle;\">${place.name}</div>]]>";
    html += "<![CDATA[\n" +
    "        <html>\n" +
    "          <body>\n" +
    "            <table width=\"600\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px; margin: auto; text-align: center;\" border=1 frame=void rules=rows>\n" +
    "              <tr>\n" +
    "                <td align=\"center\">\n" +
    "                  <img src=\"" + place.getImageLink() + "\" alt=\"main picture\" height=\"400\" width=\"600\" style=\"margin-bottom: 10px;\" />\n" +
    "                </td>\n" +
    "              </tr>\n" +
    "              <tr>\n" +
    "                <td>\n" +
    "                  <p><b>" + place.name + "</b></p>\n" +
    "                  <p>" + place.getAddress() + "</p>\n" +
    "                  <p>" + place.getDescription() + "</p>\n" +
    "                </td>\n" +
    "              </tr>\n" +
    "            </table>\n" +
    "            <h3 style=\"margin-top: 20px; text-align: center;\">Nearby POIs</h3>\n" +
    "            <table width=\"600\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px; margin: auto; text-align: center;\" border=1 frame=void rules=rows>\n";

    List<PlaceInfo> nearbyPois = [];
    nearbyPois.addAll(place.getPois());
    int i = 0;
    for (PlaceInfo p in nearbyPois) {
      i++;
      html += "              <tr>\n" +
          "                <td colspan=\"2\" align=\"center\">\n" +
          "                  <img src=\"" + p.getImageLink() + "\" alt=\"picture\" height=\"100\" style=\"float: left; margin-right: 10px;\" />\n" +
          "                  <p><b>" + p.getTitle() + "</b></p>\n" +
          "                  <p>" + p.getAddress() + "</p>\n" +
          "                </td>\n" +
          "              </tr>\n";
      if (i == 5) break;
    }

    html += "            </table>\n" +
        "          </body>\n" +
        "        </html>\n" +
        "      ]]>" +
        "      <overlayXY x=\"0\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <screenXY x=\"1\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <rotationXY x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <size x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n";
    return balloon(pos, html, "POI DETAILS");
  }


  static listBalloon(List<PlaceInfo> list, int slaveNo) {
    String s =
        '''<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
        "<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:kml=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n" +
        "  <Document>\n" +
        "    <name>historic.kml</name>\n" +
        "    <ScreenOverlay>\n" +
        "      <name><![CDATA[<div style=\"text-align: center; font-size: 20px; font-weight: bold; vertical-align: middle;\">Nearby Places</div>]]></name>\n" +
        "      <description><![CDATA[\n" +
        "        <html>\n" +
        "          <body>\n" +
        "            <table width=\"400\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px;\" border=1 frame=void rules=rows>\n''';

    List<PlaceInfo> nearbyPois = [];
    nearbyPois.addAll(list);
    int i =0;
    for(PlaceInfo p in nearbyPois)
      {
        i++;
        s += "              <tr>\n" +
            "                <td colspan=\"2\" align=\"center\">\n" +
            "                <img src=\"" + p.getImageLink() + "\" alt=\"picture\" height=\"100\" style=\"float: left; margin-right: 10px;\" />\n" +
            "                  <p><b>" + p.getTitle() + "</b> "+"</p>\n" +
            "                  <p>" + p.getAddress() + "</p>\n" +
            "                </td>\n" +
            "              </tr>\n";
        if(i==10)
          break;
      }


    s += "            </table>\n" +
        "          </body>\n" +
        "        </html>\n" +
        "      ]]></description>\n" +
        "      <overlayXY x=\"0\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <screenXY x=\"1\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <rotationXY x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <size x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <gx:balloonVisibility>1</gx:balloonVisibility>\n" +
        "    </ScreenOverlay>\n" +
        "  </Document>\n" +
        "</kml>\n' > /var/www/html/kml/" + "slave_${slaveNo}" + ".kml";
    return s;
  }

  static placeBalloon(PlaceInfo place, int slaveNo) {
    String s = "chmod 777 /var/www/html/kml/" + "slave_${slaveNo}" + ".kml; echo '" +
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
        "<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:kml=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n" +
        "  <Document>\n" +
        "    <name>historic.kml</name>\n" +
        "    <ScreenOverlay>\n" +
        "      <name><![CDATA[<div style=\"text-align: center; font-size: 20px; font-weight: bold; vertical-align: middle;\">${place.name}</div>]]></name>\n" +
        "      <description><![CDATA[\n" +
        "        <html>\n" +
        "          <body>\n" +
        "            <table width=\"400\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px;\" border=1 frame=void rules=rows>\n";
    List<PlaceInfo> nearbyPois = [];
    nearbyPois.addAll(place.getPois());
    int i =0;
    for(PlaceInfo p in nearbyPois)
    {
      i++;
      s += "              <tr>\n" +
          "                <td colspan=\"2\" align=\"center\">\n" +
          "                <img src=\"" + p.getImageLink() + "\" alt=\"picture\" height=\"100\" style=\"float: left; margin-right: 10px;\" />\n" +
          "                  <p><b>" + p.getTitle() + "</b> "+"</p>\n" +
          "                  <p>" + p.getAddress() + "</p>\n" +
          "                </td>\n" +
          "              </tr>\n";
      if(i==10)
        break;
    }


    s += "            </table>\n" +
        "          </body>\n" +
        "        </html>\n" +
        "      ]]></description>\n" +
        "      <overlayXY x=\"0\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <screenXY x=\"1\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <rotationXY x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <size x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <gx:balloonVisibility>1</gx:balloonVisibility>\n" +
        "    </ScreenOverlay>\n" +
        "  </Document>\n" +
        "</kml>\n' > /var/www/html/kml/" + "slave_${slaveNo}" + ".kml";
    return s;
  }

  static String generateKML(PlaceInfo place,int slaveNo) {
    String s = "chmod 777 /var/www/html/kml/slave_${slaveNo}.kml; echo '" +
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
        "<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:kml=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n" +
        "  <Document>\n" +
        "    <name>historic.kml</name>\n" +
        "    <ScreenOverlay>\n" +
        "      <name><![CDATA[<div style=\"text-align: center; font-size: 20px; font-weight: bold; vertical-align: middle;\">${place.name}</div>]]></name>\n" +
        "      <description><![CDATA[\n" +
        "        <html>\n" +
        "          <body>\n" +
        "            <table width=\"400\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px;\" border=1 frame=void rules=rows>\n" +
        "              <tr>\n" +
        "                <td colspan=\"2\" align=\"center\">\n" +
        "                <img src=\"" + place.getImageLink() + "\" alt=\"main picture\" height=\"100\" style=\"float: left; margin-right: 10px;\" />\n" +
        "                  <p><b>" + place.name + "</b> "+"</p>\n" +
        "                  <p>" + place.getAddress() + "</p>\n" +
        "                  <p>" + place.getDescription() + "</p>\n" +
        "                </td>\n" +
        "              </tr>\n";

    List<PlaceInfo> nearbyPois = [];
    nearbyPois.addAll(place.getPois());
    int i = 0;
    for (PlaceInfo p in nearbyPois) {
      i++;
      s += "              <tr>\n" +
          "                <td colspan=\"2\" align=\"center\">\n" +
          "                <img src=\"" + p.getImageLink() + "\" alt=\"picture\" height=\"100\" style=\"float: left; margin-right: 10px;\" />\n" +
          "                  <p><b>" + p.getTitle() + "</b> "+"</p>\n" +
          "                  <p>" + p.getAddress() + "</p>\n" +
          "                  <p>" + p.getDescription() + "</p>\n" +  // Add description for each nearby POI
          "                </td>\n" +
          "              </tr>\n";
      if (i == 10) break;
    }

    s += "            </table>\n" +
        "          </body>\n" +
        "        </html>\n" +
        "      ]]></description>\n" +
        "      <overlayXY x=\"0\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <screenXY x=\"1\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <rotationXY x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <size x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <gx:balloonVisibility>1</gx:balloonVisibility>\n" +
        "    </ScreenOverlay>\n" +
        "  </Document>\n" +
        "</kml>\n";
    return s;
  }

  static String generateKML1(PlaceInfo place,int slaveNo) {
    String s = "chmod 777 /var/www/html/kml/slave_${slaveNo}.kml; echo '" +
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
        "<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:kml=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n" +
        "  <Document>\n" +
        "    <name>historic.kml</name>\n" +
        "    <ScreenOverlay>\n" +
        "      <name><![CDATA[<div style=\"text-align: center; font-size: 20px; font-weight: bold; vertical-align: middle;\">${place.name}</div>]]></name>\n" +
        "      <description><![CDATA[\n" +
        "        <html>\n" +
        "          <body>\n" +
        "            <table width=\"400\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px;\" border=1 frame=void rules=rows>\n" +
        "              <tr>\n" +
        "                <td align=\"center\">\n" +
        "                  <img src=\"" + place.getImageLink() + "\" alt=\"main picture\" height=\"400\" style=\"margin-bottom: 10px;\" />\n" +
        "                </td>\n" +
        "              </tr>\n" +
        "              <tr>\n" +
        "                <td>\n" +
        "                  <p><b>" + place.name + "</b></p>\n" +
        "                  <p>" + place.getAddress() + "</p>\n" +
        "                  <p>" + place.getDescription() + "</p>\n" +
        "                </td>\n" +
        "              </tr>\n" +
        "            </table>\n" +
        "            <h3 style=\"margin-top: 20px;\">Nearby POIs</h3>\n" +
        "            <table width=\"400\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px;\" border=1 frame=void rules=rows>\n";

    List<PlaceInfo> nearbyPois = [];
    nearbyPois.addAll(place.getPois());
    int i = 0;
    for (PlaceInfo p in nearbyPois) {
      i++;
      s += "              <tr>\n" +
          "                <td colspan=\"2\" align=\"center\">\n" +
          "                  <img src=\"" + p.getImageLink() + "\" alt=\"picture\" height=\"100\" style=\"float: left; margin-right: 10px;\" />\n" +
          "                  <p><b>" + p.getTitle() + "</b></p>\n" +
          "                  <p>" + p.getAddress() + "</p>\n" +
          "                  <p>" + p.getDescription() + "</p>\n" +
          "                </td>\n" +
          "              </tr>\n";
      if (i == 10) break;
    }

    s += "            </table>\n" +
        "          </body>\n" +
        "        </html>\n" +
        "      ]]></description>\n" +
        "      <overlayXY x=\"0\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <screenXY x=\"1\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <rotationXY x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <size x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <gx:balloonVisibility>1</gx:balloonVisibility>\n" +
        "    </ScreenOverlay>\n" +
        "  </Document>\n" +
        "</kml>\n' > /var/www/html/kml/slave_${slaveNo}.kml";
    return s;
  }

  static String generateKML2(PlaceInfo place, int slaveNo) {
    String s = "chmod 777 /var/www/html/kml/slave_${slaveNo}.kml; echo '" +
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
        "<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:kml=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">\n" +
        "  <Document>\n" +
        "    <name>historic.kml</name>\n" +
        "    <ScreenOverlay>\n" +
        "      <name><![CDATA[<div style=\"text-align: center; font-size: 20px; font-weight: bold; vertical-align: middle;\">${place.name}</div>]]></name>\n" +
        "      <description><![CDATA[\n" +
        "        <html>\n" +
        "          <body>\n" +
        "            <table width=\"400\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px; margin: auto; text-align: center;\" border=1 frame=void rules=rows>\n" +
        "              <tr>\n" +
        "                <td align=\"center\">\n" +
        "                  <img src=\"" + place.getImageLink() + "\" alt=\"main picture\" height=\"400\" style=\"margin-bottom: 10px;\" />\n" +
        "                </td>\n" +
        "              </tr>\n" +
        "              <tr>\n" +
        "                <td>\n" +
        "                  <p><b>" + place.name + "</b></p>\n" +
        "                  <p>" + place.getAddress() + "</p>\n" +
        "                  <p>" + place.getDescription() + "</p>\n" +
        "                </td>\n" +
        "              </tr>\n" +
        "            </table>\n" +
        "            <h3 style=\"margin-top: 20px; text-align: center;\">Nearby POIs</h3>\n" +
        "            <table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"font-size: 14px; margin: auto; text-align: center;\" border=1 frame=void rules=rows>\n";

    List<PlaceInfo> nearbyPois = [];
    nearbyPois.addAll(place.getPois());
    int i = 0;
    for (PlaceInfo p in nearbyPois) {
      i++;
      s += "              <tr>\n" +
          "                <td colspan=\"2\" align=\"center\">\n" +
          "                  <img src=\"" + p.getImageLink() + "\" alt=\"picture\" height=\"100\" style=\"float: left; margin-right: 10px;\" />\n" +
          "                  <p><b>" + p.getTitle() + "</b></p>\n" +
          "                  <p>" + p.getAddress() + "</p>\n" +
          "                </td>\n" +
          "              </tr>\n";
      if (i == 10) break;
    }

    s += "            </table>\n" +
        "          </body>\n" +
        "        </html>\n" +
        "      ]]></description>\n" +
        "      <overlayXY x=\"0\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <screenXY x=\"1\" y=\"1\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <rotationXY x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <size x=\"0\" y=\"0\" xunits=\"fraction\" yunits=\"fraction\"/>\n" +
        "      <gx:balloonVisibility>1</gx:balloonVisibility>\n" +
        "    </ScreenOverlay>\n" +
        "  </Document>\n" +
        "</kml>\n' > /var/www/html/kml/slave_${slaveNo}.kml";
    return s;
  }

  static generateOverlayBalloon(String html) {
    return '''<?xml version="1.0" encoding="UTF-8"?>
        <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
          <Document>
            <name>historic.kml</name>
            <ScreenOverlay>
        $html
            </ScreenOverlay>
          </Document>
        </kml>''';
  }

  static balloon(
      MapPosition camera,
      String html,
      String title
      ) =>
      '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
 <name>About Data</name>
 <Style id="about_style">
   <BalloonStyle>
     <textColor>ff000000</textColor>
     <text>
        $html
     </text>
     <bgColor>ffffffff</bgColor>
   </BalloonStyle>
 </Style>
 <Placemark id="ab">
    <name> $title </name>
   <description>
   </description>
   <LookAt>
     <longitude>${camera.longitude}</longitude>
     <latitude>${camera.latitude}</latitude>
     <heading>${camera.bearing}</heading>
     <tilt>${camera.tilt}</tilt>
     <range>${camera.zoom.zoomLG}</range>
   </LookAt>
   <styleUrl>#about_style</styleUrl>
   <gx:balloonVisibility>1</gx:balloonVisibility>
   <Point>
     <coordinates>${camera.longitude},${camera.latitude},0</coordinates>
   </Point>
 </Placemark>
</Document>
</kml>''';





}
