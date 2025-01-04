DELIMITER //

CREATE TRIGGER after_laboratory_results_insert
AFTER INSERT
ON laboratory_results
FOR EACH ROW
BEGIN
    UPDATE well_tests 
    SET water_cut = NEW.water_cut, 
		mechanical_impurities = NEW.mechanical_impurities 
	WHERE well_id = NEW.well_id AND well_test_date >= NEW.last_lab_date;
    -- ORDER BY well_test_date
    -- LIMIT 1;
    
    UPDATE daily_well_parameters
    SET water_cut = NEW.water_cut,
		mechanical_impurities = NEW.mechanical_impurities
	WHERE well_id = NEW.well_id AND report_date >= NEW.last_lab_date;
END //

CREATE TRIGGER after_laboratory_results_delete
AFTER DELETE
ON laboratory_results
FOR EACH ROW
BEGIN
	DECLARE last_available_id INT;
	DECLARE last_available_water_cut FLOAT;
    DECLARE last_available_mechanical_impurities FLOAT;
    
    SELECT id, water_cut, mechanical_impurities
	INTO last_available_id, last_available_water_cut, last_available_mechanical_impurities
	FROM laboratory_results
	WHERE well_id = OLD.well_id
	ORDER BY last_lab_date DESC
	LIMIT 1;
    
    IF OLD.id > last_available_id THEN
		UPDATE well_tests 
		SET water_cut = last_available_water_cut, 
			mechanical_impurities = last_available_mechanical_impurities 
		WHERE well_id = OLD.well_id AND well_test_date >= OLD.last_lab_date;
		-- ORDER BY well_test_date
		-- LIMIT 1;
    
		UPDATE daily_well_parameters
		SET water_cut = last_available_water_cut,
			mechanical_impurities = last_available_mechanical_impurities
		WHERE well_id = OLD.well_id AND report_date >= OLD.last_lab_date;
	END IF; 
END //

DELIMITER ;