import mysql from 'mysql2/promise';

let connection;
try {
  connection = await mysql.createConnection(
    'mysql://root:3231292@localhost:3306/dpr?dateStrings=true'
  );
  const [results] = await connection.execute('CALL DeleteTodayEntries()');
  console.log(results);
} catch (error) {
  console.log(error);
} finally {
  if (connection) {
    await connection.end();
  }
}
