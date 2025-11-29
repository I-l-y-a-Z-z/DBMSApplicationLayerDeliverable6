CREATE DATABASE MNHS;
USE MNHS;

SET FOREIGN_KEY_CHECKS = 0;

-- MySQL dump 10.13  Distrib 8.0.43, for Linux (x86_64)
--
-- Host: localhost    Database: MNHS
-- ------------------------------------------------------
-- Server version	8.0.43-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Appointment`
--

DROP TABLE IF EXISTS `Appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Appointment` (
  `CAID` int NOT NULL,
  `Reason` varchar(500) DEFAULT NULL,
  `Status` enum('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
  PRIMARY KEY (`CAID`),
  CONSTRAINT `Appointment_ibfk_1` FOREIGN KEY (`CAID`) REFERENCES `ClinicalActivity` (`CAID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Appointment`
--

LOCK TABLES `Appointment` WRITE;
/*!40000 ALTER TABLE `Appointment` DISABLE KEYS */;
INSERT INTO `Appointment` VALUES (1000,'Heart Failure Followup','Completed'),(1001,'Insulin Adjustment','Completed'),(1002,'Diabetic Foot Check','Completed'),(1003,'Hypertension Control','Scheduled'),(1004,'Chest Pain Investigation','Scheduled'),(2001,'Fracture Surgery Consultation','Scheduled'),(3000,'Severe Asthma','Completed'),(3001,'High Fever','Completed'),(3002,'Flu Symptoms','Completed'),(3003,'Vaccination','Completed'),(4001,'Prenatal Checkup','Scheduled'),(4002,'Chemotherapy Cycle','Scheduled'),(4003,'hola','Scheduled');
/*!40000 ALTER TABLE `Appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Caregiving`
--

DROP TABLE IF EXISTS `Caregiving`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Caregiving` (
  `STAFF_ID` int NOT NULL,
  `Grade` varchar(50) DEFAULT NULL,
  `Ward` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`STAFF_ID`),
  CONSTRAINT `Caregiving_ibfk_1` FOREIGN KEY (`STAFF_ID`) REFERENCES `Staff` (`STAFF_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Caregiving`
--

LOCK TABLES `Caregiving` WRITE;
/*!40000 ALTER TABLE `Caregiving` DISABLE KEYS */;
INSERT INTO `Caregiving` VALUES (4,'Senior','ER'),(5,'Junior','Cardio'),(8,'Senior','Ortho'),(13,'Head','Peds'),(14,'Junior','Endo'),(17,'Senior','Derma'),(22,'Midwife','Maternity'),(23,'Junior','Onco'),(27,'Senior','Pneumo'),(30,'Junior','Psych');
/*!40000 ALTER TABLE `Caregiving` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ClinicalActivity`
--

DROP TABLE IF EXISTS `ClinicalActivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ClinicalActivity` (
  `CAID` int NOT NULL,
  `IID` int NOT NULL,
  `STAFF_ID` int NOT NULL,
  `DEP_ID` int NOT NULL,
  `Date` date NOT NULL,
  `Time` time DEFAULT NULL,
  PRIMARY KEY (`CAID`),
  KEY `IID` (`IID`),
  KEY `STAFF_ID` (`STAFF_ID`),
  KEY `DEP_ID` (`DEP_ID`),
  CONSTRAINT `ClinicalActivity_ibfk_1` FOREIGN KEY (`IID`) REFERENCES `Patient` (`IID`),
  CONSTRAINT `ClinicalActivity_ibfk_2` FOREIGN KEY (`STAFF_ID`) REFERENCES `Staff` (`STAFF_ID`),
  CONSTRAINT `ClinicalActivity_ibfk_3` FOREIGN KEY (`DEP_ID`) REFERENCES `Department` (`DEP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ClinicalActivity`
--

LOCK TABLES `ClinicalActivity` WRITE;
/*!40000 ALTER TABLE `ClinicalActivity` DISABLE KEYS */;
INSERT INTO `ClinicalActivity` VALUES (1000,100,2,11,'2025-11-27','09:00:00'),(1001,103,11,21,'2025-11-27','09:30:00'),(1002,108,11,21,'2025-11-27','10:00:00'),(1003,112,2,11,'2025-11-28','11:00:00'),(1004,116,2,11,'2025-11-29','14:00:00'),(2000,104,1,10,'2025-11-25','23:00:00'),(2001,104,7,13,'2025-11-26','10:00:00'),(2002,110,1,10,'2025-11-24','22:00:00'),(3000,102,26,40,'2025-11-26','08:30:00'),(3001,105,10,20,'2025-11-26','09:00:00'),(3002,113,10,20,'2025-11-26','09:30:00'),(3003,118,18,20,'2025-11-26','10:00:00'),(4000,111,19,30,'2025-11-22','04:00:00'),(4001,107,19,30,'2025-11-29','10:00:00'),(4002,119,20,31,'2025-11-28','09:00:00'),(4003,115,26,13,'2025-11-27','00:57:00');
/*!40000 ALTER TABLE `ClinicalActivity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContactLocation`
--

DROP TABLE IF EXISTS `ContactLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ContactLocation` (
  `CLID` int NOT NULL,
  `City` varchar(50) DEFAULT NULL,
  `Province` varchar(50) DEFAULT NULL,
  `Street` varchar(100) DEFAULT NULL,
  `Number` varchar(10) DEFAULT NULL,
  `PostalCode` varchar(10) DEFAULT NULL,
  `Phone_Location` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`CLID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContactLocation`
--

LOCK TABLES `ContactLocation` WRITE;
/*!40000 ALTER TABLE `ContactLocation` DISABLE KEYS */;
INSERT INTO `ContactLocation` VALUES (1,'Casablanca','Casa-Settat','Bd Anfa','100','20000','0522111111'),(2,'Casablanca','Casa-Settat','Maarif','Apt 4B','20100','0522222222'),(3,'Rabat','Rabat-Salé','Agdal','Villa 12','10000','0537333333'),(4,'Rabat','Rabat-Salé','Ocean','No 5','10200','0537444444'),(5,'Marrakech','Marrakech-Safi','Gueliz','12','40000','0524555555'),(6,'Marrakech','Marrakech-Safi','Medina','Derb 7','40100','0524666666'),(7,'Fes','Fès-Meknès','Atlas','Villa 8','30000','0535777777'),(8,'Tanger','Tanger-Tetouan','Malabata','Res 3','90000','0539888888');
/*!40000 ALTER TABLE `ContactLocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Covers`
--

DROP TABLE IF EXISTS `Covers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Covers` (
  `IID` int NOT NULL,
  `InsID` int NOT NULL,
  PRIMARY KEY (`IID`,`InsID`),
  KEY `InsID` (`InsID`),
  CONSTRAINT `Covers_ibfk_1` FOREIGN KEY (`IID`) REFERENCES `Patient` (`IID`),
  CONSTRAINT `Covers_ibfk_2` FOREIGN KEY (`InsID`) REFERENCES `Insurance` (`InsID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Covers`
--

LOCK TABLES `Covers` WRITE;
/*!40000 ALTER TABLE `Covers` DISABLE KEYS */;
INSERT INTO `Covers` VALUES (100,1),(108,1),(112,1),(116,1),(101,2),(102,2),(106,2),(107,2),(113,2),(114,2),(118,2),(103,3),(110,3),(119,3),(104,4),(111,4),(117,4),(105,5),(109,5),(115,5);
/*!40000 ALTER TABLE `Covers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Department`
--

DROP TABLE IF EXISTS `Department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Department` (
  `DEP_ID` int NOT NULL,
  `HID` int NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Specialty` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`DEP_ID`),
  KEY `HID` (`HID`),
  CONSTRAINT `Department_ibfk_1` FOREIGN KEY (`HID`) REFERENCES `Hospital` (`HID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Department`
--

LOCK TABLES `Department` WRITE;
/*!40000 ALTER TABLE `Department` DISABLE KEYS */;
INSERT INTO `Department` VALUES (10,1,'Urgences','Trauma'),(11,1,'Cardiologie','Heart'),(12,1,'Neurologie','Brain'),(13,1,'Orthopédie','Bone'),(20,2,'Pédiatrie','Children'),(21,2,'Endocrinologie','Diabetes'),(22,2,'Dermatologie','Skin'),(23,2,'Ophtalmologie','Eyes'),(30,3,'Maternité','ObGyn'),(31,3,'Oncologie','Cancer'),(32,3,'Gastro','Digestive'),(40,4,'Pneumologie','Lungs'),(41,4,'Radiologie','Imaging'),(42,4,'Psychiatrie','Mental Health'),(50,5,'Médecine Interne','General'),(51,5,'Chirurgie','Surgery');
/*!40000 ALTER TABLE `Department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Emergency`
--

DROP TABLE IF EXISTS `Emergency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Emergency` (
  `CAID` int NOT NULL,
  `TriageLevel` int DEFAULT NULL,
  `Outcome` enum('Discharged','Admitted','Transferred','Deceased') DEFAULT NULL,
  PRIMARY KEY (`CAID`),
  CONSTRAINT `Emergency_ibfk_1` FOREIGN KEY (`CAID`) REFERENCES `ClinicalActivity` (`CAID`) ON DELETE CASCADE,
  CONSTRAINT `Emergency_chk_1` CHECK ((`TriageLevel` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Emergency`
--

LOCK TABLES `Emergency` WRITE;
/*!40000 ALTER TABLE `Emergency` DISABLE KEYS */;
INSERT INTO `Emergency` VALUES (2000,1,'Admitted'),(2002,3,'Discharged'),(4000,2,'Admitted');
/*!40000 ALTER TABLE `Emergency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Expense`
--

DROP TABLE IF EXISTS `Expense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Expense` (
  `ExID` int NOT NULL,
  `Total` decimal(10,2) NOT NULL,
  `InsID` int DEFAULT NULL,
  `CAID` int NOT NULL,
  PRIMARY KEY (`ExID`),
  UNIQUE KEY `CAID` (`CAID`),
  KEY `InsID` (`InsID`),
  CONSTRAINT `Expense_ibfk_1` FOREIGN KEY (`InsID`) REFERENCES `Insurance` (`InsID`) ON DELETE CASCADE,
  CONSTRAINT `Expense_ibfk_2` FOREIGN KEY (`CAID`) REFERENCES `ClinicalActivity` (`CAID`) ON DELETE CASCADE,
  CONSTRAINT `Expense_chk_1` CHECK ((`Total` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Expense`
--

LOCK TABLES `Expense` WRITE;
/*!40000 ALTER TABLE `Expense` DISABLE KEYS */;
INSERT INTO `Expense` VALUES (500,2000.00,4,2000),(501,300.00,3,2002);
/*!40000 ALTER TABLE `Expense` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Have`
--

DROP TABLE IF EXISTS `Have`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Have` (
  `IID` int NOT NULL,
  `CLID` int NOT NULL,
  PRIMARY KEY (`IID`,`CLID`),
  KEY `CLID` (`CLID`),
  CONSTRAINT `Have_ibfk_1` FOREIGN KEY (`IID`) REFERENCES `Patient` (`IID`),
  CONSTRAINT `Have_ibfk_2` FOREIGN KEY (`CLID`) REFERENCES `ContactLocation` (`CLID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Have`
--

LOCK TABLES `Have` WRITE;
/*!40000 ALTER TABLE `Have` DISABLE KEYS */;
INSERT INTO `Have` VALUES (100,1),(101,1),(104,1),(106,1),(119,1),(102,2),(109,2),(118,2),(105,3),(107,3),(117,3),(103,4),(116,4),(108,5),(111,5),(114,5),(110,6),(113,6),(112,7),(115,8);
/*!40000 ALTER TABLE `Have` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Hospital`
--

DROP TABLE IF EXISTS `Hospital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Hospital` (
  `HID` int NOT NULL,
  `Name` varchar(100) NOT NULL,
  `City` varchar(50) NOT NULL,
  `Region` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`HID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Hospital`
--

LOCK TABLES `Hospital` WRITE;
/*!40000 ALTER TABLE `Hospital` DISABLE KEYS */;
INSERT INTO `Hospital` VALUES (1,'CHU Ibn Rochd','Casablanca','Casa-Settat'),(2,'Hôpital Avicenne','Rabat','Rabat-Salé-Kénitra'),(3,'CHU Mohammed VI','Marrakech','Marrakech-Safi'),(4,'CHU Hassan II','Fès','Fès-Meknès'),(5,'Hôpital Mohammed V','Tanger','Tanger-Tetouan');
/*!40000 ALTER TABLE `Hospital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Include`
--

DROP TABLE IF EXISTS `Include`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Include` (
  `PID` int NOT NULL,
  `DrugID` int NOT NULL,
  `Dosage` varchar(100) DEFAULT NULL,
  `Duration` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`PID`,`DrugID`),
  KEY `DrugID` (`DrugID`),
  CONSTRAINT `Include_ibfk_1` FOREIGN KEY (`PID`) REFERENCES `Prescription` (`PID`),
  CONSTRAINT `Include_ibfk_2` FOREIGN KEY (`DrugID`) REFERENCES `Medication` (`DrugID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Include`
--

LOCK TABLES `Include` WRITE;
/*!40000 ALTER TABLE `Include` DISABLE KEYS */;
INSERT INTO `Include` VALUES (1,106,'5mg Daily','30 days'),(1,107,'4mg Daily','30 days'),(2,104,'20U Daily','30 days'),(2,105,'1000mg BID','30 days'),(3,102,'200mg Daily','3 days'),(3,109,'2 Puffs PRN','30 days'),(4,100,'Syrup Q4H','3 days');
/*!40000 ALTER TABLE `Include` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Insurance`
--

DROP TABLE IF EXISTS `Insurance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Insurance` (
  `InsID` int NOT NULL,
  `Type` enum('CNOPS','CNSS','RAMED','Private','None') NOT NULL,
  PRIMARY KEY (`InsID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Insurance`
--

LOCK TABLES `Insurance` WRITE;
/*!40000 ALTER TABLE `Insurance` DISABLE KEYS */;
INSERT INTO `Insurance` VALUES (1,'CNOPS'),(2,'CNSS'),(3,'RAMED'),(4,'Private'),(5,'None');
/*!40000 ALTER TABLE `Insurance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Medication`
--

DROP TABLE IF EXISTS `Medication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Medication` (
  `DrugID` int NOT NULL,
  `Class` varchar(200) DEFAULT NULL,
  `Name` varchar(200) NOT NULL,
  `Form` varchar(200) DEFAULT NULL,
  `Strength` varchar(50) DEFAULT NULL,
  `Manufacturer` varchar(200) DEFAULT NULL,
  `ActiveIngredient` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`DrugID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Medication`
--

LOCK TABLES `Medication` WRITE;
/*!40000 ALTER TABLE `Medication` DISABLE KEYS */;
INSERT INTO `Medication` VALUES (100,'Analgesic','Doliprane','Tablet','1g','Sanofi','Paracetamol'),(101,'Antibiotic','Augmentin','Sachet','1g','GSK','Amox/Clav'),(102,'Antibiotic','Zithromax','Syrup','200mg','Pfizer','Azithromycin'),(103,'NSAID','Voltarene','Injection','75mg','Novartis','Diclofenac'),(104,'Antidiabetic','Insulin Lantus','Pen','100U','Sanofi','Insulin'),(105,'Antidiabetic','Glucophage','Tablet','1000mg','Merck','Metformin'),(106,'Antihypertensive','Triatec','Tablet','5mg','Sanofi','Ramipril'),(107,'Anticoagulant','Sintrom','Tablet','4mg','Novartis','Acenocoumarol'),(108,'PPI','Mopral','Capsule','20mg','AstraZeneca','Omeprazole'),(109,'Bronchodilator','Ventoline','Inhaler','100mcg','GSK','Salbutamol');
/*!40000 ALTER TABLE `Medication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Patient`
--

DROP TABLE IF EXISTS `Patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Patient` (
  `IID` int NOT NULL,
  `CIN` varchar(10) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Birth` date DEFAULT NULL,
  `Sex` enum('M','F') NOT NULL,
  `BloodGroup` enum('A+','A-','B+','B-','O+','O-','AB+','AB-') DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`IID`),
  UNIQUE KEY `CIN` (`CIN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Patient`
--

LOCK TABLES `Patient` WRITE;
/*!40000 ALTER TABLE `Patient` DISABLE KEYS */;
INSERT INTO `Patient` VALUES (100,'A100','Ahmed Benali','1960-01-01','M','A+','0600000001',NULL),(101,'B200','Fatima Zohra','1985-05-05','F','O+','0600000002','fz@mail.com'),(102,'C300','Yassir Tazi','2015-06-06','M','B-','0600000003',NULL),(103,'D400','Haja Khadija','1945-12-12','F','AB+','0600000004',NULL),(104,'E500','Karim Bouanani','1992-11-20','M','O-','0600000005','kb@tech.ma'),(105,'F600','Salma Bennani','2024-02-01','F','A+','0600000006',NULL),(106,'G700','Mourad Chraibi','1978-08-08','M','B+','0600000007','mc@bank.ma'),(107,'H800','Nadia Fassi','1990-02-14','F','A-','0600000008','nf@arch.ma'),(108,'I900','Hicham Zenati','1965-03-30','M','AB-','0600000009','hz@gov.ma'),(109,'J101','Rania Mansouri','2005-07-07','F','O+','0600000010','rm@uni.ma'),(110,'K112','Othmane Bakkali','1999-09-09','M','B-','0600000011',NULL),(111,'L223','Zineb Daoudi','1995-04-04','F','A+','0600000012','zd@hr.ma'),(112,'M334','Driss Alaoui','1955-10-10','M','O-','0600000013',NULL),(113,'N445','Layla Amrani','2018-12-25','F','AB+','0600000014',NULL),(114,'O556','Mehdi Jettou','1983-01-20','M','A-','0600000015','mj@chef.ma'),(115,'P667','Soukaina Belhaj','2000-11-11','F','B+','0600000016',NULL),(116,'Q778','Anas Harrak','1970-07-01','M','O+','0600000017','ah@transport.ma'),(117,'R889','Meryem Sbihi','1988-05-15','F','AB-','0600000018','ms@lawyer.ma'),(118,'S990','Youssef Akchour','2010-09-20','M','A+','0600000019',NULL),(119,'T001','Latifa Kabbaj','1962-02-28','F','B-','0600000020',NULL);
/*!40000 ALTER TABLE `Patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Practitioner`
--

DROP TABLE IF EXISTS `Practitioner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Practitioner` (
  `STAFF_ID` int NOT NULL,
  `LicenseNumber` varchar(100) DEFAULT NULL,
  `Speciality` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`STAFF_ID`),
  CONSTRAINT `Practitioner_ibfk_1` FOREIGN KEY (`STAFF_ID`) REFERENCES `Staff` (`STAFF_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Practitioner`
--

LOCK TABLES `Practitioner` WRITE;
/*!40000 ALTER TABLE `Practitioner` DISABLE KEYS */;
INSERT INTO `Practitioner` VALUES (1,'MED-001','Trauma'),(2,'MED-002','Cardiology'),(3,'MED-003','Neurology'),(7,'MED-007','Orthopedics'),(10,'MED-010','Pediatrics'),(11,'MED-011','Endocrinology'),(12,'MED-012','Dermatology'),(15,'MED-015','Ophthalmology'),(18,'MED-018','Pediatrics'),(19,'MED-019','ObGyn'),(20,'MED-020','Oncology'),(21,'MED-021','Gastroenterology'),(25,'MED-025','Oncology'),(26,'MED-026','Pulmonology'),(29,'MED-029','Psychiatry');
/*!40000 ALTER TABLE `Practitioner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Prescription`
--

DROP TABLE IF EXISTS `Prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Prescription` (
  `PID` int NOT NULL,
  `DateIssued` date NOT NULL,
  `CAID` int NOT NULL,
  PRIMARY KEY (`PID`),
  UNIQUE KEY `CAID` (`CAID`),
  CONSTRAINT `Prescription_ibfk_1` FOREIGN KEY (`CAID`) REFERENCES `ClinicalActivity` (`CAID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Prescription`
--

LOCK TABLES `Prescription` WRITE;
/*!40000 ALTER TABLE `Prescription` DISABLE KEYS */;
INSERT INTO `Prescription` VALUES (1,'2025-11-27',1000),(2,'2025-11-27',1001),(3,'2025-11-26',3000),(4,'2025-11-26',3001);
/*!40000 ALTER TABLE `Prescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Staff`
--

DROP TABLE IF EXISTS `Staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Staff` (
  `STAFF_ID` int NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `Status` enum('Active','Retired') DEFAULT 'Active',
  PRIMARY KEY (`STAFF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Staff`
--

LOCK TABLES `Staff` WRITE;
/*!40000 ALTER TABLE `Staff` DISABLE KEYS */;
INSERT INTO `Staff` VALUES (1,'Dr. Youssef El Fassi','Active'),(2,'Dr. Leila Berrada','Active'),(3,'Dr. Mehdi Bennani','Active'),(4,'Nurse Salma Tazi','Active'),(5,'Nurse Omar Kabbaj','Active'),(6,'Tech Ahmed Radi','Active'),(7,'Dr. Karim Chraibi','Active'),(8,'Nurse Hajar Skalli','Active'),(9,'Tech Bilal Zeryouh','Active'),(10,'Dr. Houda Tazi','Active'),(11,'Dr. Nabil Daoudi','Active'),(12,'Dr. Asmaa Chaoui','Active'),(13,'Nurse Fatima Zahra','Active'),(14,'Nurse Said Moutaouakil','Active'),(15,'Dr. Rania Mansouri','Active'),(16,'Tech Khalid Jbari','Active'),(17,'Nurse Latifa Sbihi','Active'),(18,'Dr. Redouane Aouad','Active'),(19,'Dr. Samira Alami','Active'),(20,'Dr. Rachid Naciri','Active'),(21,'Dr. Meryem Akchour','Active'),(22,'Nurse Ilham Ziani','Active'),(23,'Nurse Mouad Harrak','Active'),(24,'Tech Soukaina Belhaj','Active'),(25,'Dr. Fouad Zenati','Active'),(26,'Dr. Hicham Amrani','Active'),(27,'Nurse Oussama Fassi','Active'),(28,'Tech Sanae Mrabet','Active'),(29,'Dr. Zineb Jettou','Active'),(30,'Nurse Rim Taoufik','Active');
/*!40000 ALTER TABLE `Staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stock`
--

DROP TABLE IF EXISTS `Stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stock` (
  `HID` int NOT NULL,
  `DrugID` int NOT NULL,
  `Unit_Price` decimal(10,2) DEFAULT NULL,
  `StockTimestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Qty` int DEFAULT '0',
  `ReorderLevel` int DEFAULT '10',
  PRIMARY KEY (`HID`,`DrugID`,`StockTimestamp`),
  KEY `DrugID` (`DrugID`),
  CONSTRAINT `Stock_ibfk_1` FOREIGN KEY (`HID`) REFERENCES `Hospital` (`HID`),
  CONSTRAINT `Stock_ibfk_2` FOREIGN KEY (`DrugID`) REFERENCES `Medication` (`DrugID`),
  CONSTRAINT `Stock_chk_1` CHECK ((`Unit_Price` >= 0)),
  CONSTRAINT `Stock_chk_2` CHECK ((`Qty` >= 0)),
  CONSTRAINT `Stock_chk_3` CHECK ((`ReorderLevel` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stock`
--

LOCK TABLES `Stock` WRITE;
/*!40000 ALTER TABLE `Stock` DISABLE KEYS */;
INSERT INTO `Stock` VALUES (1,100,15.00,'2025-11-27 00:38:05',500,50),(1,103,60.00,'2025-11-27 00:38:05',10,20),(1,107,30.00,'2025-11-27 00:38:05',100,20),(2,101,120.00,'2025-11-27 00:38:05',5,20),(2,104,350.00,'2025-11-27 00:38:05',200,50),(2,105,40.00,'2025-11-27 00:38:05',500,100),(3,100,15.00,'2025-11-27 00:38:05',0,100),(3,108,80.00,'2025-11-27 00:38:05',150,40),(4,102,90.00,'2025-11-27 00:38:05',8,30),(4,109,50.00,'2025-11-27 00:38:05',200,50);
/*!40000 ALTER TABLE `Stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Technical`
--

DROP TABLE IF EXISTS `Technical`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Technical` (
  `STAFF_ID` int NOT NULL,
  `Certifications` varchar(500) DEFAULT NULL,
  `Modality` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`STAFF_ID`),
  CONSTRAINT `Technical_ibfk_1` FOREIGN KEY (`STAFF_ID`) REFERENCES `Staff` (`STAFF_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Technical`
--

LOCK TABLES `Technical` WRITE;
/*!40000 ALTER TABLE `Technical` DISABLE KEYS */;
INSERT INTO `Technical` VALUES (6,'Radio-X','MRI'),(9,'Ortho-Tech','Casting'),(16,'Lab-Bio','Analysis'),(24,'Radio-X','CT Scan'),(28,'Radio-X','X-Ray');
/*!40000 ALTER TABLE `Technical` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Work_in`
--

DROP TABLE IF EXISTS `Work_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Work_in` (
  `STAFF_ID` int NOT NULL,
  `DEP_ID` int NOT NULL,
  PRIMARY KEY (`STAFF_ID`,`DEP_ID`),
  KEY `DEP_ID` (`DEP_ID`),
  CONSTRAINT `Work_in_ibfk_1` FOREIGN KEY (`STAFF_ID`) REFERENCES `Staff` (`STAFF_ID`),
  CONSTRAINT `Work_in_ibfk_2` FOREIGN KEY (`DEP_ID`) REFERENCES `Department` (`DEP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Work_in`
--

LOCK TABLES `Work_in` WRITE;
/*!40000 ALTER TABLE `Work_in` DISABLE KEYS */;
INSERT INTO `Work_in` VALUES (1,10),(4,10),(2,11),(5,11),(6,11),(3,12),(7,13),(8,13),(9,13),(10,20),(13,20),(18,20),(11,21),(14,21),(16,21),(12,22),(17,22),(15,23),(19,30),(22,30),(20,31),(23,31),(24,31),(25,31),(21,32),(26,40),(27,40),(28,41),(29,42),(30,42);
/*!40000 ALTER TABLE `Work_in` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-27  8:49:12

SET FOREIGN_KEY_CHECKS = 1;
