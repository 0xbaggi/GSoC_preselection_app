import 'package:simple_app/entities/ssh_entity.dart';
import 'package:ssh2/ssh2.dart';

class SSHService {
  late SSHClient client;
  bool connected = false;
  static SSHService shared = SSHService();

  Future<void> connect(SSHEntity connectionSettings) async {
    client = SSHClient(
      host: connectionSettings.host,
      port: connectionSettings.port,
      username: connectionSettings.username,
      passwordOrKey: connectionSettings.passwordOrKey,
    );

    if (await client.connect() == 'session_connected') {
      connected = true;
    } else {
      connected = false;
    }
  }

  Future<String?> executeCommand(String command) async {
    return await client.execute(command);
  }

  Future<void> disconnect() async {
    await client.disconnect();
    connected = false;
  }

  Future<void> upload(String filePath) async {
    String? result = await client.connectSFTP();

    if (result == 'sftp_connected') {
      await client.sftpUpload(
          path: filePath,
          toPath: '/var/www/html',
          callback: (progress) {
            print('Sent $progress');
          });
    }
  }
}