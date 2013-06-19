-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 19, 2013 at 04:57 PM
-- Server version: 5.5.29
-- PHP Version: 5.4.6-1ubuntu1.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `nitlab`
--

-- --------------------------------------------------------

--
-- Table structure for table `b9tj1_users`
--

CREATE TABLE IF NOT EXISTS `b9tj1_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(150) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(100) NOT NULL DEFAULT '',
  `usertype` varchar(25) NOT NULL DEFAULT '',
  `block` tinyint(4) NOT NULL DEFAULT '0',
  `sendEmail` tinyint(4) DEFAULT '0',
  `gid` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `registerDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastvisitDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `activation` varchar(100) NOT NULL DEFAULT '',
  `params` text NOT NULL,
  `lastResetTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Date of last password reset',
  `resetCount` int(11) NOT NULL DEFAULT '0' COMMENT 'Count of password resets since lastResetTime',
  `slice_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `usertype` (`usertype`),
  KEY `idx_name` (`name`),
  KEY `idx_block` (`block`),
  KEY `username` (`username`),
  KEY `email` (`email`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1509 ;

-- --------------------------------------------------------

--
-- Table structure for table `node_list`
--

CREATE TABLE IF NOT EXISTS `node_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `floor` int(11) NOT NULL,
  `view` varchar(50) NOT NULL,
  `wall` varchar(50) DEFAULT NULL,
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `z` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=136 ;

-- --------------------------------------------------------

--
-- Table structure for table `node_specs`
--

CREATE TABLE IF NOT EXISTS `node_specs` (
  `id` int(11) NOT NULL,
  `name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `functional` int(11) DEFAULT NULL,
  `cmc_attached` int(11) DEFAULT NULL,
  `cmc_status` int(11) DEFAULT NULL,
  `cmc_version` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `image_load` int(11) DEFAULT NULL,
  `ping` int(11) DEFAULT NULL,
  `CPU` varchar(100) DEFAULT NULL,
  `cores` int(11) DEFAULT NULL,
  `threads` int(11) DEFAULT NULL,
  `L1_KB` float DEFAULT NULL,
  `L2_MB` float DEFAULT NULL,
  `RAM_GB` float DEFAULT NULL,
  `RAM_type` varchar(17) DEFAULT NULL,
  `GPU` varchar(100) DEFAULT NULL,
  `Network` varchar(100) DEFAULT NULL,
  `Disk_GB` float DEFAULT NULL,
  `MIMO` varchar(100) DEFAULT NULL,
  `MAC_ath_pci` varchar(20) DEFAULT NULL,
  `MAC_wlan0` varchar(20) DEFAULT NULL,
  `MAC_eth0` varchar(20) DEFAULT NULL,
  `MAC_eth1` varchar(20) DEFAULT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE IF NOT EXISTS `reservation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(150) NOT NULL,
  `begin_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `node_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `node_id` (`node_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=27261 ;

-- --------------------------------------------------------

--
-- Table structure for table `rsa_keys`
--

CREATE TABLE IF NOT EXISTS `rsa_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slice_id` int(11) NOT NULL,
  `key` varchar(1000) CHARACTER SET utf8 DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1435 ;

-- --------------------------------------------------------

--
-- Table structure for table `slices`
--

CREATE TABLE IF NOT EXISTS `slices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slice_name` varchar(30) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=260 ;

-- --------------------------------------------------------

--
-- Table structure for table `spectrum`
--

CREATE TABLE IF NOT EXISTS `spectrum` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modulation` varchar(100) DEFAULT NULL,
  `channel` int(11) DEFAULT NULL,
  `frequency` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=44 ;

-- --------------------------------------------------------

--
-- Table structure for table `spec_reserve`
--

CREATE TABLE IF NOT EXISTS `spec_reserve` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(150) CHARACTER SET utf8 NOT NULL,
  `begin_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `spectrum_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7387 ;

-- --------------------------------------------------------

--
-- Table structure for table `users_slices`
--

CREATE TABLE IF NOT EXISTS `users_slices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `slice_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=179 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
