DELIMITER //

CREATE PROCEDURE DeleteTodayEntries()
BEGIN
    DELETE FROM flowmeter WHERE DATE(created_at) = CURDATE();
    DELETE FROM well_stock WHERE DATE(created_at) = CURDATE();
    DELETE FROM completion WHERE DATE(created_at) = CURDATE();
    DELETE FROM well_downtime_reasons WHERE DATE(created_at) = CURDATE();
    DELETE FROM daily_well_parameters WHERE DATE(created_at) = CURDATE();
    DELETE FROM well_tests WHERE DATE(created_at) = CURDATE();
    DELETE FROM laboratory_results WHERE DATE(created_at) = CURDATE();
END //

CREATE PROCEDURE DeleteAllEntries()
BEGIN
    DELETE FROM flowmeter;
    DELETE FROM well_stock;
    DELETE FROM completion;
    DELETE FROM well_downtime_reasons;
    DELETE FROM daily_well_parameters;
    DELETE FROM well_tests;
    DELETE FROM laboratory_results;
END //

DELIMITER ;