CREATE DATABASE  IF NOT EXISTS `dpr` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `dpr`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: dpr
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `complete_table`
--

DROP TABLE IF EXISTS `complete_table`;
/*!50001 DROP VIEW IF EXISTS `complete_table`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `complete_table` AS SELECT 
 1 AS `id`,
 1 AS `well_id`,
 1 AS `report_date`,
 1 AS `flowmeter`,
 1 AS `well_uptime_hours`,
 1 AS `choke`,
 1 AS `pqa`,
 1 AS `phf`,
 1 AS `pba`,
 1 AS `p6x9`,
 1 AS `p9x13`,
 1 AS `p13x20`,
 1 AS `liquid_ton`,
 1 AS `total_gas`,
 1 AS `gaslift_gas`,
 1 AS `reported_water_cut`,
 1 AS `water_cut`,
 1 AS `mechanical_impurities`,
 1 AS `oil_density`,
 1 AS `oil_loss_ton`,
 1 AS `created_at`,
 1 AS `well_stock_category_id`,
 1 AS `well_stock_sub_category_id`,
 1 AS `production_well_stock_sub_category_id`,
 1 AS `production_method_id`,
 1 AS `horizon_id`,
 1 AS `downtime_category`,
 1 AS `production_sub_skins_activity_id`,
 1 AS `comments`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `completion`
--

DROP TABLE IF EXISTS `completion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `completion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `well_id` int NOT NULL,
  `report_date` date NOT NULL,
  `horizon_id` int DEFAULT NULL,
  `casing` varchar(255) DEFAULT NULL,
  `completion_interval` varchar(255) DEFAULT NULL,
  `tubing1_depth` varchar(255) DEFAULT NULL,
  `tubing1_length` varchar(255) DEFAULT NULL,
  `tubing2_depth` varchar(255) DEFAULT NULL,
  `tubing2_length` varchar(255) DEFAULT NULL,
  `tubing3_depth` varchar(255) DEFAULT NULL,
  `tubing3_length` varchar(255) DEFAULT NULL,
  `packer_depth` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_completion` (`well_id`,`report_date`),
  KEY `horizon_id` (`horizon_id`),
  CONSTRAINT `completion_ibfk_1` FOREIGN KEY (`well_id`) REFERENCES `wells` (`id`),
  CONSTRAINT `completion_ibfk_2` FOREIGN KEY (`horizon_id`) REFERENCES `horizons` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `completion`
--

LOCK TABLES `completion` WRITE;
/*!40000 ALTER TABLE `completion` DISABLE KEYS */;
/*!40000 ALTER TABLE `completion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_operative`
--

DROP TABLE IF EXISTS `daily_operative`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_operative` (
  `id` int NOT NULL AUTO_INCREMENT,
  `report_date` date NOT NULL,
  `field_id` int NOT NULL,
  `oil_ton` int DEFAULT NULL,
  `water_ton` int DEFAULT NULL,
  `water_injected_ton` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_daily_operative` (`report_date`,`field_id`),
  KEY `field_id` (`field_id`),
  CONSTRAINT `daily_operative_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_operative`
--

LOCK TABLES `daily_operative` WRITE;
/*!40000 ALTER TABLE `daily_operative` DISABLE KEYS */;
INSERT INTO `daily_operative` VALUES (1,'2024-12-31',1,8982,6218,3776);
/*!40000 ALTER TABLE `daily_operative` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_well_parameters`
--

DROP TABLE IF EXISTS `daily_well_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_well_parameters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `well_id` int NOT NULL,
  `report_date` date NOT NULL,
  `flowmeter` int DEFAULT NULL,
  `well_uptime_hours` int DEFAULT NULL,
  `choke` varchar(255) DEFAULT NULL,
  `pqa` varchar(255) DEFAULT NULL,
  `phf` varchar(255) DEFAULT NULL,
  `pba` varchar(255) DEFAULT NULL,
  `p6x9` varchar(255) DEFAULT NULL,
  `p9x13` varchar(255) DEFAULT NULL,
  `p13x20` varchar(255) DEFAULT NULL,
  `liquid_ton` int DEFAULT NULL,
  `total_gas` int DEFAULT NULL,
  `gaslift_gas` int DEFAULT NULL,
  `reported_water_cut` float DEFAULT NULL,
  `water_cut` float DEFAULT NULL,
  `mechanical_impurities` float DEFAULT NULL,
  `oil_density` float DEFAULT NULL,
  `oil_loss_ton` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_daily_well_parameter` (`well_id`,`report_date`),
  CONSTRAINT `daily_well_parameters_ibfk_1` FOREIGN KEY (`well_id`) REFERENCES `wells` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_well_parameters`
--

LOCK TABLES `daily_well_parameters` WRITE;
/*!40000 ALTER TABLE `daily_well_parameters` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_well_parameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fields`
--

DROP TABLE IF EXISTS `fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `ogpd_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_field` (`name`,`ogpd_id`),
  KEY `ogpd_id` (`ogpd_id`),
  CONSTRAINT `fields_ibfk_1` FOREIGN KEY (`ogpd_id`) REFERENCES `ogpd` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fields`
--

LOCK TABLES `fields` WRITE;
/*!40000 ALTER TABLE `fields` DISABLE KEYS */;
INSERT INTO `fields` VALUES (1,'SWG',1);
/*!40000 ALTER TABLE `fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flowmeter`
--

DROP TABLE IF EXISTS `flowmeter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flowmeter` (
  `id` int NOT NULL AUTO_INCREMENT,
  `platform_id` int NOT NULL,
  `report_date` date NOT NULL,
  `reading1` int DEFAULT NULL,
  `reading2` int DEFAULT NULL,
  `reading3` int DEFAULT NULL,
  `reading4` int DEFAULT NULL,
  `calibration_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_flowmeter` (`platform_id`,`report_date`),
  CONSTRAINT `flowmeter_ibfk_1` FOREIGN KEY (`platform_id`) REFERENCES `platforms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flowmeter`
--

LOCK TABLES `flowmeter` WRITE;
/*!40000 ALTER TABLE `flowmeter` DISABLE KEYS */;
/*!40000 ALTER TABLE `flowmeter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horizons`
--

DROP TABLE IF EXISTS `horizons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horizons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_horizon` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horizons`
--

LOCK TABLES `horizons` WRITE;
/*!40000 ALTER TABLE `horizons` DISABLE KEYS */;
INSERT INTO `horizons` VALUES (11,'BLD_IX'),(14,'BLD_IX+BLD_VIII'),(7,'BLD_V'),(6,'BLD_V+Sabunçu_IV'),(8,'BLD_VI'),(17,'BLD_VI+BLD_V'),(9,'BLD_VII'),(16,'BLD_VII+BLD_VI'),(10,'BLD_VIII'),(15,'BLD_VIII+BLD_VII'),(12,'BLD_X'),(13,'BLD_X+BLD_IX'),(30,'BLD_X+BLD_VIII'),(18,'FLD'),(19,'FLD+BLD_X'),(26,'QA'),(27,'QA+QD'),(32,'QA+QÜG'),(31,'QA+QÜQ'),(28,'QaLD'),(29,'QaLD+QA'),(24,'QD'),(25,'QD+QÜQ'),(20,'QÜG'),(21,'QÜG+FLD'),(22,'QÜQ'),(23,'QÜQ+QÜG'),(1,'Sabunçu_II'),(2,'Sabunçu_III'),(5,'Sabunçu_III+Sabunçu_II'),(3,'Sabunçu_IV'),(4,'Sabunçu_IV+Sabunçu_III');
/*!40000 ALTER TABLE `horizons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `laboratory_results`
--

DROP TABLE IF EXISTS `laboratory_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `laboratory_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `well_id` int NOT NULL,
  `last_lab_date` date DEFAULT NULL,
  `water_cut` float DEFAULT NULL,
  `mechanical_impurities` float DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_laboratory_result` (`well_id`,`last_lab_date`),
  CONSTRAINT `laboratory_results_ibfk_1` FOREIGN KEY (`well_id`) REFERENCES `wells` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `laboratory_results`
--

LOCK TABLES `laboratory_results` WRITE;
/*!40000 ALTER TABLE `laboratory_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `laboratory_results` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_laboratory_results_insert` AFTER INSERT ON `laboratory_results` FOR EACH ROW BEGIN
    UPDATE well_tests 
    SET water_cut = NEW.water_cut, 
		mechanical_impurities = NEW.mechanical_impurities 
		WHERE well_id = NEW.well_id 
		AND well_test_date >= NEW.last_lab_date 
		AND (
			NOT EXISTS (
				SELECT 1 FROM laboratory_results as lr1 where lr1.last_lab_date > NEW.last_lab_date
			)
			OR well_test_date < (SELECT MIN(lr2.last_lab_date) FROM laboratory_results as lr2 WHERE lr2.last_lab_date >  NEW.last_lab_date )
		); 
    -- ORDER BY well_test_date 
    -- LIMIT 1;
    
    UPDATE daily_well_parameters
    SET water_cut = NEW.water_cut,
		mechanical_impurities = NEW.mechanical_impurities
		WHERE well_id = NEW.well_id 
		AND report_date >= NEW.last_lab_date
		AND (
			NOT EXISTS (
				SELECT 1 FROM laboratory_results as lr1 WHERE lr1.last_lab_date > NEW.last_lab_date
			)
			OR report_date < (SELECT MIN(lr2.last_lab_date) FROM laboratory_results as lr2 WHERE lr2.last_lab_date >  NEW.last_lab_date )
		);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_laboratory_results_delete` AFTER DELETE ON `laboratory_results` FOR EACH ROW BEGIN
	DECLARE last_available_water_cut FLOAT;
  DECLARE last_available_mechanical_impurities FLOAT;
    
  SELECT water_cut, mechanical_impurities
	INTO last_available_water_cut, last_available_mechanical_impurities
	FROM laboratory_results
	WHERE well_id = OLD.well_id
	AND last_lab_date < OLD.last_lab_date
	ORDER BY last_lab_date DESC
	LIMIT 1;

	UPDATE well_tests 
	SET water_cut = last_available_water_cut, 
	mechanical_impurities = last_available_mechanical_impurities 
	WHERE well_id = OLD.well_id 
	AND well_test_date >= OLD.last_lab_date 
	AND (
		NOT EXISTS (
			SELECT 1 FROM laboratory_results as lr1 where lr1.last_lab_date > OLD.last_lab_date
		)
		OR well_test_date < (SELECT MIN(lr2.last_lab_date) FROM laboratory_results as lr2 WHERE lr2.last_lab_date >  OLD.last_lab_date )
	); 

	UPDATE daily_well_parameters
    SET water_cut = last_available_water_cut,
		mechanical_impurities = last_available_mechanical_impurities
		WHERE well_id = OLD.well_id 
		AND report_date >= OLD.last_lab_date
		AND (
			NOT EXISTS (
				SELECT 1 FROM laboratory_results as lr1 WHERE lr1.last_lab_date > OLD.last_lab_date
			)
			OR report_date < (SELECT MIN(lr2.last_lab_date) FROM laboratory_results as lr2 WHERE lr2.last_lab_date >  OLD.last_lab_date )
		);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ogpd`
--

DROP TABLE IF EXISTS `ogpd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ogpd` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_ogpd` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ogpd`
--

LOCK TABLES `ogpd` WRITE;
/*!40000 ALTER TABLE `ogpd` DISABLE KEYS */;
INSERT INTO `ogpd` VALUES (1,'28 May');
/*!40000 ALTER TABLE `ogpd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platforms`
--

DROP TABLE IF EXISTS `platforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platforms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `field_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_platform` (`name`,`field_id`),
  KEY `field_id` (`field_id`),
  CONSTRAINT `platforms_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platforms`
--

LOCK TABLES `platforms` WRITE;
/*!40000 ALTER TABLE `platforms` DISABLE KEYS */;
INSERT INTO `platforms` VALUES (9,'10',1),(10,'11',1),(11,'13',1),(12,'14',1),(13,'15',1),(14,'19',1),(1,'2',1),(2,'3',1),(3,'4',1),(4,'5',1),(5,'6',1),(6,'7',1),(7,'8',1),(8,'9',1);
/*!40000 ALTER TABLE `platforms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `production_methods`
--

DROP TABLE IF EXISTS `production_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `production_methods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_production_method` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_methods`
--

LOCK TABLES `production_methods` WRITE;
/*!40000 ALTER TABLE `production_methods` DISABLE KEYS */;
INSERT INTO `production_methods` VALUES (5,'Erlift'),(1,'Fontan'),(7,'MEDN'),(2,'Qazlift (boru arxası)'),(3,'Qazlift (həlqəvi fəza)'),(4,'Qazlift (mandrel)'),(6,'ŞDN'),(8,'Vintli');
/*!40000 ALTER TABLE `production_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `production_skins`
--

DROP TABLE IF EXISTS `production_skins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `production_skins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_production_skin` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_skins`
--

LOCK TABLES `production_skins` WRITE;
/*!40000 ALTER TABLE `production_skins` DISABLE KEYS */;
INSERT INTO `production_skins` VALUES (5,'Dəniz_Özülüdə_və_ya_Quruda_Yığım_Nəql_Sistemi'),(6,'İxrac_Sistemi'),(1,'Keçici_Fond_Guyuları'),(7,'OPEC_Tələblərinin_Yerinə_Yetirilməsi'),(2,'Quyu_Ağzında_Aparılan_Əməliyyatlar'),(3,'Tədqiqat_Cari_və_Əsaslı_Təmir_Məqsədilə_Quyulara_Müdaxilə '),(4,'Yeni_Quyular ');
/*!40000 ALTER TABLE `production_skins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `production_sub_skins`
--

DROP TABLE IF EXISTS `production_sub_skins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `production_sub_skins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `production_skin_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_production_sub_skin` (`name`,`production_skin_id`),
  KEY `production_skin_id` (`production_skin_id`),
  CONSTRAINT `production_sub_skins_ibfk_1` FOREIGN KEY (`production_skin_id`) REFERENCES `production_skins` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_sub_skins`
--

LOCK TABLES `production_sub_skins` WRITE;
/*!40000 ALTER TABLE `production_sub_skins` DISABLE KEYS */;
INSERT INTO `production_sub_skins` VALUES (9,'Dəniz_Özülüdə_və_ya_Quruda_Hasilat_Sistemi_ilə_Bağlı_Əməliyyatlar',5),(14,'Hasilatın_Azaldılması',7),(6,'Hasilatın_Bərpası_Məqsədilə_Aparılan_Təmirlər',3),(1,'İdarə_Olunan_Keçici_Fond',1),(13,'İxrac_Boru_Kəmərinin_İşlək_Vəziyyətdə_Saxlanılması',6),(4,'Layalara_və_Quyulara_Tədqiqatlarla_Aparılan_Nəzarət',3),(12,'Neft_İxrac_Nasosu',6),(10,'Qazın_Sıxılması_Sistem_ilə_Bağlı_Əməliyyatlar',5),(8,'Quyu_Təyinatının_Dəyişdirilməsi',4),(2,'Quyuağzı_Bütövlülüyü',2),(3,'Quyudaxili_Avadanlıqların_Optimallaşdırılması',3),(11,'Suvurma_Sistemi_ilə_Bağlı_Əməliyyatlar',5),(7,'Yan_Lülə_Quyular_İstismar_və_Vurucu',4),(5,'Yatağın_İşlənməsinın_İdarə_Edilməsi_ilə_Bağlı_Fəaliyyətlər',3);
/*!40000 ALTER TABLE `production_sub_skins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `production_sub_skins_activities`
--

DROP TABLE IF EXISTS `production_sub_skins_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `production_sub_skins_activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `production_sub_skin_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_production_sub_skins_activity` (`name`,`production_sub_skin_id`),
  KEY `production_sub_skin_id` (`production_sub_skin_id`),
  CONSTRAINT `production_sub_skins_activities_ibfk_1` FOREIGN KEY (`production_sub_skin_id`) REFERENCES `production_sub_skins` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_sub_skins_activities`
--

LOCK TABLES `production_sub_skins_activities` WRITE;
/*!40000 ALTER TABLE `production_sub_skins_activities` DISABLE KEYS */;
INSERT INTO `production_sub_skins_activities` VALUES (1,'1.1.1_Cari ilin yanvarın 1-də Bazadakı quyularda hasilatın azalma dərəcəsi',1),(2,'1.1.2_Quyuların il ərzində fəaliyyətsiz fonda keçməsi və təmirdən sonra işlək fonduna (bazaya) qaytarılması',1),(3,'2.2.1_Fontan armaturana daxil olan siyirtmələrin bütövlüyünün yoxlanılması',2),(4,'2.2.2_Quyudaxili Təhlükəsizlik Klapanın bütövlüyünün yoxlanılması',2),(5,'2.2.3_Quyuağzı avadanlığının bütövlüyü ilə bağlı digər işlər (istismar və suvurucu quyular üçün)',2),(6,'3.1.1_ŞDN quyularında quyudaxili avadanlıqların optimallaşdırılması  (Misal; nasosun dəyişdirilməsi)',3),(7,'3.1.2_MEDN quyularında quyudaxili avadanlıqların optimallaşdırılması  (Misal; nasosun dəyişdirilməsi)',3),(8,'3.1.3_Vintli nasos quyularında quyudaxili avadanlıqların optimallaşdırılması  (Misal; nasosun dəyişdirilməsi)',3),(9,'3.1.4_Qaz-lift quyularında qaz-maye qaldırıcının və avadanlıqların optimallaşdırılması (Misal; sıraları tənzimləmək, klapanlar tətbiqi, və.s)',3),(10,'3.1.5_Neft, qaz və qaz-kondensat fontan quyularında qaz-maye qaldırıcının optimallaşdırılması ((məsələn, NKB-ın uzunluğu və ölçüsü)',3),(11,'3.1.6_İstismar üsullarının dəyişdirilməsi',3),(12,'3.2.1_Quyudibi nümunələrin götürülməsi (neft, qaz, su, qum və s)',4),(13,'3.2.2_İstismar karotaji - PLT/ILT (istismar və vurucu quyularında axın və vurma profilinin çıxarılması, mayenin bir laydan digərinə axmasınln təyin edilməsi)',4),(14,'3.2.3_Quyudibi təzyiqin bərpa (istismar quyularda) və düşmə (vurucu quyularda) əyrilərin çıxarılması (lay təzyiqi, skin, kh əmsalının təyini) ',4),(15,'3.2.4_Akustik Noise və DAS cihazların tədbiqi (qumun gəlmə intervalının təyini, NKB-da və kəmərdə sızmaların təyini və s.)',4),(16,'3.2.5_Temperatur karotaji (sızmaların təyini,qaz amili yüksək olan intervalların təyini və s.) ',4),(17,'3.2.6_Doyumluluq karotajı (əlavə neftə douymuş zonaların təyini)',4),(18,'3.2.7_CBL Sement karotaji (sementin kefiyyıtini təyin edilməsi)',4),(19,'3.2.8_Çox ayaqlı Kaliper (kəmərin və qaldırıcı boruların vəziyyətini təyin edilməsi)',4),(20,'3.3.1_İstismarda olan horizontda yeni perforasiya intervalının əlavə edilməsi',5),(21,'3.3.2_İstismarda olan horizonta yeni horizontun (üst və ya alt) əlavə edilməsi - iki horizontun birgə istismarını həyata keçirilməsi',5),(22,'3.3.3_Su, qaz vurmada olan horizonta yeni horizontun (üst və ya alt) əlavəsi, vurmanın iki horizonta birgə həyata keçirilməsi (dəstək altında istasmar quyularında əlavə hasilat)',5),(23,'3.3.4_İstismar quyuların yuxarı və ya aşağı horizonta qaytarılması',5),(24,'3.3.5_Vurucu quyuların yuxarı və ya aşağı horizonta qaytarılması (dəstək altında olan istismar quyularında əlavə hasilat)',5),(25,'3.3.6_İstismar quyularında lay sularının təcrid olunma əməliyyatları (kimyəvi və mexaniki)',5),(26,'3.3.7_Quyu ətrafı zonaya təsir üsulları (hidravliki yarılma, turşu ilə işlənmə, termiki işlənmə və s)',5),(27,'3.4.1_Boruların sızması və digər hidravlik izolyasiya problemlərinin aradan qaldırılması',6),(28,'3.4.2_Mövcud tamamlanmış intervalın yenidən perforasiyası',6),(29,'3.4.3_Qum tıxacın yuyulması',6),(30,'3.4.4_Qumun gəlməsinin qarşısını almaq əməliyyatları (kimyəvi və mexaniki)',6),(31,'3.4.5_NKB-a və digər quydaxili avadanlıqlarda parafin və duz çöküntülərinə qarşı tədbirlər (mexaniki, istiliklə, kimyəvi və s.)',6),(32,'3.4.6_Qondarma qum süzgəclərin quraşdırılması',6),(33,'5.2.1_Yeni istismar və su vı ya qaz vurucu yan lülə quyuların qazılması (Əlavə olaraq bütün alt-sahələrdə olan əməliyyatlar daxil ola bilər)',7),(34,'5.3.1_Quyu təyinatının dəyişdirilməsi (misal: istismar quyunun su və ya qaz vurucuya kecirilməsi)\n(Əlavə olaraq bütün alt-sahələrdə olan əməliyyatlar daxil ola bilər)',8),(35,'5.3.3_İstismar quyuların istehsal növünün dəyişməsi (misal: neft quyusunu qaz quyusuna kecirməsi) (Əlavə olaraq bütün alt-sahələrdə olan əməliyyatlar daxil ola bilər)',8),(36,'6.1.1_Dəniz özülünün tam dayanması (planlaşdırılmış müddət ərzində)',9),(37,'6.1.2_Dəniz özülünün tam dayanması (planlaşdırılmışdan daha uzun müddət ərzində)',9),(38,'6.1.3_Hasilat sisteminin bir hissəsinin dayanması',9),(39,'6.1.4_Hasilat prosesi xəttinin dayanması',9),(40,'6.1.5_Hasilat prosesin dayanması',9),(41,'6.1.6_Fövqəladə dayanma',9),(42,'6.1.7_Sistemdəki limitlər: Əks təzyiqin qalxması (məs. sistemə əlavə qazın daxil olması), yerüstü avadanlıqlarda darboğazının aradan qaldırılmasıı: xəttlərdə təzyiqlərin aşağı salınması, əlavə xəttlərin çəkilməsi, gücləndirici nasosun dəyişdirilməsi və s',9),(43,'6.2.1_Qaz kompressorlarının nasazlığının bərpası',10),(44,'6.2.2_Qaz lift boru kəməri və axın xəttinin sızması, zədələnməsi, hidratın əmələ gəlməsi və s. problemlərin bərpası',10),(45,'6.2.3_Qaz vurma infrastrukturunun yenilənməsi, yeni kompressorların quraşdırılması, yeni xətlərin çəkilməsi və s',10),(46,'6.3.1_Suvurucu nasoslarının nasazlığının bərpası',11),(47,'6.3.2_Sistem axın xətlərinin sızması, zədələnməsi və s. səbəbiylə tam və ya qismən dayanma',11),(48,'6.3.3_Elektrik enerjisinin kəsilməsi',11),(49,'6.3.4_Suvurma infrastrukturunun təkmilləşdirilməsi, yeni nasosların quraşdırılması, yeni xətlərin çəkilməsi və s.',11),(50,'7.1.1_Mexanik, elektrik, idarəetmə sistemi və s. nasazlıqlar, insan səhvləri, yüksək temperatur və əks təzyiqdən bərpa',12),(51,'7.2.1_Ərsinləmə əməliyyati (parafin, su, qum təmizləmə)',13),(52,'7.2.2_Sızma/zədərin aşkarlanması və bərpası',13),(53,'8.1.1_Hədəfə nail olması üçün bir qrup istismar quyuların hasilatının azalması',14);
/*!40000 ALTER TABLE `production_sub_skins_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `production_well_stock_sub_categories`
--

DROP TABLE IF EXISTS `production_well_stock_sub_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `production_well_stock_sub_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `production_well_stock_sub_category` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `production_well_stock_sub_categories`
--

LOCK TABLES `production_well_stock_sub_categories` WRITE;
/*!40000 ALTER TABLE `production_well_stock_sub_categories` DISABLE KEYS */;
INSERT INTO `production_well_stock_sub_categories` VALUES (1,'Fəaliyyətdə (məhsul verən)'),(2,'Fəaliyyətdə (təmir gözləyən)'),(3,'Fəaliyyətsiz'),(4,'Qazmadan mənimsəmədə ');
/*!40000 ALTER TABLE `production_well_stock_sub_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `well_downtime_reasons`
--

DROP TABLE IF EXISTS `well_downtime_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `well_downtime_reasons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `report_date` date NOT NULL,
  `well_id` int NOT NULL,
  `downtime_category` varchar(255) DEFAULT NULL,
  `production_sub_skins_activity_id` int DEFAULT NULL,
  `comments` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_well_downtime_reason` (`report_date`,`well_id`),
  KEY `well_id` (`well_id`),
  KEY `production_sub_skins_activity_id` (`production_sub_skins_activity_id`),
  CONSTRAINT `well_downtime_reasons_ibfk_1` FOREIGN KEY (`well_id`) REFERENCES `wells` (`id`),
  CONSTRAINT `well_downtime_reasons_ibfk_2` FOREIGN KEY (`production_sub_skins_activity_id`) REFERENCES `production_sub_skins_activities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `well_downtime_reasons`
--

LOCK TABLES `well_downtime_reasons` WRITE;
/*!40000 ALTER TABLE `well_downtime_reasons` DISABLE KEYS */;
/*!40000 ALTER TABLE `well_downtime_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `well_stock`
--

DROP TABLE IF EXISTS `well_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `well_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `well_id` int NOT NULL,
  `report_date` date NOT NULL,
  `well_stock_category_id` int DEFAULT NULL,
  `well_stock_sub_category_id` int DEFAULT NULL,
  `production_well_stock_sub_category_id` int DEFAULT NULL,
  `production_method_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_well_stock` (`well_id`,`report_date`),
  KEY `well_stock_category_id` (`well_stock_category_id`),
  KEY `well_stock_sub_category_id` (`well_stock_sub_category_id`),
  KEY `production_well_stock_sub_category_id` (`production_well_stock_sub_category_id`),
  KEY `production_method_id` (`production_method_id`),
  CONSTRAINT `well_stock_ibfk_1` FOREIGN KEY (`well_id`) REFERENCES `wells` (`id`),
  CONSTRAINT `well_stock_ibfk_2` FOREIGN KEY (`well_stock_category_id`) REFERENCES `well_stock_categories` (`id`),
  CONSTRAINT `well_stock_ibfk_3` FOREIGN KEY (`well_stock_sub_category_id`) REFERENCES `well_stock_sub_categories` (`id`),
  CONSTRAINT `well_stock_ibfk_4` FOREIGN KEY (`production_well_stock_sub_category_id`) REFERENCES `production_well_stock_sub_categories` (`id`),
  CONSTRAINT `well_stock_ibfk_5` FOREIGN KEY (`production_method_id`) REFERENCES `production_methods` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `well_stock`
--

LOCK TABLES `well_stock` WRITE;
/*!40000 ALTER TABLE `well_stock` DISABLE KEYS */;
/*!40000 ALTER TABLE `well_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `well_stock_categories`
--

DROP TABLE IF EXISTS `well_stock_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `well_stock_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_well_stock_category` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `well_stock_categories`
--

LOCK TABLES `well_stock_categories` WRITE;
/*!40000 ALTER TABLE `well_stock_categories` DISABLE KEYS */;
INSERT INTO `well_stock_categories` VALUES (5,'Müşahidə quyu fondu'),(1,'Neft quyu fondu'),(2,'Qaz quyu fondu'),(4,'Qazvurucu quyu fondu'),(3,'Suvurucu quyu fondu'),(6,'Uducu quyu fondu');
/*!40000 ALTER TABLE `well_stock_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `well_stock_sub_categories`
--

DROP TABLE IF EXISTS `well_stock_sub_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `well_stock_sub_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_well_stock_sub_category` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `well_stock_sub_categories`
--

LOCK TABLES `well_stock_sub_categories` WRITE;
/*!40000 ALTER TABLE `well_stock_sub_categories` DISABLE KEYS */;
INSERT INTO `well_stock_sub_categories` VALUES (1,'İstismar'),(4,'Konservasiyada olan'),(2,'Ləğv olunmuş '),(3,'Ləğvini gözləyən');
/*!40000 ALTER TABLE `well_stock_sub_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `well_tests`
--

DROP TABLE IF EXISTS `well_tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `well_tests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `well_id` int NOT NULL,
  `well_test_date` date NOT NULL,
  `choke` varchar(255) DEFAULT NULL,
  `pqa` varchar(255) DEFAULT NULL,
  `phf` varchar(255) DEFAULT NULL,
  `pba` varchar(255) DEFAULT NULL,
  `p6x9` varchar(255) DEFAULT NULL,
  `p9x13` varchar(255) DEFAULT NULL,
  `p13x20` varchar(255) DEFAULT NULL,
  `liquid_ton` int DEFAULT NULL,
  `total_gas` int DEFAULT NULL,
  `gaslift_gas` int DEFAULT NULL,
  `reported_water_cut` float DEFAULT NULL,
  `water_cut` float DEFAULT NULL,
  `mechanical_impurities` float DEFAULT NULL,
  `oil_density` float DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_well_test` (`well_id`,`well_test_date`),
  CONSTRAINT `well_tests_ibfk_1` FOREIGN KEY (`well_id`) REFERENCES `wells` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `well_tests`
--

LOCK TABLES `well_tests` WRITE;
/*!40000 ALTER TABLE `well_tests` DISABLE KEYS */;
/*!40000 ALTER TABLE `well_tests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wells`
--

DROP TABLE IF EXISTS `wells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wells` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `platform_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_well` (`name`,`platform_id`),
  KEY `platform_id` (`platform_id`),
  CONSTRAINT `wells_ibfk_1` FOREIGN KEY (`platform_id`) REFERENCES `platforms` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=370 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wells`
--

LOCK TABLES `wells` WRITE;
/*!40000 ALTER TABLE `wells` DISABLE KEYS */;
INSERT INTO `wells` VALUES (53,'100',4),(41,'101',3),(2,'102',1),(12,'103',1),(3,'104',1),(4,'105',1),(5,'106',1),(6,'107',1),(7,'108',1),(8,'109',1),(13,'110',1),(16,'111',2),(17,'112',2),(18,'113',2),(363,'114',2),(19,'115',2),(364,'116',2),(20,'117',2),(21,'118',2),(22,'119',2),(9,'12',1),(23,'120',2),(365,'121',2),(24,'122',2),(366,'123',2),(25,'124',2),(26,'125',2),(27,'126',2),(367,'127',2),(368,'128',2),(369,'129',2),(168,'13',8),(42,'130',3),(33,'131',3),(161,'132',7),(136,'132a',7),(43,'133',3),(34,'134',3),(35,'135',3),(36,'136',3),(44,'137',3),(45,'138',3),(46,'139',3),(47,'140',3),(137,'141',7),(138,'142',7),(195,'143',9),(93,'144',5),(85,'145',5),(86,'147',5),(87,'148',5),(94,'149',5),(10,'15',1),(95,'150',5),(96,'151',5),(88,'152',5),(89,'153',5),(97,'154',5),(98,'155',5),(99,'156',5),(100,'157',5),(101,'159',5),(178,'160',9),(165,'161',8),(139,'162',7),(170,'163',8),(140,'164',7),(141,'165',7),(218,'166',10),(196,'167',9),(219,'168',10),(241,'169',10),(11,'17',1),(220,'170',10),(221,'171',10),(222,'172',10),(223,'173',10),(224,'174',10),(225,'175',10),(226,'176',10),(227,'177',10),(228,'178',10),(229,'179',10),(73,'18',4),(179,'180',9),(180,'181',9),(181,'182',9),(182,'183',9),(183,'184',9),(184,'185',9),(185,'186',9),(197,'187',9),(186,'188',9),(187,'189',9),(188,'190',9),(189,'191',9),(203,'192',9),(198,'193',9),(199,'194',9),(200,'195',9),(190,'196',9),(191,'197',9),(201,'198',9),(192,'199',9),(1,'2',1),(14,'20',2),(204,'200',9),(166,'201',8),(167,'202',8),(171,'203',8),(205,'204',9),(172,'205',8),(173,'206',8),(242,'207',10),(174,'208',8),(230,'209',10),(231,'210',10),(232,'211',10),(54,'212',4),(55,'213',4),(243,'214',10),(77,'215',4),(56,'216',4),(249,'217',11),(250,'218',11),(57,'219',4),(275,'22',12),(316,'220',13),(78,'221',4),(281,'222',12),(58,'223',4),(282,'225',12),(59,'226',4),(79,'227',4),(142,'228',7),(283,'229',12),(29,'23',3),(233,'230',10),(143,'231',7),(144,'232',7),(162,'233',7),(234,'234',10),(317,'235',13),(318,'236',13),(319,'237',13),(145,'238',7),(235,'239',10),(353,'24',12),(251,'240',11),(60,'241',4),(146,'242',7),(274,'243',11),(252,'244',11),(253,'245',11),(254,'246',11),(284,'247',12),(320,'248',13),(255,'249',11),(256,'250',11),(285,'251',12),(356,'252',12),(352,'253',12),(286,'254',12),(287,'255',12),(288,'256',12),(289,'257',12),(357,'258',12),(290,'259',12),(133,'26',7),(358,'260',12),(291,'261',12),(292,'262',12),(293,'263',12),(359,'264',12),(294,'265',12),(295,'266',12),(360,'267',12),(296,'268',12),(297,'269',12),(80,'270',4),(321,'271',13),(322,'272',13),(323,'273',13),(324,'274',13),(325,'275',13),(348,'276',13),(326,'277',13),(349,'278',13),(327,'279',13),(333,'28',14),(350,'280',13),(328,'281',13),(351,'282',13),(329,'283',13),(330,'285',13),(61,'286',4),(147,'287',7),(148,'288',7),(149,'289',7),(102,'29',6),(28,'290',2),(48,'291',3),(37,'292',3),(38,'293',3),(331,'294',13),(62,'295',4),(150,'296',7),(151,'297',7),(152,'298',7),(153,'299',7),(103,'29a',6),(163,'3',8),(206,'30',10),(154,'300',7),(298,'301',12),(155,'302',7),(156,'303',7),(157,'303a',7),(158,'304',7),(299,'305',12),(300,'306',12),(236,'307',10),(257,'308',11),(159,'309',7),(207,'31',10),(160,'310',7),(258,'311',11),(259,'312',11),(260,'313',11),(261,'313a',11),(262,'314',11),(263,'315',11),(105,'316',6),(106,'317',6),(107,'318',6),(108,'320',6),(109,'321',6),(110,'322',6),(111,'323',6),(112,'324',6),(113,'324a',6),(114,'325',6),(115,'326',6),(116,'327',6),(117,'328',6),(118,'329',6),(244,'33',11),(63,'330',4),(64,'331',4),(65,'332',4),(66,'333',4),(67,'334',4),(68,'335',4),(69,'336',4),(70,'337',4),(119,'338',6),(120,'339',6),(134,'34',7),(193,'340',9),(202,'341',9),(194,'341a',9),(121,'342',6),(122,'342a',6),(301,'343',12),(237,'344',10),(238,'345',10),(239,'346',10),(240,'347',10),(123,'348',6),(124,'348a',6),(125,'349',6),(135,'34a',7),(264,'350',11),(265,'351',11),(266,'352',11),(303,'353',12),(302,'353a',12),(304,'354',12),(305,'355',12),(126,'356',6),(127,'356a',6),(128,'357',6),(129,'358',6),(130,'359',6),(131,'360',6),(132,'360a',6),(71,'365',4),(72,'366',4),(334,'37',14),(104,'38',6),(306,'401',12),(307,'402',12),(342,'405',14),(346,'406',14),(343,'407',14),(308,'408',12),(276,'41',12),(344,'410',14),(309,'411',12),(310,'412',12),(311,'417',12),(81,'42',5),(267,'420',11),(90,'421',5),(268,'427',11),(269,'428',11),(175,'43',9),(270,'430',11),(332,'431',13),(271,'432',11),(272,'435',11),(273,'436',11),(208,'44',10),(82,'45',5),(245,'46',11),(246,'47',11),(209,'48',10),(83,'49',5),(176,'50',9),(361,'51',2),(210,'52',10),(362,'53',2),(211,'54',10),(91,'55',5),(212,'56',10),(213,'57',10),(214,'58',10),(215,'59',10),(177,'61',9),(354,'62',12),(355,'63',12),(39,'64',3),(40,'65',3),(30,'66',3),(31,'67',3),(32,'68',3),(335,'69',14),(84,'70',5),(345,'71',14),(336,'72',14),(337,'73',14),(277,'74',12),(338,'75',14),(339,'75a',14),(278,'76',12),(279,'77',12),(280,'77a',12),(216,'78',10),(247,'79',11),(248,'80',11),(15,'81',2),(92,'82',5),(217,'83',10),(49,'84',4),(50,'85',4),(74,'86',4),(51,'87',4),(164,'88',8),(312,'89',13),(340,'90',14),(341,'91',14),(169,'92',8),(313,'93',13),(52,'94',4),(75,'95',4),(76,'96',4),(314,'97',13),(315,'98',13),(347,'99',13);
/*!40000 ALTER TABLE `wells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'dpr'
--

--
-- Dumping routines for database 'dpr'
--
/*!50003 DROP PROCEDURE IF EXISTS `DeleteAllEntries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteAllEntries`()
BEGIN
    TRUNCATE TABLE flowmeter;
    TRUNCATE TABLE well_stock;
    TRUNCATE TABLE completion;
    TRUNCATE TABLE well_downtime_reasons;
    TRUNCATE TABLE daily_well_parameters;
    TRUNCATE TABLE well_tests;
    TRUNCATE TABLE laboratory_results;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeleteTodayEntries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteTodayEntries`()
BEGIN
    DELETE FROM flowmeter WHERE DATE(created_at) = CURDATE();
    DELETE FROM well_stock WHERE DATE(created_at) = CURDATE();
    DELETE FROM completion WHERE DATE(created_at) = CURDATE();
    DELETE FROM well_downtime_reasons WHERE DATE(created_at) = CURDATE();
    DELETE FROM daily_well_parameters WHERE DATE(created_at) = CURDATE();
    DELETE FROM well_tests WHERE DATE(created_at) = CURDATE();
    DELETE FROM laboratory_results WHERE DATE(created_at) = CURDATE();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `complete_table`
--

/*!50001 DROP VIEW IF EXISTS `complete_table`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `complete_table` AS select `dwp`.`id` AS `id`,`dwp`.`well_id` AS `well_id`,`dwp`.`report_date` AS `report_date`,`dwp`.`flowmeter` AS `flowmeter`,`dwp`.`well_uptime_hours` AS `well_uptime_hours`,`dwp`.`choke` AS `choke`,`dwp`.`pqa` AS `pqa`,`dwp`.`phf` AS `phf`,`dwp`.`pba` AS `pba`,`dwp`.`p6x9` AS `p6x9`,`dwp`.`p9x13` AS `p9x13`,`dwp`.`p13x20` AS `p13x20`,`dwp`.`liquid_ton` AS `liquid_ton`,`dwp`.`total_gas` AS `total_gas`,`dwp`.`gaslift_gas` AS `gaslift_gas`,`dwp`.`reported_water_cut` AS `reported_water_cut`,`dwp`.`water_cut` AS `water_cut`,`dwp`.`mechanical_impurities` AS `mechanical_impurities`,`dwp`.`oil_density` AS `oil_density`,`dwp`.`oil_loss_ton` AS `oil_loss_ton`,`dwp`.`created_at` AS `created_at`,`ws`.`well_stock_category_id` AS `well_stock_category_id`,`ws`.`well_stock_sub_category_id` AS `well_stock_sub_category_id`,`ws`.`production_well_stock_sub_category_id` AS `production_well_stock_sub_category_id`,`ws`.`production_method_id` AS `production_method_id`,`c`.`horizon_id` AS `horizon_id`,`wdr`.`downtime_category` AS `downtime_category`,`wdr`.`production_sub_skins_activity_id` AS `production_sub_skins_activity_id`,`wdr`.`comments` AS `comments` from (((`daily_well_parameters` `dwp` left join `well_stock` `ws` on(((`dwp`.`well_id` = `ws`.`well_id`) and (`ws`.`report_date` = (select max(`ws`.`report_date`) from `well_stock` `ws_sub` where ((`ws_sub`.`well_id` = `dwp`.`well_id`) and (`ws_sub`.`report_date` <= `dwp`.`report_date`))))))) left join `completion` `c` on(((`dwp`.`well_id` = `c`.`well_id`) and (`c`.`report_date` = (select max(`c`.`report_date`) from `completion` `c_sub` where ((`c_sub`.`well_id` = `dwp`.`well_id`) and (`c_sub`.`report_date` <= `dwp`.`report_date`))))))) left join `well_downtime_reasons` `wdr` on(((`dwp`.`well_id` = `wdr`.`well_id`) and (`wdr`.`report_date` = (select max(`wdr`.`report_date`) from `well_downtime_reasons` `wdr_sub` where ((`wdr_sub`.`well_id` = `dwp`.`well_id`) and (`wdr_sub`.`report_date` <= `dwp`.`report_date`))))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-14 16:31:58
