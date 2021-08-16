-- MySQL dump 10.13  Distrib 8.0.26, for Linux (x86_64)
--
-- Host: localhost    Database: final_proj_db
-- ------------------------------------------------------
-- Server version	8.0.26-0ubuntu0.20.04.2

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
-- Table structure for table `commentHashtag`
--

DROP TABLE IF EXISTS `commentHashtag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commentHashtag` (
  `commentHashtagId` int NOT NULL AUTO_INCREMENT,
  `commentTweetId` int DEFAULT NULL,
  `hashtagId` int DEFAULT NULL,
  `dtm_crt` date NOT NULL,
  PRIMARY KEY (`commentHashtagId`),
  KEY `hashtagId` (`hashtagId`),
  KEY `commentHashtagFK` (`commentTweetId`),
  CONSTRAINT `commentHashtag_ibfk_2` FOREIGN KEY (`hashtagId`) REFERENCES `hashtags` (`hashtagId`) ON UPDATE CASCADE,
  CONSTRAINT `commentHashtagFK` FOREIGN KEY (`commentTweetId`) REFERENCES `commenttweets` (`commentTweetId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commentHashtag`
--

LOCK TABLES `commentHashtag` WRITE;
/*!40000 ALTER TABLE `commentHashtag` DISABLE KEYS */;
INSERT INTO `commentHashtag` VALUES (1,8,12,'2021-08-13'),(4,13,5,'2021-08-15');
/*!40000 ALTER TABLE `commentHashtag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commenttweets`
--

DROP TABLE IF EXISTS `commenttweets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commenttweets` (
  `commentTweetId` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `tweetId` int DEFAULT NULL,
  `comment_tweet` longtext,
  `dtm_crt` date NOT NULL,
  `attachment` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`commentTweetId`),
  KEY `userId` (`userId`),
  KEY `tweetId` (`tweetId`),
  CONSTRAINT `commenttweets_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON UPDATE CASCADE,
  CONSTRAINT `tweetFK` FOREIGN KEY (`tweetId`) REFERENCES `tweets` (`tweetId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commenttweets`
--

LOCK TABLES `commenttweets` WRITE;
/*!40000 ALTER TABLE `commenttweets` DISABLE KEYS */;
INSERT INTO `commenttweets` VALUES (6,2,1,'Lorem Ipsum apaan cuk !?!?!?!','2021-08-13',NULL),(8,1,1,'baca di internet sat!!! @MusuhOrmas21','2021-08-13',NULL),(12,2,16,'HUWAAAAWWWW','2021-08-14','/transaction/majelis-lucu.gif'),(13,1,17,'hadeuuuh!!!','2021-08-15','/transaction/blok-blok.gif');
/*!40000 ALTER TABLE `commenttweets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `followers`
--

DROP TABLE IF EXISTS `followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `followers` (
  `followersId` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `userFollowersId` int NOT NULL,
  `dtm_crt` date NOT NULL,
  PRIMARY KEY (`followersId`),
  KEY `userId` (`userId`),
  CONSTRAINT `followers_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `followers`
--

LOCK TABLES `followers` WRITE;
/*!40000 ALTER TABLE `followers` DISABLE KEYS */;
INSERT INTO `followers` VALUES (6,2,1,'2021-08-14'),(7,1,2,'2021-08-14');
/*!40000 ALTER TABLE `followers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hashtags`
--

DROP TABLE IF EXISTS `hashtags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hashtags` (
  `hashtagId` int NOT NULL AUTO_INCREMENT,
  `hashtagName` varchar(50) DEFAULT NULL,
  `dtm_crt` date NOT NULL,
  PRIMARY KEY (`hashtagId`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hashtags`
--

LOCK TABLES `hashtags` WRITE;
/*!40000 ALTER TABLE `hashtags` DISABLE KEYS */;
INSERT INTO `hashtags` VALUES (5,'ppkm','2021-08-13'),(6,'bosen','2021-08-13'),(7,'ngoding','2021-08-13'),(8,'holiday','2021-08-13'),(12,'haduh','2021-08-13'),(13,'ckuaks','2021-08-13'),(14,'pemudatersesat','2021-08-13'),(15,'astagfirullah','2021-08-13'),(16,'letih','2021-08-14'),(17,'murahbanget','2021-08-14'),(18,'mina','2021-08-15'),(19,'twice','2021-08-15');
/*!40000 ALTER TABLE `hashtags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `liketweets`
--

DROP TABLE IF EXISTS `liketweets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liketweets` (
  `likeTweetId` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `tweetId` int DEFAULT NULL,
  `dtm_crt` date NOT NULL,
  PRIMARY KEY (`likeTweetId`),
  KEY `userId` (`userId`),
  KEY `tweetId` (`tweetId`),
  CONSTRAINT `liketweetFK` FOREIGN KEY (`tweetId`) REFERENCES `tweets` (`tweetId`) ON DELETE CASCADE,
  CONSTRAINT `liketweets_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `liketweets`
--

LOCK TABLES `liketweets` WRITE;
/*!40000 ALTER TABLE `liketweets` DISABLE KEYS */;
INSERT INTO `liketweets` VALUES (1,2,1,'2021-08-12'),(20,1,1,'2021-08-13'),(26,2,3,'2021-08-13');
/*!40000 ALTER TABLE `liketweets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `followersId` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `tweetId` int DEFAULT NULL,
  `created_by` int NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `redirect` varchar(200) DEFAULT NULL,
  `read_nofif` varchar(6) DEFAULT NULL,
  `dtm_crt` date NOT NULL,
  PRIMARY KEY (`followersId`),
  KEY `userId` (`userId`),
  KEY `tweetId` (`tweetId`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON UPDATE CASCADE,
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`tweetId`) REFERENCES `tweets` (`tweetId`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tweetHashtag`
--

DROP TABLE IF EXISTS `tweetHashtag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tweetHashtag` (
  `tweetHashtagId` int NOT NULL AUTO_INCREMENT,
  `tweetId` int DEFAULT NULL,
  `hashtagId` int DEFAULT NULL,
  `dtm_crt` date NOT NULL,
  PRIMARY KEY (`tweetHashtagId`),
  KEY `hashtagId` (`hashtagId`),
  KEY `tweetHashtagFK` (`tweetId`),
  CONSTRAINT `tweetHashtag_ibfk_2` FOREIGN KEY (`hashtagId`) REFERENCES `hashtags` (`hashtagId`) ON UPDATE CASCADE,
  CONSTRAINT `tweetHashtagFK` FOREIGN KEY (`tweetId`) REFERENCES `tweets` (`tweetId`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tweetHashtag`
--

LOCK TABLES `tweetHashtag` WRITE;
/*!40000 ALTER TABLE `tweetHashtag` DISABLE KEYS */;
INSERT INTO `tweetHashtag` VALUES (1,7,5,'2021-08-13'),(2,7,6,'2021-08-13'),(3,7,7,'2021-08-13'),(4,8,5,'2021-08-13'),(5,8,8,'2021-08-13'),(6,9,5,'2021-08-13'),(7,10,14,'2021-08-13'),(8,10,15,'2021-08-13'),(10,16,17,'2021-08-14'),(11,17,13,'2021-08-14');
/*!40000 ALTER TABLE `tweetHashtag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tweets`
--

DROP TABLE IF EXISTS `tweets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tweets` (
  `tweetId` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `content` longtext,
  `attachment` varchar(1000) DEFAULT NULL,
  `dtm_crt` date DEFAULT NULL,
  PRIMARY KEY (`tweetId`),
  KEY `userId` (`userId`),
  CONSTRAINT `tweets_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tweets`
--

LOCK TABLES `tweets` WRITE;
/*!40000 ALTER TABLE `tweets` DISABLE KEYS */;
INSERT INTO `tweets` VALUES (1,1,'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.  ',NULL,'2021-08-12'),(3,1,'final projeknya susah nih hehehe.....bantuin dong :)',NULL,'2021-08-13'),(7,1,'ngetes aja kok, nggak macem\"',NULL,'2021-08-13'),(8,1,'What is Happening today!?!?!?',NULL,'2021-08-13'),(9,1,'Haus :\")',NULL,'2021-08-13'),(10,2,'Tersesaaaattt!!!....Oh tersesaaattttt!!!!....Astagfirullah!!!!',NULL,'2021-08-13'),(16,2,'Asli, Mobil gw bagus banget!!!!','/transaction/1140-classic-car-safety.imgcache.rev.web.1100.633.jpg','2021-08-14'),(17,2,'Untuk pertama kalinya diselenggarakan lomba makan cepat dengan durasi maksimum 20 menit serempak tingkat nasional......','/transaction/makan.JPG','2021-08-14');
/*!40000 ALTER TABLE `tweets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userId` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(30) NOT NULL,
  `username` varchar(30) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(50) NOT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `profile_pic` varchar(255) DEFAULT NULL,
  `role` varchar(10) DEFAULT NULL,
  `dtm_crt` date DEFAULT NULL,
  `description` longtext,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Diaz Ilyasa','diazware12','diazilyasa987@gmail.com','diazware12','Male','/transaction/1-diazware12.jpg','User','2021-08-12','Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod'),(2,'Tretan Muslim','MusuhOrmas21','tretangaming23@gmail.com','MusuhOrmas2021','Male','/transaction/2-MusuhOrmas21.jpg','User','2021-08-12',NULL),(3,'Coki Pardede','PemudaTersesat666','SonsOfHorus666@gmail.com','moonwalker98','Male','/transaction/3-PemudaTersesat666.jpg','User','2021-08-15',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-08-16  0:29:12
