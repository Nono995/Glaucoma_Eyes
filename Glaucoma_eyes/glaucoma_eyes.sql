-- --------------------------------------------------------
-- Hôte:                         127.0.0.1
-- Version du serveur:           5.7.33 - MySQL Community Server (GPL)
-- SE du serveur:                Win64
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Listage de la structure de la base pour glaucoma_eyes
CREATE DATABASE IF NOT EXISTS `glaucoma_eyes` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `glaucoma_eyes`;

-- Listage de la structure de la table glaucoma_eyes. antecedent
CREATE TABLE IF NOT EXISTS `antecedent` (
  `Id_Ante` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Patient` int(11) DEFAULT NULL,
  `Ante_oph` varchar(50) DEFAULT NULL,
  `Ante_med` varchar(50) DEFAULT NULL,
  `Ante_familliaux` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id_Ante`),
  KEY `FK_antecedent_patients` (`ID_Patient`),
  CONSTRAINT `FK_antecedent_patients` FOREIGN KEY (`ID_Patient`) REFERENCES `patients` (`ID_Pat`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.antecedent : ~2 rows (environ)
/*!40000 ALTER TABLE `antecedent` DISABLE KEYS */;
INSERT INTO `antecedent` (`Id_Ante`, `ID_Patient`, `Ante_oph`, `Ante_med`, `Ante_familliaux`) VALUES
	(9, 5, 'myopie', 'hypertonie', 'glaucome au niveaux du pere'),
	(12, 5, 'myopie', 'hypertonie', 'glaucome au niveaux du pere'),
	(13, 14, 'glaucome', 'palu', 'none'),
	(14, 15, 'oui', 'oui', 'oui');
/*!40000 ALTER TABLE `antecedent` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. consultation
CREATE TABLE IF NOT EXISTS `consultation` (
  `ID_Cons` int(11) NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `ID_Patient` int(11) DEFAULT NULL,
  `ID_Med` int(11) DEFAULT NULL,
  `Motif` varchar(50) DEFAULT NULL,
  `Resultat` varchar(50) DEFAULT NULL,
  `Observation` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_Cons`),
  KEY `FK_consultation_patients` (`ID_Patient`),
  KEY `FK_consultation_medecins` (`ID_Med`),
  CONSTRAINT `FK_consultation_medecins` FOREIGN KEY (`ID_Med`) REFERENCES `medecins` (`ID_Med`),
  CONSTRAINT `FK_consultation_patients` FOREIGN KEY (`ID_Patient`) REFERENCES `patients` (`ID_Pat`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.consultation : ~0 rows (environ)
/*!40000 ALTER TABLE `consultation` DISABLE KEYS */;
INSERT INTO `consultation` (`ID_Cons`, `date`, `ID_Patient`, `ID_Med`, `Motif`, `Resultat`, `Observation`) VALUES
	(1, '2020-11-01', 5, 2, 'mal aux yeux', 'mal aux yeux', 'hdfvb');
/*!40000 ALTER TABLE `consultation` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. consultation_patient
CREATE TABLE IF NOT EXISTS `consultation_patient` (
  `ID_PARA` int(11) DEFAULT NULL,
  `predictionG` varchar(50) DEFAULT NULL,
  `predictionD` varchar(50) DEFAULT NULL,
  `Diagnostics` varchar(50) DEFAULT NULL,
  `observation` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `ClassG` varchar(50) DEFAULT NULL,
  `ClassD` varchar(50) DEFAULT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`),
  KEY `FK_consultation_patient_parametremedicaux` (`ID_PARA`),
  CONSTRAINT `FK_consultation_patient_parametremedicaux` FOREIGN KEY (`ID_PARA`) REFERENCES `parametremedicaux` (`ID_Parametre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.consultation_patient : ~3 rows (environ)
/*!40000 ALTER TABLE `consultation_patient` DISABLE KEYS */;
INSERT INTO `consultation_patient` (`ID_PARA`, `predictionG`, `predictionD`, `Diagnostics`, `observation`, `date`, `ClassG`, `ClassD`, `ID`) VALUES
	(7, '96.06567025184631', '', 'glo', 'malade', '2022-11-23 18:41:8', 'Non Glaucome', 'Glaucome', 1),
	(13, '53.33718657493591', '', 'd', 'ds', '2022-11-27 17:18:4', 'Glaucome', 'Glaucome', 2),
	(13, '53.33718657493591', '', 'd', 'ds', '2022-11-27 17:18:4', 'Glaucome', 'Glaucome', 3);
/*!40000 ALTER TABLE `consultation_patient` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. images
CREATE TABLE IF NOT EXISTS `images` (
  `ID_image` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Cons` int(11) DEFAULT NULL,
  `Nom` varchar(50) DEFAULT NULL,
  `repertoire` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_image`),
  KEY `FK_images_consultation` (`ID_Cons`),
  CONSTRAINT `FK_images_consultation` FOREIGN KEY (`ID_Cons`) REFERENCES `consultation` (`ID_Cons`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.images : ~0 rows (environ)
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
/*!40000 ALTER TABLE `images` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. image_oeil
CREATE TABLE IF NOT EXISTS `image_oeil` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ID_parametre` int(11) DEFAULT NULL,
  `repertoireG` varchar(50) DEFAULT NULL,
  `repertoireD` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK__parametremedicaux` (`ID_parametre`),
  CONSTRAINT `FK__parametremedicaux` FOREIGN KEY (`ID_parametre`) REFERENCES `parametremedicaux` (`ID_Parametre`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.image_oeil : ~63 rows (environ)
/*!40000 ALTER TABLE `image_oeil` DISABLE KEYS */;
INSERT INTO `image_oeil` (`id`, `ID_parametre`, `repertoireG`, `repertoireD`) VALUES
	(2, 6, '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg', '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg'),
	(3, 6, '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg', '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg'),
	(4, 6, '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg', '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg'),
	(5, 6, '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg', '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg'),
	(6, 6, '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg', '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg'),
	(7, 6, '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg', '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg'),
	(8, 6, '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg', '/image/e.jpg'),
	(9, 7, '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg', '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg'),
	(10, 7, '/image/564.png', '/image/557.png'),
	(11, 8, '/image/557.png', '/image/569.png'),
	(12, 8, '/image/569.png', '/image/628.png'),
	(13, 8, '/image/564.png', '/image/569.png'),
	(14, 8, '/image/569.png', '/image/557.png'),
	(15, 8, '/image/557.png', '/image/557.png'),
	(16, 8, '/image/569.png', '/image/569.png'),
	(17, 8, '/image/564.png', '/image/557.png'),
	(18, 8, '/image/564.png', '/image/557.png'),
	(19, 8, '/image/569.png', '/image/569.png'),
	(20, 8, '/image/557.png', '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg'),
	(21, 8, '/image/564.png', '/image/628.png'),
	(22, 8, '/image/557.png', '/image/569.png'),
	(23, 8, '/image/628.png', '/image/569.png'),
	(24, 8, '/image/628.png', '/image/569.png'),
	(25, 8, '/image/557.png', '/image/628.png'),
	(26, 8, '/image/564.png', '/image/557.png'),
	(27, 8, '/image/557.png', '/image/628.png'),
	(28, 8, '/image/557.png', '/image/628.png'),
	(29, 8, '/image/557.png', '/image/628.png'),
	(30, 8, '/image/557.png', '/image/628.png'),
	(31, 8, '/image/557.png', '/image/628.png'),
	(32, 8, '/image/e.jpg', '/image/569.png'),
	(33, 8, '/image/564.png', '/image/557.png'),
	(34, 8, '/image/564.png', '/image/557.png'),
	(35, 8, '/image/564.png', '/image/557.png'),
	(36, 8, '/image/564.png', '/image/557.png'),
	(37, 8, '/image/564.png', '/image/557.png'),
	(38, 8, '/image/564.png', '/image/557.png'),
	(39, 8, '/image/564.png', '/image/557.png'),
	(40, 8, '/image/564.png', '/image/557.png'),
	(41, 8, '/image/564.png', '/image/557.png'),
	(42, 8, '/image/564.png', '/image/557.png'),
	(43, 8, '/image/564.png', '/image/557.png'),
	(44, 8, '/image/564.png', '/image/557.png'),
	(45, 8, '/image/564.png', '/image/557.png'),
	(46, 8, '/image/564.png', '/image/557.png'),
	(47, 8, '/image/564.png', '/image/557.png'),
	(48, 8, '/image/564.png', '/image/557.png'),
	(49, 8, '/image/564.png', '/image/557.png'),
	(50, 8, '/image/564.png', '/image/557.png'),
	(51, 9, '/image/628.png', '/image/569.png'),
	(52, 9, '/image/628.png', '/image/569.png'),
	(53, 9, '/image/628.png', '/image/569.png'),
	(54, 11, '/image/557.png', '/image/569.png'),
	(55, 11, '/image/557.png', '/image/628.png'),
	(56, 11, '/image/564.png', '/image/569.png'),
	(57, 11, '/image/564.png', '/image/569.png'),
	(58, 11, '/image/564.png', '/image/569.png'),
	(59, 11, '/image/564.png', '/image/569.png'),
	(60, 11, '/image/564.png', '/image/569.png'),
	(61, 11, '/image/564.png', '/image/569.png'),
	(62, 11, '/image/564.png', '/image/569.png'),
	(63, 11, '/image/564.png', '/image/569.png'),
	(64, 11, '/image/564.png', '/image/569.png'),
	(65, 11, '/image/564.png', '/image/569.png'),
	(66, 11, '/image/557.png', '/image/569.png'),
	(67, 13, '/image/628.png', '/image/569.png'),
	(68, 13, '/image/557.png', '/image/628.png'),
	(69, 13, '/image/628.png', '/image/569.png'),
	(70, 13, '/image/628.png', '/image/569.png'),
	(71, 15, '/image/628.png', '/image/569.png'),
	(72, 16, '/image/564.png', '/image/557.png'),
	(73, 17, '/image/557.png', '/image/628.png'),
	(74, 17, '/image/557.png', '/image/628.png'),
	(75, 17, '/image/557.png', '/image/628.png'),
	(76, 17, '/image/564.png', '/image/569.png'),
	(77, 17, '/image/564.png', '/image/569.png'),
	(78, 17, '/image/564.png', '/image/569.png'),
	(79, 17, '/image/564.png', '/image/569.png'),
	(80, 17, '/image/564.png', '/image/569.png'),
	(81, 17, '/image/564.png', '/image/569.png'),
	(82, 17, '/image/564.png', '/image/569.png'),
	(83, 17, '/image/564.png', '/image/569.png'),
	(84, 17, '/image/564.png', '/image/569.png'),
	(85, 17, '/image/564.png', '/image/569.png'),
	(86, 17, '/image/564.png', '/image/569.png'),
	(87, 17, '/image/564.png', '/image/569.png'),
	(88, 17, '/image/564.png', '/image/569.png'),
	(89, 17, '/image/564.png', '/image/569.png'),
	(90, 17, '/image/564.png', '/image/569.png'),
	(91, 17, '/image/564.png', '/image/569.png'),
	(92, 17, '/image/564.png', '/image/569.png'),
	(93, 17, '/image/564.png', '/image/569.png'),
	(94, 17, '/image/628.png', '/image/569.png'),
	(95, 17, '/image/628.png', '/image/569.png'),
	(96, 17, '/image/628.png', '/image/569.png'),
	(97, 17, '/image/628.png', '/image/569.png'),
	(98, 17, '/image/628.png', '/image/569.png'),
	(99, 17, '/image/557.png', '/image/569.png'),
	(100, 17, '/image/557.png', '/image/569.png'),
	(101, 17, '/image/557.png', '/image/628.png'),
	(102, 17, '/image/557.png', '/image/628.png'),
	(103, 17, '/image/557.png', '/image/628.png'),
	(104, 17, '/image/557.png', '/image/628.png'),
	(105, 17, '/image/557.png', '/image/628.png'),
	(106, 17, '/image/557.png', '/image/628.png'),
	(107, 17, '/image/557.png', '/image/628.png'),
	(108, 17, '/image/628.png', '/image/569.png'),
	(109, 17, '/image/628.png', '/image/569.png'),
	(110, 17, '/image/557.png', '/image/564.png'),
	(111, 17, '/image/557.png', '/image/564.png'),
	(112, 17, '/image/557.png', '/image/564.png'),
	(113, 17, '/image/557.png', '/image/564.png'),
	(114, 17, '/image/569.png', '/image/628.png'),
	(115, 17, '/image/569.png', '/image/628.png'),
	(116, 17, '/image/569.png', '/image/628.png'),
	(117, 17, '/image/569.png', '/image/628.png'),
	(118, 17, '/image/569.png', '/image/628.png'),
	(119, 17, '/image/557.png', '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg'),
	(120, 17, '/image/557.png', '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg'),
	(121, 17, '/image/564.png', '/image/557.png'),
	(122, 17, '/image/564.png', '/image/557.png'),
	(123, 17, '/image/564.png', '/image/557.png'),
	(124, 17, '/image/564.png', '/image/557.png'),
	(125, 17, '/image/564.png', '/image/557.png'),
	(126, 17, '/image/564.png', '/image/557.png'),
	(127, 17, '/image/564.png', '/image/557.png'),
	(128, 17, '/image/557.png', '/image/564.png'),
	(129, 17, '/image/557.png', '/image/564.png'),
	(130, 17, '/image/557.png', '/image/564.png'),
	(131, 17, '/image/557.png', '/image/564.png'),
	(132, 17, '/image/557.png', '/image/564.png'),
	(133, 17, '/image/557.png', '/image/564.png'),
	(134, 17, '/image/557.png', '/image/564.png'),
	(135, 17, '/image/557.png', '/image/564.png'),
	(136, 17, '/image/564.png', '/image/557.png'),
	(137, 17, '/image/564.png', '/image/557.png'),
	(138, 17, '/image/564.png', '/image/564.png'),
	(139, 17, '/image/628.png', '/image/569.png'),
	(140, 17, '/image/628.png', '/image/569.png'),
	(141, 17, '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg', '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg'),
	(142, 17, '/image/2ASQ6YWN3BVEEZNW_0234_00.jpg', '/image/2ASQ6YWN3BVEEZX0_0234_00.jpg');
/*!40000 ALTER TABLE `image_oeil` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. medecins
CREATE TABLE IF NOT EXISTS `medecins` (
  `ID_Med` int(11) NOT NULL AUTO_INCREMENT,
  `Nom_Med` varchar(200) NOT NULL,
  `Prenom_Med` varchar(200) DEFAULT NULL,
  `Tel_Med` varchar(10) DEFAULT NULL,
  `Email_Med` varchar(50) NOT NULL,
  `Profile_Med` varchar(10) NOT NULL DEFAULT 'med',
  `Mdp_Med` varchar(50) NOT NULL,
  PRIMARY KEY (`ID_Med`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.medecins : ~2 rows (environ)
/*!40000 ALTER TABLE `medecins` DISABLE KEYS */;
INSERT INTO `medecins` (`ID_Med`, `Nom_Med`, `Prenom_Med`, `Tel_Med`, `Email_Med`, `Profile_Med`, `Mdp_Med`) VALUES
	(1, 'admin', 'None', 'fghghghg', 'admin@gmail.com', 'admin', 'admin'),
	(2, 'esgniole', NULL, NULL, 'clover.com', 'med', 'clover');
/*!40000 ALTER TABLE `medecins` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. parametremedicaux
CREATE TABLE IF NOT EXISTS `parametremedicaux` (
  `ID_PAT` int(11) DEFAULT NULL,
  `ID_Parametre` int(11) NOT NULL AUTO_INCREMENT,
  `ID_MEDECIN` int(11) DEFAULT NULL,
  `date_parametre` datetime NOT NULL,
  `motif` text NOT NULL,
  `tension_arterielle` varchar(50) DEFAULT NULL,
  `poids` varchar(50) DEFAULT NULL,
  `PIOG` varchar(50) DEFAULT NULL,
  `PIOD` varchar(50) DEFAULT NULL,
  `AVG` varchar(50) DEFAULT NULL,
  `AVD` varchar(50) DEFAULT NULL,
  `LAPG` varchar(50) DEFAULT NULL,
  `LAPD` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_Parametre`),
  KEY `FK_parametremedicaux_patients` (`ID_PAT`),
  KEY `FK_parametremedicaux_medecins` (`ID_MEDECIN`),
  CONSTRAINT `FK_parametremedicaux_medecins` FOREIGN KEY (`ID_MEDECIN`) REFERENCES `medecins` (`ID_Med`),
  CONSTRAINT `FK_parametremedicaux_patients` FOREIGN KEY (`ID_PAT`) REFERENCES `patients` (`ID_Pat`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.parametremedicaux : ~10 rows (environ)
/*!40000 ALTER TABLE `parametremedicaux` DISABLE KEYS */;
INSERT INTO `parametremedicaux` (`ID_PAT`, `ID_Parametre`, `ID_MEDECIN`, `date_parametre`, `motif`, `tension_arterielle`, `poids`, `PIOG`, `PIOD`, `AVG`, `AVD`, `LAPG`, `LAPD`) VALUES
	(5, 3, 1, '2021-12-12 23:05:03', 'gfyjgyc', '54', '666', '77', '77', '98', '98', NULL, NULL),
	(14, 6, 1, '2022-11-22 14:35:42', 'mal aux yeux', '43', '67', '9', '6', '8', '6', '9', '7'),
	(15, 7, 1, '2022-11-23 18:17:34', 'mal au yeux', '9', '54', 'bg', 'sd', '455', '223', 'gdd', 'fvf'),
	(6, 8, 1, '2022-11-24 09:41:30', 'malade', '9', '54', 'bg', 'sd', '455', '223', 'gdd', 'fvf'),
	(16, 9, 1, '2022-11-25 14:07:21', 'malade aux yeux', '9', '', '564', '323', '455', '223', '56', '23'),
	(6, 10, 1, '2022-11-25 14:11:27', 'malade aux yeux', '9', '54', '564', '323', '455', '223', '56', '23'),
	(17, 11, 1, '2022-11-25 14:31:43', 'jjjj', '9', '54', '564', '323', '455', '223', '56', '23'),
	(18, 12, 1, '2022-11-25 17:11:53', 'Mal de dos', '9', '56', '564', '323', '455', '223', '56', '23'),
	(6, 13, 1, '2022-11-27 17:16:58', 'Mal aux yeux', '9', '56', '564', '323', '455', '223', '56', '23'),
	(6, 14, 1, '2022-11-27 17:29:41', 'mal aux yeux', '9', '54', '564', '323', '455', '223', '56', '23'),
	(16, 15, 1, '2022-11-27 17:36:49', 'mal au yeux', '9', '54', '564', '323', '455', '223', '56', '23'),
	(20, 16, 1, '2022-11-27 17:44:55', 'Mal a la tete', '9', '54', '564', '323', '455', '223', '56', '23'),
	(20, 17, 1, '2022-11-29 09:50:11', 'MAL', '9', '54', '564', '323', '455', '223', '56', '23');
/*!40000 ALTER TABLE `parametremedicaux` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. patients
CREATE TABLE IF NOT EXISTS `patients` (
  `ID_Pat` int(11) NOT NULL AUTO_INCREMENT,
  `Nom_Pat` varchar(200) DEFAULT NULL,
  `Prenom_Pat` varchar(200) DEFAULT NULL,
  `Epse_Pat` varchar(200) DEFAULT NULL,
  `Sexe_Pat` varchar(10) DEFAULT NULL,
  `DateNais` date DEFAULT NULL,
  `Tel_Pat` varchar(10) DEFAULT NULL,
  `Email_Pat` varchar(50) DEFAULT NULL,
  `LieuNaiss_Pat` varchar(200) DEFAULT NULL,
  `Origin_Pat` varchar(200) DEFAULT NULL,
  `Profession_Pat` varchar(200) DEFAULT NULL,
  `Assurance_Pat` varchar(200) DEFAULT NULL,
  `Adresse_Pat` varchar(200) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_Pat`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.patients : ~9 rows (environ)
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` (`ID_Pat`, `Nom_Pat`, `Prenom_Pat`, `Epse_Pat`, `Sexe_Pat`, `DateNais`, `Tel_Pat`, `Email_Pat`, `LieuNaiss_Pat`, `Origin_Pat`, `Profession_Pat`, `Assurance_Pat`, `Adresse_Pat`, `age`) VALUES
	(5, 'Nenkam', 'kanmagne', NULL, 'Masculin', '1997-05-09', '691666243', 'gospelkuinkam@gmail.comm', NULL, NULL, 'docteur', 'saar', NULL, NULL),
	(6, 'Fogue', 'Zayanne', NULL, 'Feminin', '2021-05-22', '674322453', 'kuinkamyolette@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL),
	(7, 'gospel', 'kuinkam', NULL, 'Feminin', '2021-11-27', '646789ZE', 'kuinkamyolette@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL),
	(8, 'prunela', 'kuinkam', NULL, 'Feminin', '2021-11-10', '43256789', 'pgkuinkam.student@fst.udm.cm', NULL, NULL, NULL, NULL, NULL, NULL),
	(9, 'gospel', 'admin.com', NULL, 'Feminin', '2021-11-27', '43256789', 'admin@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL),
	(14, 'Kuinkam', 'gospel', 'Nenkam', 'Feminin', '1996-02-26', '677899', 'gospelkuinkam@gmail.com', 'Feminin', 'bamileke', 'doctor', 'essaurance', 'MENDONG', NULL),
	(15, 'Nono ', 'brice', 'nono', 'Masculin', '1995-01-31', '678976543', 'nonobrice@gmail.com', 'Masculin', 'ouest', 'maitre', 'eesaar', 'Mfetum', NULL),
	(16, 'Nana', 'brice', 'nono', '1', '2022-11-29', '678976543', 'nonobrice441@gmail.com', '1', 'ouest', 'maitre', 'eesaar', 'Mfetum', 25),
	(17, 'PRUNELA GOSPEL KUINKAM WOUAPI', 'brice', 'vdd', '0', '2022-11-17', '656219952', 'gospelkuinkam@yahoo.com', '0', 'ouest', 'maitre', 'eesaar', 'Mfetum', 25),
	(18, 'Koukam ', 'Nono', 'Nono', 'Masculin', '2022-11-19', '678976543', 'nonobrice@gmail.com', 'Masculin', 'ouest', 'maitre', 'eesaar', 'Mfetum', NULL),
	(19, 'Makou ', 'Tapita', 'Nono', 'Feminin', '2022-11-25', '674734232', 'makoutapita@gmail.com', 'Feminin', 'Bafoussam', 'technicienne', 'cnps', 'Rue2345-beri', NULL),
	(20, 'Koukam ', 'Lionel', 'Nono', '1', '1997-01-08', '698564323', 'koukam@gmail.com', '1', 'Bafoussam', 'Etudiant', 'Cnps', 'Bonaberie', NULL);
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. rendez_vous
CREATE TABLE IF NOT EXISTS `rendez_vous` (
  `ID_rdv` int(11) NOT NULL AUTO_INCREMENT,
  `NomPart_rdv` varchar(200) DEFAULT '0',
  `TelPart_rdv` int(11) DEFAULT NULL,
  `Start_rdv` datetime DEFAULT NULL,
  `End_rdv` datetime DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `Detail_rdv` text,
  PRIMARY KEY (`ID_rdv`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.rendez_vous : ~2 rows (environ)
/*!40000 ALTER TABLE `rendez_vous` DISABLE KEYS */;
INSERT INTO `rendez_vous` (`ID_rdv`, `NomPart_rdv`, `TelPart_rdv`, `Start_rdv`, `End_rdv`, `title`, `Detail_rdv`) VALUES
	(1, 'gospel', 78980, '2022-01-06 09:00:00', '2022-01-06 09:15:00', NULL, 'sqhgqsghs'),
	(2, 'Gospel Kuinkam', 652345399, '2021-12-20 09:45:00', '2021-12-20 10:00:00', NULL, 'Probleme avec monsieur. Refuse de le servir.');
/*!40000 ALTER TABLE `rendez_vous` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. students
CREATE TABLE IF NOT EXISTS `students` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.students : 9 rows
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` (`id`, `name`, `email`, `phone`) VALUES
	(3, 'Parwiz', 'parwiz.f@gmail.com', '009378976767'),
	(4, 'John Doe', 'johndoe@gmail.com', '999999999'),
	(5, 'Karimja', 'ka@gmail.com', '7333392'),
	(6, 'Jamal', 'ja@gmail.com', '3434343'),
	(7, 'Nawid', 'na@gmail.com', '343434'),
	(8, 'Tom Logan', 'Tom@gmail.com', '7347374347'),
	(12, 'Tom Logan', 'tom@gmail.com', '11111111111'),
	(13, 'Fawad', 'fa@gmail.com', '347374837483'),
	(14, 'Wahid', 'wa@gmail.com', '4354354345');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;

-- Listage de la structure de la table glaucoma_eyes. utilisateurs
CREATE TABLE IF NOT EXISTS `utilisateurs` (
  `Username` varchar(50) DEFAULT NULL,
  `Password` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Listage des données de la table glaucoma_eyes.utilisateurs : ~2 rows (environ)
/*!40000 ALTER TABLE `utilisateurs` DISABLE KEYS */;
INSERT INTO `utilisateurs` (`Username`, `Password`) VALUES
	('admin', 'admin'),
	('HH', 'dd');
/*!40000 ALTER TABLE `utilisateurs` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
