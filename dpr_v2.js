import { promises as fs, createWriteStream, existsSync, mkdirSync } from 'fs';
import path from 'path';
import mysql from 'mysql2/promise';
import officeCrypto from 'officecrypto-tool';
import readXlsxFile from 'read-excel-file/node';
import chalk from 'chalk';

const inputFolder = process.argv[2] || './';
const password = 'gun123';

//// generate logger function to log to console and local file
if (!existsSync('./logs')) {
  mkdirSync('./logs', { recursive: true });
}
const logFilePath = getFormattedFilename();

const stream = createWriteStream(logFilePath, { flags: 'a' });

let logger_without_timestamp = false;
const success = 'SUCCESS';
const error = 'ERROR';
const warning = 'WARNING';

let success_count = 0;
let error_count = 0;
let warning_count = 0;
let info_count = 0;

let flowmeter_insertion_count = 0;
let well_stock_insertion_count = 0;
let completion_insertion_count = 0;
let well_tests_insertion_count = 0;
let daily_well_parameters_insertion_count = 0;
let well_downtime_reasons_insertion_count = 0;
let laboratory_results_insertion_count = 0;

const logger = {
  log: (message, level = 'INFO') => {
    const timestamp = new Date().toLocaleString('en-US', {
      timeZone: 'Asia/Baku',
      hour12: false,
    });

    let style;
    if (level === success) {
      style = chalk.green;
      success_count++;
    } else if (level === error) {
      style = chalk.red;
      error_count++;
    } else if (level === warning) {
      style = chalk.yellow;
      warning_count++;
    } else if (level === 'INFO' && logger_without_timestamp === false) {
      info_count++;
    }

    let content;
    if (logger_without_timestamp) {
      content = `\n${message}`;
    } else {
      content = `\n${timestamp} ${`[${level}]:`.padStart(10)} ${message}`;
    }

    stream.write(content);
    console.log(content);
  },
  close: () => stream.end(),
};
////

