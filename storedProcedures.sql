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
    TRUNCATE TABLE flowmeter;
    TRUNCATE TABLE well_stock;
    TRUNCATE TABLE completion;
    TRUNCATE TABLE well_downtime_reasons;
    TRUNCATE TABLE daily_well_parameters;
    TRUNCATE TABLE well_tests;
    TRUNCATE TABLE laboratory_results;
END //

CREATE PROCEDURE GetLatestWellStockByDate(IN reportDateParam DATE)
BEGIN
    WITH LatestWellStock AS (
        SELECT 
            well_id, 
            MAX(report_date) AS latest_date
        FROM 
            well_stock
        WHERE 
            report_date <= reportDateParam
        GROUP BY 
            well_id
    )
    SELECT 
        ws.*
    FROM 
        well_stock ws
    INNER JOIN 
        LatestWellStock lws
    ON 
        ws.well_id = lws.well_id AND ws.report_date = lws.latest_date;
END //

CREATE PROCEDURE GetDailyWellParametersWithDowntimeReasonsByDate (
    IN reportDateParam DATE
)
BEGIN
    WITH LatestDownTime AS (
        SELECT *
        FROM well_downtime_reasons AS wdr
        WHERE report_date <= reportDateParam
        AND NOT EXISTS (
            SELECT 1 
            FROM well_downtime_reasons AS sub_wdr
            WHERE sub_wdr.well_id = wdr.well_id 
            AND sub_wdr.report_date > wdr.report_date 
            AND sub_wdr.report_date <= reportDateParam
        )
    )
    SELECT 
        dwp.*, 
        ld.downtime_category, 
        ld.production_sub_skins_activity_id, 
        ld.comments
    FROM 
        daily_well_parameters AS dwp
    LEFT JOIN 
        LatestDownTime AS ld 
    ON 
        dwp.well_id = ld.well_id
    WHERE 
        dwp.report_date = reportDateParam;
END //

CREATE PROCEDURE GetDailyWellParametersWithDowntimeReasonsByDate2 (
    IN reportDateParam DATE
)
BEGIN
    WITH LatestDownTime AS (
        SELECT well_id, MAX(report_date) AS latest_report_date
        FROM well_downtime_reasons
        WHERE report_date <= reportDateParam
        GROUP BY well_id
),
    LatestDownTimeTable AS (
        SELECT wdr.*
        FROM well_downtime_reasons AS wdr
        INNER JOIN LatestDownTime AS ldt
        ON wdr.well_id = ldt.well_id
        AND wdr.report_date = ldt.latest_report_date
)
SELECT *
FROM daily_well_parameters AS dwp
LEFT JOIN LatestDownTimeTable AS ldt
ON dwp.well_id = ldt.well_id
WHERE dwp.report_date = reportDateParam
END //

CREATE PROCEDURE GetDailyWellParametersWithDowntimeReasonsByDate3 (
    IN start_date DATE,   -- Placeholder for the start date
    IN end_date DATE      -- Placeholder for the end date
)
BEGIN
    -- If end_date is not provided (NULL), set it to start_date
    SET end_date = IFNULL(end_date, start_date);

    -- Query to get daily well parameters with the latest downtime reasons
    SELECT 
        dwp.*, 
        ld.downtime_category, 
        ld.production_sub_skins_activity_id, 
        ld.comments
    FROM 
        daily_well_parameters AS dwp
    LEFT JOIN well_downtime_reasons AS ld 
    ON dwp.well_id = ld.well_id
    AND ld.report_date = (
        -- This subquery finds the latest downtime reason for each well_id and report_date from daily_well_parameters
        SELECT MAX(wdr.report_date)
        FROM well_downtime_reasons AS wdr
        WHERE wdr.well_id = dwp.well_id
        AND wdr.report_date <= dwp.report_date
    )
    WHERE 
        dwp.report_date BETWEEN start_date AND end_date
END //

DELIMITER ;