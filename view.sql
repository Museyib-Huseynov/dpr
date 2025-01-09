CREATE VIEW complete_table AS
SELECT 
	dwp.*, 
    ws.well_stock_category_id, 
    ws.well_stock_sub_category_id, 
    ws.production_well_stock_sub_category_id,
	ws.production_method_id,
    c.horizon_id,
    wdr.downtime_category,
    wdr.production_sub_skins_activity_id,
    wdr.comments    
FROM daily_well_parameters dwp
LEFT JOIN well_stock AS ws
ON dwp.well_id = ws.well_id
AND ws.report_date = (
	SELECT MAX(ws.report_date)
	FROM well_stock AS ws_sub
	WHERE ws_sub.well_id = dwp.well_id
	AND ws_sub.report_date <= dwp.report_date
)
LEFT JOIN completion AS c
ON dwp.well_id = c.well_id
AND c.report_date = (
	SELECT MAX(c.report_date)
    FROM completion AS c_sub
    WHERE c_sub.well_id = dwp.well_id
    AND c_sub.report_date <= dwp.report_date
)
LEFT JOIN well_downtime_reasons AS wdr
ON dwp.well_id = wdr.well_id
AND wdr.report_date = (
	SELECT MAX(wdr.report_date)
    FROM well_downtime_reasons AS wdr_sub
    WHERE wdr_sub.well_id = dwp.well_id
    AND wdr_sub.report_date <= dwp.report_date
)