let connection;
try {
  logger_without_timestamp = true;
  logger.log(`${'*'.repeat(100)}`);
  logger.log('SCRIPT EXECUTION STARTED...');
  logger_without_timestamp = false;

  connection = await mysql.createConnection(
    'mysql://root:3231292@localhost:3306/dpr?dateStrings=true'
  );

  const [wells] = await connection.query('SELECT * FROM wells');
  const [platforms] = await connection.query('SELECT * FROM platforms');
  const [well_stock_categories] = await connection.query(
    'SELECT * FROM well_stock_categories'
  );
  const [well_stock_sub_categories] = await connection.query(
    'SELECT * FROM well_stock_sub_categories'
  );
  const [production_well_stock_sub_categories] = await connection.query(
    'SELECT * FROM production_well_stock_sub_categories'
  );
  const [production_methods] = await connection.query(
    'SELECT * FROM production_methods'
  );
  const [horizons] = await connection.query('SELECT * FROM horizons');
  const [production_sub_skins_activities] = await connection.query(
    'SELECT * FROM production_sub_skins_activities'
  );
  ////

  //// Go through files in folder specified in `inputFolder`, find `.xls` or `xlsx` files, decrypt them, parse each cell from Excel files, insert into db
  const files = await fs.readdir(inputFolder);

  outer: for (const file of files) {
    const filePath = path.join(inputFolder, file);
    const extension = path.extname(file).toLowerCase();
    if (extension === '.xls' || extension === '.xlsx') {
      logger_without_timestamp = true;
      logger.log(`${'='.repeat(100)}`);
      logger.log(`|'${filePath}'| Parsing...`);
      logger_without_timestamp = false;

      const input = await fs.readFile(filePath);
      const output = await officeCrypto.decrypt(input, { password });
      const rows = await readXlsxFile(output, { sheet: 'Hesabat forması' });

      // parse platform_id
      const platform_number = rows[18][4];
      const platform_id = platforms.find(
        (i) => i.name.trim() === String(platform_number).trim()
      )?.id;
      if (!platform_id) {
        logger.log(`Platform number is not correct in excel file`, error);
        logger.log(`Data is not persisted into DB!`, warning);
        continue outer;
      }
      //

      // parse report_date
      let report_date = rows[17][4];
      if (!isValidDate(report_date)) {
        logger.log(`Report_date is not correct`, error);
        logger.log(`Data is not persisted into DB!`, warning);
        continue outer;
      }
      report_date = processDateValue(report_date);
      //

      // rename excel file to keep it clean
      const newFileName = `DPR-${platform_number}-${report_date}.xlsx`;
      const newFilePath = path.join(path.dirname(filePath), newFileName);
      await fs.rename(filePath, newFilePath);
      //

      // check if report is yesterday's report
      // const today = new Date().toLocaleDateString('en-CA', {
      //   timeZone: 'Asia/Baku',
      // });
      // const diffDays = (new Date(today) - new Date(report_date)) / 86400000;
      // if (diffDays !== 1) {
      //   logger.log(
      //     `Report_date is not yesterday's`,
      //     error
      //   );
      //   logger.log(
      //     `Data is not persisted into DB!`,
      //     warning
      //   );
      //   continue outer;
      // }
      //

      // parse flowmeter params
      const reading1 = rows[17][56];
      const reading2 = rows[18][56];
      const reading3 = rows[17][58];
      const reading4 = rows[18][58];
      let calibration_date = rows[20][56];
      if (isValidDate(calibration_date)) {
        calibration_date = processDateValue(calibration_date);
      } else {
        calibration_date = null;
      }
      //

      //// populate flowmeter table
      logger_without_timestamp = true;
      logger.log(`${'-'.repeat(100)}`);
      logger.log(
        `|'Report Date: ${report_date}'|'Platform ${platform_number}'|'flowmeter table'| populating DB...`
      );
      logger_without_timestamp = false;

      // check flowmeter entry exists in DB
      const flowmeter_entry_exists_query =
        'SELECT COUNT(*) AS flowmeter_entry_exists FROM flowmeter WHERE platform_id = ? AND report_date = ?';
      const flowmeter_entry_exists_query_data = [platform_id, report_date];
      const [flowmeter_entry_exists_query_result] = await connection.query(
        flowmeter_entry_exists_query,
        flowmeter_entry_exists_query_data
      );
      const { flowmeter_entry_exists } =
        flowmeter_entry_exists_query_result[0] || {};
      //

      // get previous entry from flowmeter table
      const flowmeter_previous_entry_query =
        'SELECT * from FLOWMETER WHERE platform_id = ? AND report_date < ? ORDER BY report_date DESC LIMIT 1';

      const flowmeter_previous_entry_query_data = [platform_id, report_date];

      const [flowmeter_previous_entry] = await connection.query(
        flowmeter_previous_entry_query,
        flowmeter_previous_entry_query_data
      );

      const {
        report_date: flowmeter_previous_report_date,
        reading1: flowmeter_previous_reading1,
        reading2: flowmeter_previous_reading2,
        reading3: flowmeter_previous_reading3,
        reading4: flowmeter_previous_reading4,
      } = flowmeter_previous_entry[0] || {};

      const flowmeter_previous_entry_is_yesterday = isYesterday(
        report_date,
        flowmeter_previous_report_date
      );
      //

      // insert entry into flowmeter table
      const flowmeter_query =
        'INSERT INTO flowmeter (platform_id, report_date, reading1, reading2, reading3, reading4, calibration_date) VALUES (?, ?, ?, ?, ?, ?, ?)';

      const flowmeter_query_data = [
        platform_id,
        report_date,
        reading1,
        reading2,
        reading3,
        reading4,
        calibration_date,
      ];

      if (![2, 3, 4, 7, 8, 13].includes(platform_number)) {
        logger.log(`Flowmeter is not present`);
        logger.log(`Not populated!`);
      } else if (
        !reading2 ||
        !reading4 ||
        ([8, 13].includes(platform_number) && (!reading1 || !reading3))
      ) {
        logger.log(`Check flowmeter parameters`, error);
        logger.log(`Not populated!`, warning);
      } else if (!Number(flowmeter_entry_exists)) {
        await connection.query(flowmeter_query, flowmeter_query_data);
        logger.log(`Populated!`, success);
        flowmeter_insertion_count++;
        // check whether today's flowmeter params same as yesterday's (show warning)
        if (
          flowmeter_previous_entry_is_yesterday &&
          (([2, 3, 4, 7].includes(platform_number) &&
            (flowmeter_previous_reading2 == reading2 ||
              flowmeter_previous_reading4 == reading4)) ||
            ([8, 13].includes(platform_number) &&
              (flowmeter_previous_reading1 == reading1,
              flowmeter_previous_reading2 == reading2,
              flowmeter_previous_reading3 == reading3,
              flowmeter_previous_reading4 == reading4)))
        ) {
          logger.log(
            `Today's Flowmeter params are same as yesterday's!`,
            warning
          );
        }
        //
      } else {
        logger.log(`Already populated!`);
      }
      //
      ////

      //// looping through rows (wells)
      inner: for (let i = 28; i < rows.length; i++) {
        const row = rows[i];
        if (row[2] === null) break;

        let validation_error = false;

        const well_number = row[3];
        const well_id = wells.find(
          (i) => i.name.trim() === String(well_number).trim()
        )?.id;

        // check if well name is specified correctly
        if (!well_id) {
          logger_without_timestamp = true;
          logger.log(`${'-'.repeat(100)}`);
          logger_without_timestamp = false;

          logger.log(
            `Check |'Platform ${platform_number}'|'row-${
              i + 1
            }'| Well name is not correct`,
            error
          );
          logger.log(
            `Check |'Platform ${platform_number}'|'row-${
              i + 1
            }'| Data is not persisted into DB!`,
            warning
          );
          continue inner;
        }
        //

        logger_without_timestamp = true;
        logger.log(`${'-'.repeat(100)}`);
        logger.log(
          `|'Report Date: ${report_date}'|'Platform ${platform_number}'|'Well ${well_number}'| populating DB...`
        );
        logger_without_timestamp = false;

        const well_stock_category_id = well_stock_categories.find(
          (i) => i.name.trim() === row[4]?.trim?.()
        )?.id;
        const well_stock_sub_category_id = well_stock_sub_categories.find(
          (i) => i.name.trim() === row[5]?.trim?.()
        )?.id;
        const production_well_stock_sub_category_id =
          production_well_stock_sub_categories.find(
            (i) => i.name.trim() === row[6]?.trim?.()
          )?.id;
        const production_method_id = production_methods.find(
          (i) => i.name.trim() === row[7]?.trim?.()
        )?.id;
        const horizon_id = horizons.find(
          (i) => i.name.trim() === row[8]?.trim?.()
        )?.id;

        const casing = row[9];
        const completion_interval = row[10];
        const tubing1_depth = row[11];
        const tubing1_length = row[12];
        const tubing2_depth = row[13];
        const tubing2_length = row[14];
        const tubing3_depth = row[15];
        const tubing3_length = row[16];
        const packer_depth = row[17];
        const flowmeter = row[18];

        let last_well_test_date = row[19];
        let last_lab_date = row[35];

        // check if dates are in correct format
        if (!isValidDate(last_well_test_date) || !isValidDate(last_lab_date)) {
          logger.log(
            `Check 'last_well_test_date or last_lab_date is not correct'`,
            error
          );
          validation_error = true;
        } else {
          last_well_test_date = processDateValue(last_well_test_date);
          last_lab_date = processDateValue(last_lab_date);
        }
        //

        const choke_wt = row[20];
        const pqa_wt = row[21];
        const phf_wt = row[22];
        const pba_wt = row[23];
        const p6x9_wt = row[24];
        const p9x13_wt = row[25];
        const p13x20_wt = row[26];
        const liquid_ton = row[27];
        const oil_density = row[30];
        const total_gas = row[32];
        const gaslift_gas_wt = row[33];
        const water_cut = row[36];
        const mechanical_impurities = row[37];
        const well_uptime_hours = row[38];
        const choke_day = row[39];
        const pqa_day = row[40];
        const phf_day = row[41];
        const pba_day = row[42];
        const p6x9_day = row[43];
        const p9x13_day = row[44];
        const p13x20_day = row[45];
        const gaslift_gas_day = row[46];
        const oil_loss_ton = row[52];
        const downtime_category = row[53];
        const production_sub_skins_activity_id =
          production_sub_skins_activities.find(
            (i) => i.name.slice(0, 5).trim() === row[56]?.slice(0, 5).trim()
          )?.id;
        const comments = row[57];

        // check if some must-have cells are empty
        const must_have_datalist = [
          ['well_stock_category', well_stock_category_id],
          ['well_stock_sub_category', well_stock_sub_category_id],
          ['choke_wt', choke_wt],
          ['pqa_wt', pqa_wt],
          ['phf_wt', phf_wt],
          ['pba_wt', pba_wt],
          ['p6x9_wt', p6x9_wt],
          ['p9x13_wt', p9x13_wt],
          ['p13x20_wt', p13x20_wt],
          ['liquid_ton', liquid_ton],
          ['oil_density', oil_density],
          ['total_gas', total_gas],
          ['gaslift_gas_wt', gaslift_gas_wt],
          ['water_cut', water_cut],
          ['mechanical_impurities', mechanical_impurities],
          ['well_uptime_hours', well_uptime_hours],
          ['choke_day', choke_day],
          ['pqa_day', pqa_day],
          ['phf_day', phf_day],
          ['pba_day', pba_day],
          ['p6x9_day', p6x9_day],
          ['p9x13_day', p9x13_day],
          ['p13x20_day', p13x20_day],
          ['gaslift_gas_day', gaslift_gas_day],
          ['oil_loss_ton', oil_loss_ton],
        ];

        const error_datalist = must_have_datalist
          .filter(
            (i) => i[1] === null || i[1] === undefined || i[1]?.trim?.() === ''
          )
          .map((j) => j[0]);

        if (error_datalist.length > 0) {
          logger.log(`Check '${error_datalist.join(',  ')}'`, error);
          validation_error = true;
        }
        //

        // check if well is flowing, then flowmeter column is specified
        if (
          (well_stock_category_id === 1 || well_stock_category_id === 2) &&
          production_well_stock_sub_category_id === 1 &&
          !flowmeter
        ) {
          logger.log(`Check 'which flowmeter well is flowing'`, error);
          validation_error = true;
        }
        //

        // check if well_uptime_hours is in correct format
        if (well_uptime_hours < 0 || well_uptime_hours > 24) {
          logger.log(
            `Check 'well_uptime_hours should be between (0-24) hours'`,
            error
          );
          validation_error = true;
        }
        //

        // check if well_uptime_hours less than 24, reasons are specified
        if (
          well_uptime_hours < 24 &&
          (!downtime_category || !production_sub_skins_activity_id || !comments)
        ) {
          logger.log(
            `Check 'well_uptime_hours < 24, bu no skin, no comment'`,
            error
          );
          validation_error = true;
        }
        //

        // check liquid_ton is not out of range
        if (
          (well_stock_category_id === 1 || well_stock_category_id === 2) &&
          liquid_ton > 500
        ) {
          logger.log(`Check 'liquid_ton can not be bigger than 500'`, error);
          validation_error = true;
        }
        //

        // check total_gas is bigger than gaslift_gas
        if (total_gas < gaslift_gas_wt) {
          logger.log(
            `Check 'total gas can not be less than gaslift gas'`,
            error
          );
          validation_error = true;
        }
        //

        // check water_cut and mechanical_impurities is not out of range
        if (
          water_cut < 0 ||
          water_cut > 100 ||
          mechanical_impurities < 0 ||
          mechanical_impurities > 100
        ) {
          logger.log(
            `Check 'water cut / mechanical impurities should be between (0-100)%'`,
            error
          );
          validation_error = true;
        }
        //

        // check whether last_lab_date belongs to well_test
        const well_tests_first_entry_query =
          'SELECT * FROM well_tests WHERE well_id = ? ORDER BY well_test_date LIMIT 1';

        const well_tests_first_entry_data = [well_id];

        const [well_tests_first_entry] = await connection.query(
          well_tests_first_entry_query,
          well_tests_first_entry_data
        );

        const { well_test_date: well_tests_first_report_date } =
          well_tests_first_entry[0] || {};

        if (well_tests_first_report_date) {
          const lab_result_exists_query =
            'SELECT COUNT(*) AS well_tests_count FROM well_tests WHERE well_id = ? AND (well_test_date = ? OR ? = ? OR ? < ?)';

          const lab_result_exists_query_data = [
            well_id,
            last_lab_date,
            last_well_test_date,
            last_lab_date,
            last_lab_date,
            well_tests_first_report_date,
          ];

          const [lab_result_exists] = await connection.query(
            lab_result_exists_query,
            lab_result_exists_query_data
          );

          const { well_tests_count } = lab_result_exists[0] || {};

          if (!Number(well_tests_count)) {
            logger.log(
              `last_lab_date does not belong to past well_tests`,
              error
            );
            validation_error = true;
          }
        }
        //

        // important, all errors rejects here
        if (validation_error) {
          logger.log(`Data is not persisted into DB!`, warning);
          continue inner;
        }
        //

        //// populate well_stock table
        // check well_stock entry exists in DB
        const well_stock_entry_exists_query =
          'SELECT COUNT(*) AS well_stock_entry_exists FROM well_stock WHERE well_id = ? AND report_date = ?';

        const well_stock_entry_exists_query_data = [well_id, report_date];

        const [well_stock_entry_exists_query_result] = await connection.query(
          well_stock_entry_exists_query,
          well_stock_entry_exists_query_data
        );

        const { well_stock_entry_exists } =
          well_stock_entry_exists_query_result[0] || {};
        //

        // get previous entry from well_stock table
        const well_stock_previous_entry_query =
          'SELECT * FROM well_stock WHERE well_id = ? AND report_date < ? ORDER BY report_date DESC LIMIT 1';

        const well_stock_previous_entry_query_data = [well_id, report_date];

        const [well_stock_previous_entry] = await connection.query(
          well_stock_previous_entry_query,
          well_stock_previous_entry_query_data
        );

        const {
          report_date: well_stock_previous_report_date,
          well_stock_category_id: well_stock_previous_well_stock_category_id,
          well_stock_sub_category_id:
            well_stock_previous_well_stock_sub_category_id,
          production_well_stock_sub_category_id:
            well_stock_previous_production_well_stock_sub_category_id,
          production_method_id: well_stock_previous_production_method_id,
        } = well_stock_previous_entry[0] || {};

        const well_stock_previous_entry_is_yesterday = isYesterday(
          report_date,
          well_stock_previous_report_date
        );
        //

        // insert entry into well_stock table
        const well_stock_query =
          'INSERT INTO well_stock (well_id, report_date, well_stock_category_id, well_stock_sub_category_id, production_well_stock_sub_category_id, production_method_id) VALUES (?, ?, ?, ?, ?, ?)';

        const well_stock_query_data = [
          well_id,
          report_date,
          well_stock_category_id,
          well_stock_sub_category_id,
          production_well_stock_sub_category_id,
          production_method_id,
        ];

        const well_stock_changed =
          well_stock_previous_well_stock_category_id !=
            well_stock_category_id ||
          well_stock_previous_well_stock_sub_category_id !=
            well_stock_sub_category_id ||
          well_stock_previous_production_well_stock_sub_category_id !=
            production_well_stock_sub_category_id ||
          well_stock_previous_production_method_id != production_method_id;

        if (
          !Number(well_stock_entry_exists) &&
          (!well_stock_previous_entry_is_yesterday || well_stock_changed)
        ) {
          await connection.query(well_stock_query, well_stock_query_data);
          logger.log(`|'well_stock'| Populated!`, success);
          well_stock_insertion_count++;
        } else {
          logger.log(
            `|'well_stock'| Already populated! (or nothing changed compared to yesterday)`
          );
        }
        //
        ////

        //// populate completion table
        // get latest entry from completion table
        const completion_latest_entry_query =
          'SELECT * FROM completion WHERE well_id = ? ORDER BY id DESC LIMIT 1';

        const completion_latest_entry_query_data = [well_id];

        const [completion_latest_entry] = await connection.query(
          completion_latest_entry_query,
          completion_latest_entry_query_data
        );

        const {
          report_date: completion_latest_report_date,
          horizon_id: completion_latest_horizon_id,
          casing: completion_latest_casing,
          completion_interval: completion_latest_completion_interval,
          tubing1_depth: completion_latest_tubing1_depth,
          tubing1_length: completion_latest_tubing1_length,
          tubing2_depth: completion_latest_tubing2_depth,
          tubing2_length: completion_latest_tubing2_length,
          tubing3_depth: completion_latest_tubing3_depth,
          tubing3_length: completion_latest_tubing3_length,
          packer_depth: completion_latest_packer_depth,
        } = completion_latest_entry[0] || {};
        //

        // insert entry into completion table
        const completion_query =
          'INSERT INTO completion (well_id, report_date, horizon_id, casing, completion_interval, tubing1_depth, tubing1_length, tubing2_depth, tubing2_length, tubing3_depth, tubing3_length, packer_depth) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

        const completion_query_data = [
          well_id,
          report_date,
          horizon_id,
          casing,
          completion_interval,
          tubing1_depth,
          tubing1_length,
          tubing2_depth,
          tubing2_length,
          tubing3_depth,
          tubing3_length,
          packer_depth,
        ];

        const completion_changed =
          completion_latest_horizon_id != horizon_id ||
          completion_latest_casing != casing ||
          completion_latest_completion_interval != completion_interval ||
          completion_latest_tubing1_depth != tubing1_depth ||
          completion_latest_tubing1_length != tubing1_length ||
          completion_latest_tubing2_depth != tubing2_depth ||
          completion_latest_tubing2_length != tubing2_length ||
          completion_latest_tubing3_depth != tubing3_depth ||
          completion_latest_tubing3_length != tubing3_length ||
          completion_latest_packer_depth != packer_depth;

        if (
          !completion_latest_report_date ||
          (new Date(completion_latest_report_date) < new Date(report_date) &&
            completion_changed)
        ) {
          await connection.query(completion_query, completion_query_data);
          logger.log(`|'completion'| Populated!`, success);
          completion_insertion_count++;
        } else {
          logger.log(
            `|'completion'| Already populated! (or nothing changed compared to yesterday)`
          );
        }
        //
        ////

        //// populate well_downtime_reasons table
        // get latest entry from well_downtime_reasons table
        const well_downtime_reasons_latest_entry_query =
          'SELECT * FROM well_downtime_reasons WHERE well_id = ? ORDER BY id DESC LIMIT 1';

        const well_downtime_reasons_latest_entry_query_data = [well_id];

        const [well_downtime_reasons_latest_entry] = await connection.query(
          well_downtime_reasons_latest_entry_query,
          well_downtime_reasons_latest_entry_query_data
        );

        const {
          report_date: well_downtime_reasons_latest_report_date,
          downtime_category: well_downtime_reasons_latest_downtime_category,
          production_sub_skins_activity_id:
            well_downtime_reasons_latest_production_sub_skins_activity_id,
          comments: well_downtime_reasons_latest_comments,
        } = well_downtime_reasons_latest_entry[0] || {};
        //

        // insert entry into well_downtime_reasons table
        const well_downtime_reasons_query =
          'INSERT INTO well_downtime_reasons (well_id, report_date, downtime_category, production_sub_skins_activity_id, comments) VALUES (?, ?, ?, ?, ?)';

        const well_downtime_reasons_query_data = [
          well_id,
          report_date,
          downtime_category,
          production_sub_skins_activity_id,
          comments,
        ];

        const well_downtime_reasons_changed =
          well_downtime_reasons_latest_downtime_category != downtime_category ||
          well_downtime_reasons_latest_production_sub_skins_activity_id !=
            production_sub_skins_activity_id ||
          well_downtime_reasons_latest_comments != comments;

        if (
          !well_downtime_reasons_latest_report_date ||
          (new Date(well_downtime_reasons_latest_report_date) <
            new Date(report_date) &&
            well_downtime_reasons_changed)
        ) {
          await connection.query(
            well_downtime_reasons_query,
            well_downtime_reasons_query_data
          );
          logger.log(`|'well_downtime_reasons'| Populated!`, success);
          well_downtime_reasons_insertion_count++;
        } else {
          logger.log(
            `|'well_downtime_reasons'| Already populated! (or well_uptime_hours = 24)`
          );
        }
        //
        ////

        //// populate daily_well_parameters table
        // get latest entry from daily_well_parameters table
        const daily_well_parameters_latest_entry_query =
          'SELECT report_date FROM daily_well_parameters WHERE well_id = ? ORDER BY id DESC LIMIT 1';

        const daily_well_parameters_latest_entry_query_data = [well_id];

        const [daily_well_parameters_latest_entry] = await connection.query(
          daily_well_parameters_latest_entry_query,
          daily_well_parameters_latest_entry_query_data
        );

        const { report_date: daily_well_parameters_latest_report_date } =
          daily_well_parameters_latest_entry[0] || {};
        //

        // insert entry into daily_well_parameters table
        const daily_well_parameters_insert_query =
          'INSERT INTO daily_well_parameters (well_id, report_date, flowmeter, well_uptime_hours, choke, pqa, phf, pba, p6x9, p9x13, p13x20, liquid_ton, total_gas, gaslift_gas, reported_water_cut, water_cut, mechanical_impurities, oil_density, oil_loss_ton) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

        const daily_well_parameters_insert_query_data = [
          well_id,
          report_date,
          flowmeter,
          well_uptime_hours,
          choke_day,
          pqa_day,
          phf_day,
          pba_day,
          p6x9_day,
          p9x13_day,
          p13x20_day,
          (liquid_ton / 24) * well_uptime_hours,
          total_gas,
          gaslift_gas_day,
          water_cut,
          water_cut,
          mechanical_impurities,
          oil_density,
          (liquid_ton / 24) * (1 - water_cut / 100) * (24 - well_uptime_hours),
        ];

        if (
          !daily_well_parameters_latest_report_date ||
          new Date(daily_well_parameters_latest_report_date) <
            new Date(report_date)
        ) {
          await connection.query(
            daily_well_parameters_insert_query,
            daily_well_parameters_insert_query_data
          );
          logger.log(`|'daily_well_parameters'| Populated!`, success);
          daily_well_parameters_insertion_count++;
        } else {
          logger.log(`|'daily_well_parameters'| Already populated!`);
        }
        //
        ////

        //// populate well_tests table
        // get latest entry from well_tests table
        const well_tests_latest_entry_query =
          'SELECT well_test_date FROM well_tests WHERE well_id = ? ORDER BY id DESC LIMIT 1';

        const well_tests_latest_entry_query_data = [well_id];

        const [well_tests_latest_entry] = await connection.query(
          well_tests_latest_entry_query,
          well_tests_latest_entry_query_data
        );

        const { well_test_date: well_tests_latest_well_test_date } =
          well_tests_latest_entry[0] || {};
        //

        // insert entry into well_tests table
        const well_tests_insert_query =
          'INSERT INTO well_tests (well_id, well_test_date, choke, pqa, phf, pba, p6x9, p9x13, p13x20, liquid_ton, total_gas, gaslift_gas, reported_water_cut, water_cut, mechanical_impurities, oil_density) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

        const well_tests_insert_query_data = [
          well_id,
          last_well_test_date,
          choke_wt,
          pqa_wt,
          phf_wt,
          pba_wt,
          p6x9_wt,
          p9x13_wt,
          p13x20_wt,
          liquid_ton,
          total_gas,
          gaslift_gas_wt,
          water_cut,
          water_cut,
          mechanical_impurities,
          oil_density,
        ];

        if (
          !well_tests_latest_well_test_date ||
          new Date(well_tests_latest_well_test_date) <
            new Date(last_well_test_date)
        ) {
          await connection.query(
            well_tests_insert_query,
            well_tests_insert_query_data
          );
          logger.log(`|'well_tests'| Populated!`, success);
          well_tests_insertion_count++;
        } else {
          logger.log(`|'well_tests'| Already populated!`);
        }
        //
        ////

        //// populate laboratory_results table
        // get latest entry from laboratory_results table
        const laboratory_results_latest_entry_query =
          'SELECT last_lab_date FROM laboratory_results WHERE well_id = ? ORDER BY id DESC LIMIT 1';

        const laboratory_results_latest_entry_query_data = [well_id];

        const [laboratory_results_latest_entry] = await connection.query(
          laboratory_results_latest_entry_query,
          laboratory_results_latest_entry_query_data
        );

        const { last_lab_date: laboratory_results_latest_last_lab_date } =
          laboratory_results_latest_entry[0] || {};
        //

        // insert entry into laboratory_results table
        const laboratory_results_query =
          'INSERT INTO laboratory_results (well_id, last_lab_date, water_cut, mechanical_impurities) VALUES (?, ?, ?, ?)';

        const laboratory_results_query_data = [
          well_id,
          last_lab_date,
          water_cut,
          mechanical_impurities,
        ];

        if (
          !laboratory_results_latest_last_lab_date ||
          new Date(laboratory_results_latest_last_lab_date) <
            new Date(last_lab_date)
        ) {
          await connection.query(
            laboratory_results_query,
            laboratory_results_query_data
          );
          logger.log(`|'laboratory_results'| Populated!`, success);
          laboratory_results_insertion_count++;
        } else {
          logger.log(`|'laboratory_results'| Already populated!`);
        }
        //
        ////

        // check whether last_lab_date is obsolete
        if (
          (new Date(report_date) - new Date(last_well_test_date)) / 86400000 >=
            7 &&
          last_well_test_date != last_lab_date
        ) {
          logger.log(
            `Update lab results! Well test result should be available!`,
            warning
          );
        }
        //

        // check whether lab results of well tests are present
        const well_test_lab_result_exist_query =
          'SELECT well_test_date FROM well_tests AS wt WHERE well_id = ? AND (SELECT COUNT(*) = 0 FROM laboratory_results AS lr WHERE well_id = ? AND (wt.well_test_date = lr.last_lab_date OR DATEDIFF(wt.well_test_date, lr.last_lab_date) = 1)) ORDER BY wt.well_test_date DESC LIMIT 10';

        const well_test_lab_result_exist_query_data = [well_id, well_id];

        const [well_test_lab_result_exist_list] = await connection.query(
          well_test_lab_result_exist_query,
          well_test_lab_result_exist_query_data
        );

        if (well_test_lab_result_exist_list.length > 0) {
          const well_test_lab_result_exist_string =
            well_test_lab_result_exist_list
              .map((i) => i.well_test_date)
              .join(', ');
          logger.log(
            `Lab results of these well tests do not exist: ${well_test_lab_result_exist_string}`,
            warning
          );
        }
        //
      }
      ////
    }
  }
  ////
} catch (err) {
  logger.log(err, error);
  console.log(err);
} finally {
  if (connection) {
    await connection.end();
  }
  logger_without_timestamp = true;
  logger.log(`${'='.repeat(100)}`);
  logger.log('SCRIPT EXECUTION FINISHED!');
  logger.log(`${'.'.repeat(100)}`);
  logger.log(`S U M M A R Y`);
  logger.log(`${success_count.toString().padStart(6)}\t\tsuccess`);
  logger.log(`${error_count.toString().padStart(6)}\t\terror`);
  logger.log(`${warning_count.toString().padStart(6)}\t\twarning`);
  logger.log(`${info_count.toString().padStart(6)}\t\tinfo`);
  logger.log(
    `\n${flowmeter_insertion_count
      .toString()
      .padStart(6)}\t\trow(s) inserted into |'flowmeter'|`
  );
  logger.log(
    `${well_stock_insertion_count
      .toString()
      .padStart(6)}\t\trow(s) inserted into |'well_stock'|`
  );
  logger.log(
    `${completion_insertion_count
      .toString()
      .padStart(6)}\t\trow(s) inserted into |'completion'|`
  );
  logger.log(
    `${well_tests_insertion_count
      .toString()
      .padStart(6)}\t\trow(s) inserted into |'well_tests'|`
  );
  logger.log(
    `${daily_well_parameters_insertion_count
      .toString()
      .padStart(6)}\t\trow(s) inserted into |'daily_well_parameters'|`
  );
  logger.log(
    `${well_downtime_reasons_insertion_count
      .toString()
      .padStart(6)}\t\trow(s) inserted into |'well_downtime_reasons'|`
  );
  logger.log(
    `${laboratory_results_insertion_count
      .toString()
      .padStart(6)}\t\trow(s) inserted into |'laboratory_results'|`
  );
  logger.log(`${'.'.repeat(100)}`);
  logger.log(`${'*'.repeat(100)}`);
  logger_without_timestamp = false;
}

