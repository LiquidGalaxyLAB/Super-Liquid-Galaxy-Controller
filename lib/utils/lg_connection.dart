import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:super_liquid_galaxy_controller/data_class/map_position.dart';
import 'package:super_liquid_galaxy_controller/utils/kmlgenerator.dart';

class LGConnection extends GetxController {

  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  var isConnected = false.obs;
  SSHClient? _client;

  /*LGConnection._privateConstructor() {
    print("instance created");
    _connectionDetails();
    print("details got");
    connectToLG();

  }
  static final LGConnection _instance = LGConnection._privateConstructor();
  static LGConnection get instance => _instance;*/

  int rigCount()
  {
    return int.parse(_numberOfRigs);
  }

  bool connectStatus()
  {
    return isConnected.value;
  }

  _connectionDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _host = preferences.getString('ip') ?? '';
    _passwordOrKey = preferences.getString('pass') ?? '';
    _port = preferences.getString('port') ?? '';
    _username = preferences.getString('username') ?? '';
    _numberOfRigs = preferences.getString('number_of_rigs') ?? '';
    //await connectToLG();
    print({
      "ip": _host,
      "pass": _passwordOrKey,
      "port": _port,
      "username": _username,
      "number_of_rigs": _numberOfRigs
    });
    return {
      "ip": _host,
      "pass": _passwordOrKey,
      "port": _port,
      "username": _username,
      "number_of_rigs": _numberOfRigs
    };
  }

  getStoredDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _host = preferences.getString('ip') ?? '';
    _passwordOrKey = preferences.getString('pass') ?? '';
    _port = preferences.getString('port') ?? '';
    _username = preferences.getString('username') ?? '';
    _numberOfRigs = preferences.getString('number_of_rigs') ?? '';
    print({
      "ip": _host,
      "pass": _passwordOrKey,
      "port": _port,
      "username": _username,
      "number_of_rigs": _numberOfRigs
    });
    return {
      "ip": _host,
      "pass": _passwordOrKey,
      "port": _port,
      "username": _username,
      "number_of_rigs": _numberOfRigs
    };
  }

  Future<bool?> reConnectToLG() async {
    //_connectionDetails();
    await connectToLG();
    return isConnected.value;
  }

  Future<bool> connectToLG() async {
    await _connectionDetails();
    print('reached here');

    try {
      final socket = await SSHSocket.connect(_host, int.parse(_port),timeout: const Duration(seconds: 5));
      _client = SSHClient(socket, username: _username, onPasswordRequest: () {
        return _passwordOrKey;
      });
      print("IP: $_host , port: $_port");
      isConnected.value =true;
      return true;
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      isConnected.value=false;
      return false;
    }
    catch(e)
    {
      print('Failed to connect: $e');
      isConnected.value=false;
      return false;
    }
  }


  resetRefresh() async {
    try {
      if(_client==null)
        return;
      for (var i = 1; i <= int.parse(_numberOfRigs); i++) {
        String search =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        await _client?.run(
            'sshpass -p ${_passwordOrKey} ssh -t lg$i \'echo ${_passwordOrKey} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
      }
    } catch (error) {
      Get.snackbar(
          "ERROR", error.toString(), colorText: Colors.red);
    }
  }

  rebootLG() async {

    if (_client == null) {
      print('SSH client is not initialized.');
      return null;
    }
    try {
      for (var i = int.parse(_numberOfRigs); i >=1 ; i--) {
        await _client!.execute(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S reboot"'
        );
      }
    } catch (error) {
      Get.snackbar(
          "ERROR", error.toString(), colorText: Colors.red);
      return null;
    }
  }

  setRefresh() async {
    try {
      for (var i = 1; i <= int.parse(_numberOfRigs); i++) {
        if(_client==null) {
          return;
        }
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await _client!.run(
            'sshpass -p ${_passwordOrKey} ssh -t lg$i \'echo ${_passwordOrKey} | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml\'');
        await _client!.run(
            'sshpass -p ${_passwordOrKey} ssh -t lg$i \'echo ${_passwordOrKey} | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
        print("Refresh set");
      }
    } catch (error) {
      Get.snackbar(
          "ERROR", error.toString(), colorText: Colors.red);
      print("Refresh error");
    }
  }
  Future<void> renderInSlave(int slaveNo, String kml) async {
    try {
      if(_client==null) {
        return;
      }
      await _client!.run("echo '$kml' > /var/www/html/kml/slave_$slaveNo.kml");
      print("balloon sent");
      await setRefresh();
      print("refresh sent");

      return;
    } catch (error) {
      Get.snackbar(
          "ERROR", error.toString(), colorText: Colors.red);
      print("render error");
      return;
    }
  }

  runKml(String kmlName) async {
    try {
      if(_client==null)
        return false;
      print('running kml');
      await _client!.run('echo "\nhttp://lg1:81/$kmlName.kml" > /var/www/html/kmls.txt');
      print('kml ran');
      return true;
    } catch (error) {
      print('Error occurred while running:$error');
      return false;
      // await connectToLG();
      // await runKml(kmlName);
    }
  }

  Future<void> shutdown() async {


    for (var i = int.tryParse(_numberOfRigs)!; i >= 1; i--) {
      try {
        if(_client==null)
          return;
        await _client!.execute(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S poweroff"');
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  Future<void> relaunch() async {

    for (var i = int.tryParse(_numberOfRigs)!; i >= 1; i--)  {
      try {
        if(_client==null)
          return;
        final relaunchCommand = """RELAUNCH_CMD="\\
if [ -f /etc/init/lxdm.conf ]; then
  export SERVICE=lxdm
elif [ -f /etc/init/lightdm.conf ]; then
  export SERVICE=lightdm
else
  exit 1
fi
if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
  echo $_passwordOrKey | sudo -S service \\\${SERVICE} start
else
  echo $_passwordOrKey | sudo -S service \\\${SERVICE} restart
fi
" && sshpass -p $_passwordOrKey ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";
        await _client!
            .execute('"/home/$_username/bin/lg-relaunch" > /home/$_client/log.txt');
        await _client!.execute(relaunchCommand);
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  Future<bool> clearKml() async {
    try {
      if (_client == null) {
        return false;
      }

      String query =
          'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';
      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        String blankKml = KMLGenerator.generateBlank('slave_$i');
        query += " && echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
      }

      await _client!.execute(query);
      return true;
    }
    catch(e)
    {
      print(e);
      return false;
    }
  }

  kmlFileUpload(File inputFile, String kmlName) async {
    try {
      if(_client == null)
          return;

      //bool uploading = true;
      final sftp = await _client?.sftp();
      final file = await sftp?.open('/var/www/html/$kmlName.kml',
          mode: SftpFileOpenMode.create |
          SftpFileOpenMode.truncate |
          SftpFileOpenMode.write);
      var fileSize = await inputFile.length();
      file?.write(inputFile.openRead().cast(),
          onProgress: (progress) {
        print(progress / fileSize);
        if (fileSize == progress) {
          //uploading = false;
        }
      });
      if (file == null) {
        return;
      }
    } catch (error) {
      print(error);
    }
  }


  Future<bool> moveTo(MapPosition position) async {
    if(_client==null)
      {
        await reConnectToLG();
        if(isConnected.value==false) {
          return false;
        }
      }

    try {
      await _client!.execute(
          'echo "flytoview=${position.toLookAt(int.parse(_numberOfRigs)).generateLinearString()}" > /tmp/query.txt');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  startOrbit(context) async {
    try {
      if(_client==null) {
        return;
      }
      await _client?.run('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (error) {
      print("failed: ${error.toString()}");
    }
  }

  makeFile(String filename, String content) async {
    try{
      var localPath = await getApplicationDocumentsDirectory();
      print(localPath.path.toString());
      File localFile = File('${localPath.path}/$filename.kml');
      await localFile.writeAsString(content);
      print("file created");
      return localFile;
    }
    catch(e)
    {
      print("error : $e");
    }
  }

}