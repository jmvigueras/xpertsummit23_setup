SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+01:00";

CREATE DATABASE IF NOT EXISTS students;
USE students;
DROP TABLE IF EXISTS students;
CREATE TABLE `students` (
  `user_id` varchar(255) COLLATE latin1_spanish_ci NOT NULL,
  `user_sort` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `server_ip` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `email` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `access_key` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `secret_key` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `user_password` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `externalid_token` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `accountid` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `region` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `region_az1` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `vpc_cidr` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `server_test` tinyint(1) DEFAULT '0',
  `server_check` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `cloud9_url` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `hub_fgt_pip` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `user_forticloud` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `pass_forticloud` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  `account_forticloud` varchar(255) COLLATE latin1_spanish_ci DEFAULT NULL,
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;