function getFormattedFilename() {
  const now = new Date();
  const day = String(now.getDate()).padStart(2, '0');
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const year = now.getFullYear();

  return `./logs/${day}.${month}.${year}-dpr.log`;
}

//// when we insert into mysql date needs to be in specific format
function convertDateToMysqlFormat(date) {
  const formattedDate = date
    .toLocaleString('en-US', {
      timeZone: 'Asia/Baku',
      hour12: false,
    })
    .split(',')[0];
  const [month, day, year] = formattedDate.split('/');
  const mysqlDate = `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`;
  return mysqlDate;
}

//// sometimes we get date value as number (timestamp) when parsing excel file
function processDateValue(value) {
  if (typeof value === 'number') {
    const excelEpoch = new Date(Date.UTC(1899, 11, 30));
    const date = new Date(excelEpoch.getTime() + value * 86400000);
    return convertDateToMysqlFormat(
      new Date(
        Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate())
      )
    );
  } else if (typeof value === 'object' || value instanceof Date) {
    return convertDateToMysqlFormat(value);
  }
  return convertDateToMysqlFormat(value);
}

function isValidDate(value) {
  if (typeof value === 'number') {
    if (value >= 0 && value < 100) return true;
    return value > 18000;
  }
  return !isNaN(Date.parse(value));
}

function isYesterday(date1, date2) {
  return (new Date(date1) - new Date(date2)) / 86400000 == 1;
}
