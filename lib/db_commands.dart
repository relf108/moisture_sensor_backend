import 'package:mysql1/mysql1.dart';

import 'credentials.dart';

class DBCommands {
  static Future<MySqlConnection> getConnection() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        db: 'moistureAnalytics',
        password: Credentials.password));
    return conn;
  }

  static void initDB() async {
    var conn = await getConnection();
    await conn.query(
        //date = yyyy-mm-dd
        'CREATE TABLE IF NOT EXISTS tbl_moisture (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, moisture_percent int, date date)');

    print('DB: tbl_moisture created.\n');
    await conn.close();
  }

  static void insert(int percent) async {
    var conn = await getConnection();
    var result = await conn.query(
        'insert into tbl_moisture (moisture_percent, date) values (?, ?)',
        ['$percent', DateTime.now().toString().split(' ')[0]]);
    print('Inserted row id=${result.insertId}');
    await conn.close();
  }

  static Future<List<Map<int, DateTime>>> getRows() async {
    var listPercentDate = <Map<int, DateTime>>[];
    var conn = await getConnection();
    var result =
        await conn.query('select moisture_percent, date from tbl_moisture');
    for (var row in result) {
      var percent = row[0];
      var date = row[1];
      var percentDate = <int, DateTime>{percent: date};
      listPercentDate.add(percentDate);
    }
    return listPercentDate;
  }
}
