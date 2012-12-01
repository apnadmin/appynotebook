-- MySQL dump 10.13  Distrib 5.5.28, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: appynotebook
-- ------------------------------------------------------
-- Server version	5.5.28-0ubuntu0.12.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account_signup`
--

DROP TABLE IF EXISTS `account_signup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_signup` (
  `service_domain` varchar(256) NOT NULL,
  `full_name` varchar(256) NOT NULL,
  `email_address` varchar(256) NOT NULL,
  `phone` char(32) NOT NULL,
  `company_name` varchar(256) NOT NULL,
  `service_region` char(32) NOT NULL,
  `service_plan` char(32) NOT NULL,
  `payment_type` char(32) NOT NULL,
  `payment_plan` char(32) NOT NULL,
  `password` char(16) NOT NULL,
  `fee` char(16) NOT NULL,
  `stripe_customer_id` varchar(256) DEFAULT NULL,
  `stripe_token` varchar(512) DEFAULT NULL,
  `last_invoice_date` datetime DEFAULT NULL,
  `last_invoice_id` varchar(256) DEFAULT NULL,
  `next_billing_cycle_start_date` datetime DEFAULT NULL,
  `status` char(64) NOT NULL DEFAULT 'provision-in-process',
  `service_start_date` datetime DEFAULT NULL,
  PRIMARY KEY (`service_domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `applet_access`
--

DROP TABLE IF EXISTS `applet_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applet_access` (
  `applet_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `room_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `applet_package`
--

DROP TABLE IF EXISTS `applet_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applet_package` (
  `id` varchar(128) NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `description` text,
  `version` varchar(32) DEFAULT NULL,
  `category` varchar(128) DEFAULT 'Not Installed',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assignment`
--

DROP TABLE IF EXISTS `assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assignment` (
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `open_date_tm` datetime DEFAULT NULL,
  `close_date_tm` datetime DEFAULT NULL,
  `allow_versioned_submission` char(16) NOT NULL DEFAULT 'no',
  `versioned_submission_limit` int(11) NOT NULL DEFAULT '0',
  `timezone` varchar(128) DEFAULT NULL,
  `notification_id` int(11) NOT NULL,
  `status` char(16) NOT NULL DEFAULT 'new',
  `first_reminder_date_tm` datetime DEFAULT NULL,
  `repeat_interval_in_minutes` int(11) DEFAULT NULL,
  `repeat_count` int(11) DEFAULT NULL,
  `first_reminder_sent` char(8) NOT NULL DEFAULT 'no',
  PRIMARY KEY (`room_id`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assignment_submission`
--

DROP TABLE IF EXISTS `assignment_submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assignment_submission` (
  `room_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `assignment_id` int(11) NOT NULL,
  `context_id` int(11) NOT NULL,
  `src_context_id` int(11) NOT NULL,
  `src_pad_id` int(11) NOT NULL,
  `src_type` char(16) NOT NULL,
  `src_state` char(16) NOT NULL,
  `submit_time` datetime NOT NULL,
  PRIMARY KEY (`room_id`,`assignment_id`,`user_id`,`context_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `context`
--

DROP TABLE IF EXISTS `context`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `context` (
  `room_id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `config` text,
  `access_control` int(11) NOT NULL DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`room_id`,`participant_id`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `context_access`
--

DROP TABLE IF EXISTS `context_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `context_access` (
  `room_id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL,
  `granted_to` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `access` int(11) DEFAULT NULL,
  PRIMARY KEY (`room_id`,`participant_id`,`id`,`granted_to`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `element`
--

DROP TABLE IF EXISTS `element`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `element` (
  `room_id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL,
  `context_id` int(11) NOT NULL,
  `pad_id` int(11) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `config` longtext CHARACTER SET utf8,
  `access_control` int(11) NOT NULL DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`room_id`,`participant_id`,`context_id`,`pad_id`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `element_access`
--

DROP TABLE IF EXISTS `element_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `element_access` (
  `room_id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL,
  `granted_to` int(11) NOT NULL,
  `context_id` int(11) NOT NULL,
  `pad_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `access` int(11) DEFAULT NULL,
  PRIMARY KEY (`room_id`,`participant_id`,`context_id`,`pad_id`,`id`,`granted_to`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feature_matrix`
--

DROP TABLE IF EXISTS `feature_matrix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feature_matrix` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(64) DEFAULT NULL,
  `basic_plan_limit` varchar(256) DEFAULT NULL,
  `individual_plan_limit` varchar(256) DEFAULT NULL,
  `team_plan_limit` varchar(256) DEFAULT NULL,
  `display_text` varchar(256) DEFAULT NULL,
  `basic_plan_limit_display_text` varchar(256) DEFAULT NULL,
  `individual_plan_limit_display_text` varchar(256) DEFAULT NULL,
  `team_plan_limit_display_text` varchar(256) DEFAULT NULL,
  `display` char(8) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feature_usage_matrix`
--

DROP TABLE IF EXISTS `feature_usage_matrix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feature_usage_matrix` (
  `user_id` int(11) NOT NULL,
  `feature_id` int(11) NOT NULL,
  `usage` char(32) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`feature_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `status` char(32) DEFAULT NULL,
  `execution_date` datetime NOT NULL,
  `stripe_token` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `timezone` varchar(128) DEFAULT NULL,
  `repeat_interval` mediumtext,
  `repeat_interval_count` int(11) DEFAULT NULL,
  `variable_definitions` text,
  `message_template` text,
  `messaging_medium` varchar(64) NOT NULL DEFAULT 'email',
  `state` char(16) NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `packaged_applets`
--

DROP TABLE IF EXISTS `packaged_applets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packaged_applets` (
  `package_id` varchar(128) NOT NULL,
  `id` int(11) NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `description` text,
  `installed` char(8) DEFAULT 'No',
  `applet_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`package_id`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pad`
--

DROP TABLE IF EXISTS `pad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pad` (
  `room_id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL,
  `context_id` int(11) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `config` text,
  `access_control` int(11) NOT NULL DEFAULT '0',
  `embed_key` char(64) DEFAULT NULL,
  `parent` int(11) NOT NULL DEFAULT '0',
  `position` int(11) NOT NULL DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `pre_sibling` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`room_id`,`participant_id`,`context_id`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pad_access`
--

DROP TABLE IF EXISTS `pad_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pad_access` (
  `room_id` int(11) NOT NULL,
  `participant_id` int(11) NOT NULL,
  `granted_to` int(11) NOT NULL,
  `context_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `access` int(11) DEFAULT NULL,
  PRIMARY KEY (`room_id`,`participant_id`,`context_id`,`id`,`granted_to`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `participant`
--

DROP TABLE IF EXISTS `participant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `participant` (
  `room_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_role_id` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`room_id`,`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prod_resource`
--

DROP TABLE IF EXISTS `prod_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prod_resource` (
  `widget_id` int(11) NOT NULL,
  `file_name` varchar(256) NOT NULL,
  `label` varchar(256) DEFAULT NULL,
  `fs_name` varchar(256) NOT NULL,
  `type` varchar(64) NOT NULL,
  `mime` varchar(64) NOT NULL,
  `size` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  `last_mod_date` datetime NOT NULL,
  PRIMARY KEY (`widget_id`,`file_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prod_widget`
--

DROP TABLE IF EXISTS `prod_widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prod_widget` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `description` varchar(512) DEFAULT NULL,
  `icon_res_id` int(11) DEFAULT '-1',
  `code` text NOT NULL,
  `status` varchar(256) NOT NULL,
  `version` char(32) DEFAULT NULL,
  `author_name` varchar(256) NOT NULL,
  `author_link` varchar(256) DEFAULT NULL,
  `category` varchar(256) DEFAULT NULL,
  `tags` varchar(256) DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `last_mod_date` datetime NOT NULL,
  `show_in_menu` varchar(32) NOT NULL DEFAULT 'Yes',
  `default_instance` text,
  `question` text,
  `price` float NOT NULL DEFAULT '0',
  `catalog_page_index` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `dev_toxonomy` char(64) DEFAULT NULL,
  `unique_key` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=208 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `queue_resource`
--

DROP TABLE IF EXISTS `queue_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queue_resource` (
  `widget_id` int(11) NOT NULL,
  `file_name` varchar(256) NOT NULL,
  `label` varchar(256) DEFAULT NULL,
  `fs_name` varchar(256) NOT NULL,
  `type` varchar(64) NOT NULL,
  `mime` varchar(64) NOT NULL,
  `size` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  `last_mod_date` datetime NOT NULL,
  PRIMARY KEY (`widget_id`,`file_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `queue_widget`
--

DROP TABLE IF EXISTS `queue_widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queue_widget` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `description` varchar(512) DEFAULT NULL,
  `icon_res_id` int(11) DEFAULT '-1',
  `code` text NOT NULL,
  `status` varchar(256) NOT NULL,
  `version` char(32) DEFAULT NULL,
  `author_name` varchar(256) NOT NULL,
  `author_link` varchar(256) DEFAULT NULL,
  `category` varchar(256) DEFAULT NULL,
  `tags` varchar(256) DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `last_mod_date` datetime NOT NULL,
  `show_in_menu` varchar(32) NOT NULL DEFAULT 'Yes',
  `default_instance` text,
  `question` text,
  `price` float NOT NULL DEFAULT '0',
  `catalog_page_index` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `dev_toxonomy` char(64) DEFAULT NULL,
  `unique_key` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=203 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rejected_resource`
--

DROP TABLE IF EXISTS `rejected_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rejected_resource` (
  `widget_id` int(11) NOT NULL,
  `file_name` varchar(256) NOT NULL,
  `label` varchar(256) DEFAULT NULL,
  `fs_name` varchar(256) NOT NULL,
  `type` varchar(64) NOT NULL,
  `mime` varchar(64) NOT NULL,
  `size` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  `last_mod_date` datetime NOT NULL,
  PRIMARY KEY (`widget_id`,`file_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rejected_widget`
--

DROP TABLE IF EXISTS `rejected_widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rejected_widget` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `description` varchar(512) DEFAULT NULL,
  `icon_res_id` int(11) DEFAULT '-1',
  `code` text NOT NULL,
  `status` varchar(256) NOT NULL,
  `version` char(32) DEFAULT NULL,
  `author_name` varchar(256) NOT NULL,
  `author_link` varchar(256) DEFAULT NULL,
  `category` varchar(256) DEFAULT NULL,
  `tags` varchar(256) DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `last_mod_date` datetime NOT NULL,
  `show_in_menu` varchar(32) NOT NULL DEFAULT 'Yes',
  `default_instance` text,
  `question` text,
  `price` float NOT NULL DEFAULT '0',
  `catalog_page_index` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `dev_toxonomy` char(64) DEFAULT NULL,
  `unique_key` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `resource`
--

DROP TABLE IF EXISTS `resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resource` (
  `widget_id` int(11) NOT NULL,
  `file_name` varchar(256) NOT NULL,
  `label` varchar(256) DEFAULT NULL,
  `fs_name` varchar(256) NOT NULL,
  `type` varchar(64) NOT NULL,
  `mime` varchar(64) NOT NULL,
  `size` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  `last_mod_date` datetime NOT NULL,
  PRIMARY KEY (`widget_id`,`file_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL DEFAULT '0',
  `role` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`role`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `room` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(256) DEFAULT NULL,
  `creation_date` datetime DEFAULT NULL,
  `amq_topic_uri` varchar(256) DEFAULT NULL,
  `access_control` int(11) NOT NULL DEFAULT '0',
  `access_code` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=179 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `signup_request`
--

DROP TABLE IF EXISTS `signup_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `signup_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(256) NOT NULL,
  `first_name` varchar(256) NOT NULL,
  `last_name` varchar(256) NOT NULL,
  `course` varchar(256) NOT NULL,
  `home_page` text NOT NULL,
  `request_date` datetime NOT NULL,
  `security_tk` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `static_references`
--

DROP TABLE IF EXISTS `static_references`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `static_references` (
  `file_name` varchar(256) NOT NULL,
  `reference_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`file_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `text_data`
--

DROP TABLE IF EXISTS `text_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `text_data` (
  `id` varchar(64) NOT NULL,
  `descp` varchar(256) NOT NULL,
  `data` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_account`
--

DROP TABLE IF EXISTS `user_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_account` (
  `user_id` int(11) NOT NULL,
  `plan` char(64) DEFAULT NULL,
  `plan_status` char(32) DEFAULT NULL,
  `stripe_customer_id` varchar(256) DEFAULT NULL,
  `plan_start_date` datetime DEFAULT NULL,
  `last_invoice_date` datetime DEFAULT NULL,
  `last_invoice_id` varchar(256) DEFAULT NULL,
  `team_size` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_settings` (
  `user_id` int(11) NOT NULL,
  `dev_toxonomy` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(256) NOT NULL,
  `pass_word` varchar(256) NOT NULL,
  `status` char(32) DEFAULT NULL,
  `name` varchar(256) NOT NULL,
  `plan` char(64) DEFAULT NULL,
  `plan_status` char(32) DEFAULT NULL,
  `stripe_customer_id` varchar(256) DEFAULT NULL,
  `plan_start_date` datetime DEFAULT NULL,
  `next_billing_cycle_start_date` datetime DEFAULT NULL,
  `last_invoice_date` datetime DEFAULT NULL,
  `last_invoice_id` varchar(256) DEFAULT NULL,
  `team_size` int(11) NOT NULL DEFAULT '0',
  `create_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=MyISAM AUTO_INCREMENT=182 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `verified_eudcators`
--

DROP TABLE IF EXISTS `verified_eudcators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `verified_eudcators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(256) NOT NULL,
  `first_name` varchar(256) NOT NULL,
  `last_name` varchar(256) NOT NULL,
  `home_page` varchar(256) NOT NULL,
  `verification_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `widget`
--

DROP TABLE IF EXISTS `widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `widget` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `description` varchar(512) DEFAULT NULL,
  `icon_res_id` int(11) DEFAULT '-1',
  `code` text NOT NULL,
  `status` varchar(256) NOT NULL,
  `version` char(32) DEFAULT NULL,
  `author_name` varchar(256) NOT NULL,
  `author_link` varchar(256) DEFAULT NULL,
  `category` varchar(256) DEFAULT NULL,
  `tags` varchar(256) DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `last_mod_date` datetime NOT NULL,
  `show_in_menu` varchar(32) NOT NULL DEFAULT 'Yes',
  `default_instance` text,
  `question` text,
  `price` float NOT NULL DEFAULT '0',
  `catalog_page_index` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `dev_toxonomy` char(64) DEFAULT NULL,
  `unique_key` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=216 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `widget_dependency`
--

DROP TABLE IF EXISTS `widget_dependency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `widget_dependency` (
  `widget_id` int(11) NOT NULL,
  `dependency_id` varchar(256) NOT NULL,
  `dependency_path` varchar(1024) NOT NULL,
  PRIMARY KEY (`widget_id`,`dependency_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'appynotebook'
--
/*!50003 DROP FUNCTION IF EXISTS `get_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 FUNCTION `get_category`(installed char(8),applet_id integer) RETURNS text CHARSET latin1
BEGIN
	declare category text;
        declare cnt integer default 0;
	select count(prod_widget.category) into cnt from prod_widget where prod_widget.id = applet_id;        

	IF installed = 'No' or cnt=0 THEN
		set category = 'Not Installed';
	ELSE
		select prod_widget.category into category 
		from prod_widget where prod_widget.id = applet_id;
	END IF;
        RETURN category;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 FUNCTION `get_user_id`(user_name varchar(128)) RETURNS int(11)
BEGIN
	declare user_id  integer;
	select users.id into user_id from users where lower(users.user_name)=lower(user_name);
	return user_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `has_context_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 FUNCTION `has_context_access`(participant_id integer,
					      room_id integer,
					      id integer,
					      granted_to integer,
					      access integer) RETURNS int(11)
BEGIN
	declare result_count integer;
	
	/*check if global access has been granted*/
	select 	count(context.id) into result_count from context
	where
	context.room_id=room_id and
	context.participant_id=participant_id and
	context.id=id	and
	(context.access_control & access) >0;

	/*or individual access has been granted*/
	if result_count = 0 then
		select 	count(context_access.id) into result_count
		from context_access where
		context_access.room_id=room_id and 
		context_access.participant_id=participant_id and
		context_access.id=id and
		context_access.granted_to=granted_to and			       
		(context_access.access & access)>0;
	end if;
	return result_count >0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `has_element_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 FUNCTION `has_element_access`(participant_id integer,
					      room_id integer,
					      context_id integer,
					      pad_id integer,
					      id integer,
					      granted_to integer,
					      access integer) RETURNS int(11)
BEGIN
	declare result_count integer;
	
	/*check if global access has been granted*/
	select 	count(element.id) into result_count from element
	where
	element.room_id=room_id and
	element.participant_id=participant_id and
	element.context_id=context_id and
	element.pad_id=pad_id and
	element.id=id and
	(element.access_control & access) >0;

	/*or individual access has been granted*/
	if result_count = 0 then
		select 	count(element_access.id) into result_count
		from element_access where
		element_access.room_id=room_id and 
		element_access.participant_id=participant_id and
		element_access.context_id=context_id and
		element_access.pad_id=pad_id and
		element_access.id=id and
		element_access.granted_to=granted_to and			       
		(element_access.access & access)>0;
	end if;
	return result_count >0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `has_pad_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 FUNCTION `has_pad_access`(participant_id integer,
					      room_id integer,
					      context_id integer,
					      id integer,
					      granted_to integer,
					      access integer) RETURNS int(11)
BEGIN
	declare result_count integer;
	
	/*check if global access has been granted*/
	select 	count(pad.id) into result_count from pad
	where
	pad.room_id=room_id and
	pad.participant_id=participant_id and
	pad.context_id=context_id and
	pad.id=id and
	(pad.access_control & access) >0;

	/*or individual access has been granted*/
	if result_count = 0 then
		select 	count(pad_access.id) into result_count
		from pad_access where
		pad_access.room_id=room_id and 
		pad_access.participant_id=participant_id and
		pad_access.context_id=context_id and
		pad_access.id=id and
		pad_access.granted_to=granted_to and			       
		(pad_access.access & access)>0;
	end if;
	return result_count >0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_assignment_open` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 FUNCTION `is_assignment_open`(timezone varchar(256),start_dt_tm datetime,end_dt_tm datetime) RETURNS tinyint(1)
BEGIN
   return (end_dt_tm is NULL && start_dt_tm is NULL)|| (end_dt_tm is null && (UNIX_TIMESTAMP(convert_tz(start_dt_tm,timezone,'UTC'))<=UNIX_TIMESTAMP(UTC_TIMESTAMP()))) || (UNIX_TIMESTAMP(convert_tz(start_dt_tm,timezone,'UTC'))<=UNIX_TIMESTAMP(UTC_TIMESTAMP()) && (UNIX_TIMESTAMP(convert_tz(end_dt_tm,timezone,'UTC'))) >UNIX_TIMESTAMP(UTC_TIMESTAMP()));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_in_room` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 FUNCTION `is_in_room`(user_id integer,room_id integer) RETURNS tinyint(1)
BEGIN
   declare cnt integer default 0;
   select count('*') into cnt from participant where (participant.user_id=user_id and participant.room_id=room_id);
   return cnt>0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_super_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 FUNCTION `is_super_user`(user_id integer) RETURNS tinyint(1)
BEGIN
       declare cnt integer default 0;
       select count(roles.id) into cnt from user_roles,roles where user_roles.user_id=user_id and roles.id=user_roles.role_id and roles.role = 'superuser';
       return cnt>0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `room_is_empty` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 FUNCTION `room_is_empty`(room_id integer) RETURNS tinyint(1)
BEGIN
   declare cnt integer default 0;
   select count('*') into cnt from participant where (participant.room_id=room_id);

   if cnt = 0 then
   	return TRUE;
   else
   	return FALSE;
   end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_account_signup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_account_signup`(  
  							service_domain varchar(256),
  							full_name varchar(256),
  							email_address varchar(256),
  							phone char(32),
  							company_name varchar(256),
  							service_region char(32),
  							service_plan char(32),
  							payment_type char(32),
  							payment_plan char(32),  							
  							fee char(16),
  							stripe_customer_id varchar(256),
  							stripe_token varchar(512)
						)
    SQL SECURITY INVOKER
BEGIN 
	insert into account_signup (service_domain,
				    full_name,
				    email_address,
				    phone,
				    company_name,
				    service_region,
				    service_plan,
				    payment_type,
				    payment_plan,
				    password,		    
				    fee,
				    stripe_customer_id,
				    stripe_token) 

				    values
				    (lower(service_domain),
				    full_name,
				    email_address,
				    phone,
				    company_name,
				    service_region,
				    service_plan,
				    payment_type,
				    payment_plan,
				    uuid(),
				    fee,
				    stripe_customer_id,
				    stripe_token);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_assignment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_assignment`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN name varchar(256),
							      IN open_date datetime,
							      IN close_date datetime,
							      IN timezone varchar(128),
							      IN notification_id integer,
							      IN allow_versioned_submission char(8),
							      IN versioned_submission_limit integer,
							      IN first_reminder_date_tm datetime,
							      IN repeat_interval_in_minutes integer,
							      IN repeat_count integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id ,assignment_id integer default 0;
	set user_id = get_user_id(user_name);

	insert into assignment (user_id,room_id,
				name,
				open_date_tm,
				close_date_tm,
				timezone,notification_id,
				allow_versioned_submission,
				versioned_submission_limit,
				first_reminder_date_tm,
				repeat_interval_in_minutes,
				repeat_count) 
				values(user_id,
				       room_id,
				       name,
				       open_date,
				       close_date,
				       timezone,
				       notification_id,
				       allow_versioned_submission,
				       versioned_submission_limit,
				       first_reminder_date_tm,
				       repeat_interval_in_minutes,
				       repeat_count);
	select LAST_INSERT_ID() into assignment_id;
	select assignment_id as 'assignment_id';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_assignment_submission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_assignment_submission`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN assignment_id integer,
							      IN context_id integer,
							      IN src_context_id integer,
							      IN src_pad_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);
	insert into assignment_submission (user_id,room_id,assignment_id,context_id,src_context_id,src_pad_id,src_state,submit_time) values(user_id,room_id,assignment_id,context_id,src_context_id,src_pad_id,'exists',now());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_context` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_context`(
							      	  IN user_name varchar(128),
								  IN room_id integer,							      
							      	  IN config text,
								  IN default_access integer)
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id,context_id integer default 0;

	declare read_access integer default 1;
	declare write_access integer default 2;
	declare read_write_access integer default (write_access | read_access);
	
	declare create_page_access integer default 4;
	declare delete_page_access integer default 8;
	declare full_access integer default read_write_access | create_page_access | delete_page_access;

	set participant_id = get_user_id(user_name);
	insert into context (room_id,participant_id,config,created_by,create_date,access_control) values(room_id,participant_id,config,participant_id,now(),default_access);
	set context_id = LAST_INSERT_ID();

	/*add access entries for all members of this room to this context object*/
	insert into context_access (room_id,participant_id,id,granted_to,access)
	select participant.room_id,participant_id,context_id,participant.user_id,0 from participant where participant.room_id =room_id;

	/*grant all access to the owner*/
	/*call sp_add_context_access(room_id,participant_id,context_id,participant_id,15);*/
	update context_access set context_access.access=full_access where context_access.room_id=room_id and
						  context_access.participant_id=participant_id and
						  context_access.id=context_id and
						  context_access.granted_to=participant_id;
	select context_id;
						  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_context_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_context_access`(
							      IN user_name varchar(128),
							      IN room_id integer,							      							      
							      IN id integer,
							      IN granted_to integer,
							      IN access integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	insert into context_access (room_id,participant_id,id,granted_to,access) 
				   values(room_id,participant_id,id,granted_to,access);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_element` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_element`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN context_id integer,
							      IN pad_id integer,
							      IN config longtext,
							      IN grantor integer,
							      IN default_access integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id,element_id integer default 0;

	declare read_access integer default 1;
	declare write_access integer default 2;
	declare alter_security_access integer default 32;
	declare full_access integer default (write_access | read_access | alter_security_access);

	set participant_id = get_user_id(user_name);

	if has_context_access(grantor,room_id,context_id,participant_id,read_access) and
	   has_pad_access(grantor,room_id,context_id,pad_id,participant_id,write_access) then

	   insert into element (room_id,participant_id,context_id,pad_id,config,created_by,create_date,access_control) values(room_id,grantor,context_id,pad_id,config,participant_id,now(),default_access);
	   select LAST_INSERT_ID() into element_id;

	   /*add access entries for all members of this room to this element*/
	   insert into element_access (room_id,participant_id,context_id,pad_id,id,granted_to,access)
	   select participant.room_id,grantor,context_id,pad_id,element_id,participant.user_id,0 from participant where participant.room_id =room_id;

	   /*grant all access to the creator*/
	   /*call sp_add_pad_access(room_id,grantor,context_id,pad_id,participant_id,3);*/
	   update element_access set element_access.access=full_access where element_access.room_id=room_id and
						  element_access.participant_id=grantor and
						  element_access.context_id=context_id and
						  element_access.pad_id=pad_id and
						  element_access.id=element_id and
						  element_access.granted_to=participant_id;
	end if;
	select element_id;
/*
	declare pad_access_cnt integer;
	declare participant_id,element_id integer;
	select id into participant_id from users where users.user_name=user_name;

	select 	count(pad.id) into pad_access_cnt
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.id=pad_id and
			       pad_access.granted_to=participant_id and
			       (
				 (pad_access.access & 2)>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and (context_access.access & 2)>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  pad.id=pad_id and
				  (
				    (pad.access_control & 2)>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and (context.access_control & 2)>0
				    )=1
				  )
				)
			 	and
				(
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id			  
				)
			    )
			)
		    )
		) ;

	if pad_access_cnt=1 then
	   insert into element (room_id,participant_id,context_id,pad_id,config) values(room_id,grantor,context_id,pad_id,config);
	   select LAST_INSERT_ID() into element_id;

	   /*add access entries for all members of this room to this element*
	   insert into element_access (room_id,participant_id,context_id,pad_id,id,granted_to,access)
	   select participant.room_id,grantor,context_id,pad_id,element_id,participant.user_id,3 from participant where participant.room_id =room_id;

	   /*grant all access to the creator*
	   /*call sp_add_pad_access(room_id,grantor,context_id,pad_id,participant_id,3);*
	   update element_access set element_access.access=3 where element_access.room_id=room_id and
						  element_access.participant_id=grantor and
						  element_access.context_id=context_id and
						  element_access.pad_id=pad_id and
						  element_access.id=element_id and
						  element_access.granted_to=participant_id;
	
	end if;
        select element_id;
*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_element_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_element_access`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN context_id integer,
							      IN pad_id integer,							      
							      IN id integer,
							      IN granted_to integer,
							      IN access integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	insert into element_access (room_id,participant_id,context_id,pad_id,id,granted_to,access) 
				   values(room_id,participant_id,context_id,pad_id,id,granted_to,access);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_notification` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_notification`(
							      IN start_time datetime,
							      IN end_time datetime,
							      IN timezone varchar(128),
							      IN repeat_interval long,
							      IN repeat_interval_count integer,
							      IN variable_definitions text,
							      IN message_template text,
							      IN messaging_medium varchar(64)
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare notification_id integer;
	insert into notifications (start_time,end_time,timezone,repeat_interval,repeat_interval_count,variable_definitions,message_template,messaging_medium) values(start_time,end_time,timezone,repeat_interval,repeat_interval_count,variable_definitions,message_template,messaging_medium);
	select LAST_INSERT_ID() into notification_id;
	select notification_id as 'notification_id';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_order`(IN room_id integer,
							      IN widget_id integer)
    SQL SECURITY INVOKER
BEGIN 
     declare price integer;
     select prod_widget.price into price from prod_widget where id=widget_id;
     insert into widget_order (widget_id,room_id,price,ord_date) values(widget_id,room_id,price,now());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_package` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_package`(IN id varchar(128),
				   IN name varchar(256),							      
				   IN description text,
				   IN version varchar(32))
BEGIN 
	insert into applet_package (id,name,description,version) values(id,name,description,version);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_packaged_applet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_packaged_applet`(
				   IN package_id varchar(128),
				   IN id integer,
				   IN name varchar(256),							      
				   IN description text)
BEGIN 
	insert into packaged_applets (package_id,id,name,description,applet_id) values(package_id,id,name,description,0);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_pad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_pad`(IN room_id integer,
							      IN user_name varchar(128),
							      IN context_id integer,
							      IN parent_id integer,
							      IN pre_sibling integer,
							      IN config text,
							      IN grantor integer,
							      IN default_access integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id ,pad_id integer default 0;

	declare read_access integer default 1;
	declare write_access integer default 2;
	declare read_write_access integer default (write_access | read_access);
	set participant_id = get_user_id(user_name);


	   insert into pad (room_id,participant_id,context_id,parent_id,pre_sibling,config,created_by,create_date,access_control) values(room_id,/*grantor*/participant_id,context_id,parent_id,0,config,participant_id,now(),default_access);
	   select LAST_INSERT_ID() into pad_id;

	   /*add access entries for all members of this room to this pad*/
	   insert into pad_access (room_id,participant_id,context_id,id,granted_to,access)
	   select participant.room_id,/*grantor*/participant_id,context_id,pad_id,participant.user_id, 0 from participant where participant.room_id =room_id;

	   /*grant all access to the creator*/
	   /*call sp_add_pad_access(room_id,grantor,context_id,pad_id,participant_id,3);*/
	   update pad_access set pad_access.access=read_write_access where pad_access.room_id=room_id and
						  pad_access.participant_id=/*grantor*/participant_id and
						  pad_access.context_id=context_id and
						  pad_access.id=pad_id and
						  pad_access.granted_to=participant_id;

           update pad set pad.embed_key = md5(concat(room_id,'-',grantor,'-',context_id,'-',pad_id)) 
                                                where pad.room_id=room_id and 
                                                      pad.participant_id = /*grantor*/participant_id and
                                                      pad.context_id = context_id and
                                                      pad.id=pad_id;

	   /*update link pointer */
	   update pad set pad.pre_sibling = pad_id
           where pad.room_id=room_id and 
           pad.participant_id = /*grantor*/participant_id and
           pad.context_id = context_id and
	   pad.pre_sibling=pre_sibling;


	   update pad set pad.pre_sibling = pre_sibling
           where pad.room_id=room_id and 
           pad.participant_id = /*grantor*/participant_id and
           pad.context_id = context_id and
	   pad.id=pad_id;

	select pad_id as 'pad_id';
/*
	declare context_access_cnt,participant_id,pad_id integer;	
	declare write_access integer;
	set @write_access = 2;
	
	select id into participant_id from users where users.user_name=user_name;

	/*
	insert into pad (room_id,participant_id,context_id,config) values(room_id,participant_id,context_id,config);
	*

	select 	count(context.id) into context_access_cnt
		from context,context_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       context_access.room_id=room_id and 
			       context_access.participant_id=grantor and
			       context_access.id = context_id and
			       context_access.granted_to=participant_id and			       			       
			       (
				 (context_access.access & 2)>0
			         or
			    	 (
			       	   select count(pad_access.id) from pad_access where pad_access.room_id=context_access.room_id and pad_access.participant_id=context_access.participant_id and pad_access.context_id=context_access.id and pad_access.granted_to=context_access.granted_to and (pad_access.access & 2) >0
			         )>0
			       )
			    )
		    	    and		
		    	    (
				context.room_id=context_access.room_id and
				context.participant_id=context_access.participant_id and
				context.id=context_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				context.room_id=room_id and
				context.participant_id=grantor and
				context.id=context_id and
				(
				  ((context.access_control & 2)>0)
				  or
				  (
				    select count(pad.id) from pad where pad.room_id=context.room_id and pad.participant_id=context.participant_id and pad.context_id=context.id and ((pad.access_control & 2)>0)
				  )>0
			 	) 
				and
				(				  
				  context_access.room_id=context.room_id and
				  context_access.participant_id=context.participant_id and
				  context_access.id=context.id	and
				  context_access.granted_to=participant_id
				)
			    )
			)
		    )
		);

	if context_access_cnt=1 then
	   insert into pad (room_id,participant_id,context_id,config,access_control) values(room_id,grantor,context_id,config,0);
	   select LAST_INSERT_ID() into pad_id;

	   /*add access entries for all members of this room to this pad*
	   insert into pad_access (room_id,participant_id,context_id,id,granted_to,access)
	   select participant.room_id,grantor,context_id,pad_id,participant.user_id,0 from participant where participant.room_id =room_id;

	   /*grant all access to the creator*
	   /*call sp_add_pad_access(room_id,grantor,context_id,pad_id,participant_id,3);*
	   update pad_access set pad_access.access=3 where pad_access.room_id=room_id and
						  pad_access.participant_id=grantor and
						  pad_access.context_id=context_id and
						  pad_access.id=pad_id and
						  pad_access.granted_to=participant_id;

           update pad set pad.embed_key = md5(concat(room_id,'-',grantor,'-',context_id,'-',pad_id)) 
                                                where pad.room_id=room_id and 
                                                      pad.participant_id = grantor and
                                                      pad.context_id = context_id and
                                                      pad.id=pad_id;

	end if;
	select pad_id as 'pad_id';*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_pad_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_pad_access`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN context_id integer,							      
							      IN id integer,
							      IN granted_to integer,
							      IN access integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	insert into pad_access (room_id,participant_id,context_id,id,granted_to,access) 
				   values(room_id,participant_id,context_id,id,granted_to,access);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_participant` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_participant`(IN user_name varchar(256),IN user_id integer,IN room_id integer,IN room_role varchar(64))
    SQL SECURITY INVOKER
BEGIN 
   declare dupcheck,room_role_id,new_participant_id/*,user_id*/ integer;
   /**set user_id = get_user_id(user_name);**/

   select count(*) into dupcheck from participant where (participant.room_id=room_id and participant.user_id=user_id);
   select id into room_role_id from roles where role=room_role;

   if dupcheck=0 then     
     insert into participant (room_id,user_id,room_role_id) values (room_id,user_id,room_role_id);
     set new_participant_id = user_id;

     /*add access entries for all contexts and pads of this room to this participant object*/
     insert into context_access (room_id,participant_id,id,granted_to,access)
     (select context.room_id,
	    context.participant_id,
	    context.id,
	    new_participant_id,
	    0
	    from context where context.room_id=room_id);
	
     insert into pad_access (room_id,participant_id,context_id,id,granted_to,access)
     (select pad.room_id,
	    pad.participant_id,
	    pad.context_id,
	    pad.id,
	    new_participant_id,
	    0
	    from pad where pad.room_id=room_id);     

     insert into element_access (room_id,participant_id,context_id,pad_id,id,granted_to,access)
     (select element.room_id,
	    element.participant_id,
	    element.context_id,
	    element.pad_id,
	    element.id,
	    new_participant_id,
	    0
	    from element where element.room_id=room_id); 
   end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_resource` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_resource`(
							 	   IN user_name varchar(128),
								   IN widget_id integer,
								   IN file_name varchar(256),
								   IN label varchar(256),
								   IN fs_name varchar(256),
								   IN type  varchar(64),
								   IN mime varchar(64),
								   IN size integer,
								   IN env char(128))
    SQL SECURITY INVOKER
BEGIN 
     /*select uuid() into fs_name ;*/
     declare crtdate datetime;
     declare resource_id integer default 0;

     select now() into crtdate;
     if env='dev' then
       insert into resource (widget_id,file_name,label,fs_name,type,mime,size,create_date,last_mod_date) values (widget_id,file_name,label,fs_name,type,mime,size,crtdate,crtdate);
       set resource_id = LAST_INSERT_ID();
     elseif env='rejected' then
       insert into rejected_resource (widget_id,file_name,label,fs_name,type,mime,size,create_date,last_mod_date) values (widget_id,file_name,label,fs_name,type,mime,size,crtdate,crtdate);
       set resource_id = LAST_INSERT_ID();
     elseif env='prod' then
       insert into prod_resource (widget_id,file_name,label,fs_name,type,mime,size,create_date,last_mod_date) values (widget_id,file_name,label,fs_name,type,mime,size,crtdate,crtdate);
       set resource_id = LAST_INSERT_ID();
     end if;
       select resource_id as 'resource_id';     
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_room` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_room`(IN user_name varchar(128),IN title varchar(256))
    SQL SECURITY INVOKER
BEGIN 
    declare room_id integer;
    declare user_id integer;

    select id into user_id from users where users.user_name=user_name;

    insert into room (user_id,title,creation_date,amq_topic_uri,access_code)values (user_id,title,now(),UUID(),substring(replace(uuid(),'-',''),1,16));
    
    select LAST_INSERT_ID() into room_id;
    
    call sp_add_participant(user_name,user_id,room_id,'room_creator');
    call sp_get_room(user_name,room_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_static_reference` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_static_reference`(
							      IN file_name varchar(256)
							      )
    SQL SECURITY INVOKER
BEGIN 
  insert into static_references (file_name,reference_count) values(file_name,0);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_user`(IN email_address varchar(255),
							       IN name varchar(255),
							       IN user_role varchar(256))
    SQL SECURITY INVOKER
BEGIN 
     declare user_count,last_user_id,user_role_id integer default 0;
     select count(users.id) into user_count from users where lower(users.user_name)=lower(email_address);
     if user_role != 'superuser' then
     	select id into user_role_id from roles where role=user_role;
     else
	select id into user_role_id from roles where role='participant';
     end if;

     if user_count=0 then
     	insert into users (user_name,pass_word,name,plan,plan_status,create_date) values (lower(email_address),SUBSTRING(UUID(),1,8),name,'basic','active',now());
        select LAST_INSERT_ID() into last_user_id;
	
	insert into user_roles values(last_user_id,user_role_id);     	

	insert into feature_usage_matrix (feature_usage_matrix.user_id,feature_usage_matrix.feature_id,feature_usage_matrix.usage) 
	select last_user_id,feature_matrix.id,'0' from feature_matrix;

	select id as 'id',user_name as 'userName',pass_word as 'passWord',user_name as 'emailAddress',name as 'name' from users where id=last_user_id;
     else
	select id as 'id',user_name as 'userName',pass_word as 'passWord',user_name as 'emailAddress',name as 'name' from users where (users.user_name=lower(email_address));
     end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_user_settings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_user_settings`(IN user_name varchar(256),IN dev_toxonomy text)
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer;
	set user_id= get_user_id(user_name);
   	insert into user_settings values(user_id,dev_toxonomy);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_user_to_role` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_user_to_role`(user_id integer,role_name varchar(256))
    SQL SECURITY INVOKER
BEGIN 
     declare role_id integer default 0;     
     if role_name != 'superuser' then
       select id into role_id from roles where role=role_name;
     end if;

     if role_id != 0 then
     	insert into user_roles values (user_id,role_id);
     end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_widget`(
								 IN creator_id integer,
								 IN name varchar(256),
								 IN description varchar(512),
								 IN category text,
								 IN tags varchar(256),
								 IN show_in_menu char(8),
								 IN code text,
								 IN author_name varchar(256),
								 IN author_link varchar(256),
								 IN price float,
								 IN catalog_page_index integer,
								 IN dev_toxonomy char(64))
    SQL SECURITY INVOKER
BEGIN 
     declare crtdate datetime;
     declare widget_id integer;
     select now() into crtdate;
     insert into widget (creator_id,
		         name,
			 description,
			 category,
			 tags,
			 show_in_menu,
			 code,			 
			 author_name,
			 author_link,
			 version,
			 status,
			 create_date ,
			 last_mod_date,
			 price,
			 catalog_page_index,
			 dev_toxonomy,
			 unique_key)
			 values (creator_id,
				 name,
				 description,
				 category,
				 tags,
				 show_in_menu,
				 code,
				 author_name,
				 author_link,
				 '1.0',
				 'new',
				 crtdate,
				 crtdate,
				 price,
				 catalog_page_index,
				 dev_toxonomy,
				 SUBSTRING(REPLACE(UUID(),"-",""),1,32));
     select LAST_INSERT_ID() into widget_id;
     select widget_id as 'widget_id';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_widget_dependency` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_add_widget_dependency`(
								  IN widget_id integer,
							      	  IN dependency_id varchar(256),
								  IN dependency_path varchar(1024))
    SQL SECURITY INVOKER
BEGIN 
	insert into widget_dependency values (widget_id,dependency_id,dependency_path);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_approve_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_approve_widget`(IN id integer)
    SQL SECURITY INVOKER
BEGIN 
	/*Delete any current version in production*/
	delete from prod_resource where widget_id=id;
	delete from prod_widget where prod_widget.id=id;

	insert into prod_widget (select * from queue_widget where queue_widget.id=id);
	  
	update prod_widget set status='APPROVED' where (prod_widget.id=id);

	insert into prod_resource ( select * from queue_resource where queue_resource.widget_id = id);

	/*Remove from review queue*/
	delete from queue_resource where widget_id=id;
	delete from queue_widget where queue_widget.id=id;

	select 	* from prod_widget where (prod_widget.id=id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_archive_assignment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_archive_assignment`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);
	declare notification_id integer;

	select assignment.notification_id into notification_id 
	from assignment 	
	where(assignment.user_id=user_id and
              assignment.room_id=room_id and
	      assignment.id =id);
	update notifications set notifications.state='dead' where
	notifications.id=notification_id;

	update assignment set assignment.status='archived'
	where(assignment.user_id=user_id and
              assignment.room_id=room_id and
	      assignment.id =id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_applet_package` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_delete_applet_package`(IN package_id varchar(128))
    SQL SECURITY INVOKER
BEGIN 
      delete from packaged_applets where packaged_applets.package_id = package_id;
      delete from applet_package where applet_package.id = package_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_assignment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_delete_assignment`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);
	
	delete from assignment
	where(assignment.user_id=user_id and
              assignment.room_id=room_id and
	      assignment.id=id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_assignment_submission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_delete_assignment_submission`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN assignment_id integer,
							      IN context_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);

	delete from
	assignment_submission
	where
	assignment_submission.room_id=room_id and
	assignment_submission.user_id=user_id and
	assignment_submission.context_id=context_id and
	assignment_submission.assignment_id=assignment_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_participant` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_delete_participant`(
					      IN user_name varchar(256),
					      IN room_id integer,
					      IN participant_id integer)
    SQL SECURITY INVOKER
BEGIN 
   /*delete all element access acquired and granted*/
   delete from element_access where (element_access.room_id=room_id and 
				      (element_access.participant_id=participant_id 
				      or element_access.granted_to=participant_id));

   delete from element where (element.room_id=room_id and 
				   element.participant_id=participant_id);
	
   
   /*delete all pad access acquired and granted*/
   delete from pad_access where (pad_access.room_id=room_id and 
				      (pad_access.participant_id=participant_id 
				      or pad_access.granted_to=participant_id));
   delete from pad where (pad.room_id=room_id and 
				   pad.participant_id=participant_id);	
	
   /*delete all context access acquired and granted*/
   delete from context_access where (context_access.room_id=room_id and 
				     (context_access.participant_id=participant_id
				      or context_access.granted_to=participant_id));	

   delete from context where (context.room_id=room_id and 
				   context.participant_id=participant_id);

   delete from participant where (participant.room_id=room_id and participant.user_id=participant_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_signup_request` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_delete_signup_request`(IN id integer,
									 IN security_tk varchar(256))
    SQL SECURITY INVOKER
BEGIN 	
	delete from signup_request where signup_request.id=id and signup_request.security_tk=security_tk;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_delete_user`(IN email_address varchar(256))
    SQL SECURITY INVOKER
BEGIN 
   declare user_id integer default 0;
   set user_id = get_user_id(email_address);

   /*
   delete from element where element.participant_id=user_id;
   delete from element_access where element.participant_id=user_id;
   delete from pad_access where pad_access.participant_id=user_id;
   delete from pad where pad.participant_id=user_id;
   delete from context_access where context_access.participant_id=user_id;
   delete from context where context.participant_id=user_id;
   */   
   delete from participant where participant.user_id=user_id;   
   /*
   delete from widget_dependency where widget_dependency.widget_id=widget.id and widget.creator_id=user_id;
   delete from widget where widget.creator_id=user_id;
   */
   /*
   delete from user_roles where user_roles.user_id=user_id;
   delete from users where users.user_name=lower(email_address);
   */
   update users 
   set users.user_name=concat(lower(email_address),'.',replace(uuid(),'-','.'),'.inactive'),
   users.status = 'inactive' 
   where users.user_name=lower(email_address);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_context` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_context`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN id integer,
							      IN grantor integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer default get_user_id(user_name);




	delete from element_access where (element_access.room_id=room_id and 
				      element_access.participant_id=participant_id and 
				      element_access.context_id=id);

	delete from element where (element.room_id=room_id and 
				   element.participant_id=participant_id and 
				   element.context_id=id);
	

	delete from pad_access where (pad_access.room_id=room_id and 
				      pad_access.participant_id=participant_id and 
				      pad_access.context_id=id);
	delete from pad where (pad.room_id=room_id and 
				   pad.participant_id=participant_id and 
				   pad.context_id=id);	
	
	
	/*delete all access granted by this context*/
	delete from context_access where (context_access.room_id=room_id and 
				   context_access.participant_id=participant_id and 
				   context_access.id=id);	

	delete from context where (context.room_id=room_id and 
				   context.participant_id=participant_id and 
				   context.id=id);
	update assignment_submission
	set assignment_submission.src_state = 'deleted'
	where
	assignment_submission.room_id=room_id and
	assignment_submission.user_id=participant_id and
	assignment_submission.src_context_id=id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_context_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_context_access`(
							      IN user_name varchar(128),
							      IN room_id integer,							      						      
							      IN id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	delete from pad_access where (pad_access.room_id=room_id and 
				      pad_access.participant_id=participant_id and 
				      pad_access.context_id=id);	

	delete from context_access where (context_access.room_id=room_id and 
				   context_access.participant_id=participant_id and 
				   context_access.id=id);	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_context_access_granted_to` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_context_access_granted_to`(
							      IN room_id integer,
							      IN participant_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	
	delete from pad_access where (pad_access.room_id=room_id and 
				      pad_access.participant_id=participant_id);	

	delete from context_access where (context_access.room_id=room_id and 
				   context_access.participant_id=participant_id);	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_element` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_element`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN context_id integer,
							      IN pad_id integer,
							      IN id integer,
							      IN grantor integer
							      )
    SQL SECURITY INVOKER
BEGIN 

	declare participant_id,nxt_insert_id integer default 0;
	declare read_access integer default 1;
	declare write_access integer default 2;
	declare delete_access integer default 8;
	declare read_write_access integer default (write_access | read_access);

	set participant_id = get_user_id(user_name);

	if has_context_access(grantor,room_id,context_id,participant_id,read_write_access) and
	   has_pad_access(grantor,room_id,context_id,pad_id,participant_id,read_write_access) and 
	   has_element_access(grantor,room_id,context_id,pad_id,id,participant_id,write_access|delete_access) then

	        delete from element_access where (element_access.room_id=room_id and 
				      element_access.participant_id=grantor and 
				      element_access.context_id=context_id and
				      element_access.pad_id=pad_id and
				      element_access.id=id);
	
		delete from element where (element.room_id=room_id and 
				   element.participant_id=grantor and 
				   element.context_id=context_id and
				   element.pad_id=pad_id and
				   element.id=id);

	
	
		select MAX(element.id) into nxt_insert_id from element where (element.room_id=room_id and 
				   element.participant_id=grantor and 
				   element.context_id=context_id and
				   element.pad_id=pad_id);
	end if;
	select  nxt_insert_id as 'last_insert_id';

/*
	declare pad_access_cnt,participant_id,nxt_insert_id integer;
	set participant_id = get_user_id(user_name);

	select 	count(pad.id) into pad_access_cnt
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.id=pad_id and
			       pad_access.granted_to=participant_id and
			       (
				 (pad_access.access & 2)>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and (context_access.access & 2)>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  pad.id=pad_id and
				  (
				    (pad.access_control & 2)>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and (context.access_control & 2)>0
				    )=1
				  )
				)
			 	and
				(
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id			  
				)
			    )
			)
		    )
		) ;


	if pad_access_cnt then
	        delete from element_access where (element_access.room_id=room_id and 
				      element_access.participant_id=grantor and 
				      element_access.context_id=context_id and
				      element_access.pad_id=pad_id and
				      element_access.id=id);
	
		delete from element where (element.room_id=room_id and 
				   element.participant_id=grantor and 
				   element.context_id=context_id and
				   element.pad_id=pad_id and
				   element.id=id);

	
	
		select MAX(element.id) into nxt_insert_id from element where (element.room_id=room_id and 
				   element.participant_id=grantor and 
				   element.context_id=context_id and
				   element.pad_id=pad_id);
	end if;
	select  nxt_insert_id as 'last_insert_id';*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_elements` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_elements`(
							      IN room_id integer,
							      IN context_id integer,
							      IN pad_id integer,							      
							      IN grantor integer
							      )
    SQL SECURITY INVOKER
BEGIN 

    DECLARE child_pad_id integer;  
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT pad.id FROM pad where (pad.room_id=room_id and pad.participant_id=grantor and pad.context_id=context_id and pad.parent_id=pad_id);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cur;
    read_loop: LOOP 
    FETCH cur INTO child_pad_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

	delete from element_access where (element_access.room_id=room_id and 
				      element_access.participant_id=grantor and 
				      element_access.context_id=context_id and
				      element_access.pad_id=child_pad_id);
	
	delete from element where (element.room_id=room_id and 
				   element.participant_id=grantor and 
				   element.context_id=context_id and
				   element.pad_id=child_pad_id);
    END LOOP;
    CLOSE cur;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_element_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_element_access`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN context_id integer,
                                                              IN pad_id integer,
							      IN id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	delete from element_access where (element_access.room_id=room_id and 
				      element_access.participant_id=participant_id and 
				      element_access.context_id=context_id and
				      element_access.pad_id=pad_id and
				      element_access.id=id);	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_pad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_pad`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN context_id integer,
							      IN id integer,
							      IN grantor integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer default get_user_id(user_name);
	declare old_pre_sibling integer default 0;

	        delete from element_access where (element_access.room_id=room_id and 
				      element_access.participant_id=/*grantor*/participant_id and 
				      element_access.context_id=context_id and
				      element_access.pad_id=id);

		delete from element where (element.room_id=room_id and 
				   element.participant_id=/*grantor*/participant_id and 
				   element.context_id=context_id and
				   (element.pad_id=id));
	
		
		/*delete elements of child pads*/
		call sp_del_elements(room_id,context_id,id,participant_id);
		/*delete any accesses granted by this pad*/

	   
	   select pad.pre_sibling into old_pre_sibling from pad
           where pad.room_id=room_id and 
           pad.participant_id = /*grantor*/participant_id and
           pad.context_id = context_id and
	   pad.id=id;




		delete from pad_access where (pad_access.room_id=room_id and 
				      pad_access.participant_id=/*grantor*/participant_id and 
				      pad_access.context_id=context_id and
				      pad_access.id=id);

		delete from pad where (pad.room_id=room_id and 
				   pad.participant_id=/*grantor*/participant_id and 
				   pad.context_id=context_id and
				   (pad.id=id or pad.parent_id=id));


	   /*update link pointer */
	   update pad set pad.pre_sibling = old_pre_sibling
           where pad.room_id=room_id and 
           pad.participant_id = /*grantor*/participant_id and
           pad.context_id = context_id and
	   pad.pre_sibling=id;


	update assignment_submission
	set assignment_submission.src_state = 'deleted'
	where
	assignment_submission.room_id=room_id and
	assignment_submission.user_id=participant_id and
	assignment_submission.src_context_id=context_id and
	assignment_submission.src_pad_id=id;	
/*
	declare pad_access_cnt,participant_id integer;
	set participant_id= get_user_id(user_name);
	select 	count(pad.id) into pad_access_cnt
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.id=id and
			       pad_access.granted_to=participant_id and
			       (
				 (pad_access.access & 2)>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and (context_access.access & 2)>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  pad.id=id and
				  (
				    (pad.access_control & 2)>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and (context.access_control & 2)>0
				    )=1
				  )
				)
			 	and
				(
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id			  
				)
			    )
			)
		    )
		) ;

	if pad_access_cnt=1 then
	        delete from element_access where (element_access.room_id=room_id and 
				      element_access.participant_id=grantor and 
				      element_access.context_id=context_id and
				      element_access.pad_id=id);

		delete from element where (element.room_id=room_id and 
				   element.participant_id=grantor and 
				   element.context_id=context_id and
				   element.pad_id=id);
	
		/*delete any accesses granted by this pad*

		delete from pad_access where (pad_access.room_id=room_id and 
				      pad_access.participant_id=grantor and 
				      pad_access.context_id=context_id and
				      pad_access.id=id);
		delete from pad where (pad.room_id=room_id and 
				   pad.participant_id=grantor and 
				   pad.context_id=context_id and
				   pad.id=id);
	end if;*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_pad_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_pad_access`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN context_id integer,
							      IN id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	delete from pad_access where (pad_access.room_id=room_id and 
				      pad_access.participant_id=participant_id and 
				      pad_access.context_id=context_id and
				      pad_access.id=id);	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_resource` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_resource`(IN user_name varchar(128),
								   IN widget_id integer,
								   IN file_name varchar(256),
								   IN env char(128))
    SQL SECURITY INVOKER
BEGIN 
       declare creator_id,legit integer;
       set creator_id = get_user_id(user_name);
       select count(widget.id) into legit from widget where widget.creator_id=creator_id and widget.id=widget_id;
	
       if env='dev' and legit=1 then
	delete from resource where (resource.widget_id=widget_id and resource.file_name=file_name);
       elseif env='rejected' and legit=1 then
	delete from rejected_resource where (rejected_resource.widget_id=widget_id and rejected_resource.file_name=file_name);
       end if;

/*       elseif env='queue' then
	delete from queue_resource where (queue_resource.widget_id=widget_id and queue_resource.file_name=file_name);
       elseif env='rejected' then
	delete from rejected_resource where (rejected_resource.widget_id=widget_id and rejected_resource.file_name=file_name);
       elseif env='prod' then        
 	delete from prod_resource where (prod_resource.widget_id=widget_id and prod_resource.file_name=file_name);
       end if;    */
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_user_from_role` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_user_from_role`(user_id integer,role_name varchar(256))
    SQL SECURITY INVOKER
BEGIN 
     declare role_id integer default 0;     
     select id into role_id from roles where role=role_name;
     delete from user_roles where (user_roles.user_id=user_id and user_roles.role_id=role_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_widget`(IN user_name varchar(128),IN id integer,IN env char(128))
BEGIN
       declare creator_id integer;
       declare legit_del integer;
       set creator_id = get_user_id(user_name);

       if env='dev' then
	 select count(widget.id) into legit_del from widget where (id=widget.id and (user_name='' or widget.creator_id=creator_id));     
    	 if legit_del>0 then
	   delete from resource where (widget_id=id);
           delete from widget where(widget.id=id);
           delete from widget_dependency where widget_dependency.widget_id=id;
         end if;  
       elseif env='queue' then       
        select count(queue_widget.id) into legit_del from queue_widget where (queue_widget.id=id and queue_widget.creator_id=creator_id);
        if legit_del>0 then     
	   delete from queue_resource where (widget_id=id);
           delete from queue_widget where(queue_widget.id=id); 
        end if;      
       elseif env='rejected' then       
        select count(rejected_widget.id) into legit_del from rejected_widget where (rejected_widget.id=id and rejected_widget.creator_id=creator_id);
        if legit_del>0 then     
	   delete from rejected_resource where (widget_id=id);
           delete from rejected_widget where(rejected_widget.id=id); 
        end if;
       elseif env='prod' then       
        select count(prod_widget.id) into legit_del from prod_widget where (prod_widget.id=id and (user_name='' or prod_widget.creator_id=creator_id));
        if legit_del>0 then     
	   delete from prod_resource where (widget_id=id);
           delete from prod_widget where(prod_widget.id=id); 
        end if;       
       end if;	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_widget_dependencies` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_widget_dependencies`(
								  IN widget_id integer)
    SQL SECURITY INVOKER
BEGIN 
	delete from widget_dependency where (widget_dependency.widget_id=widget_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_del_widget_dependency` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_del_widget_dependency`(
								  IN widget_id integer,
							      	  IN dependency_id varchar(256))
    SQL SECURITY INVOKER
BEGIN 
	delete from widget_dependency where (widget_dependency.widget_id=widget_id and widget_dependency.dependency_id=dependency_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_distribute_context` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_distribute_context`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN give_to_id integer,
							      IN context_id integer)
    SQL SECURITY INVOKER
BEGIN 
	DECLARE done INT DEFAULT 0;
	declare new_context_id,giver_id integer;	
	declare pad_id integer;
	declare old_pad_id integer;
	DECLARE pad_cur CURSOR FOR select pad.id,pad.access_control from pad where pad.context_id=new_context_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	set giver_id = get_user_id(user_name);

	/*copy the distributed context*/
 	insert into context (room_id,participant_id,config) 
 	(select context.room_id,give_to_id,context.config from context where context.room_id=room_id and context.participant_id=giver_id and context.id=context_id);
 	select LAST_INSERT_ID() into new_context_id;

	/*add access entries for all members of this room to this context object*/
	insert into context_access (room_id,participant_id,id,granted_to,access)
	select participant.room_id,give_to_id,new_context_id,participant.user_id,0 from participant where participant.room_id =room_id;

	/*grant all access to the owner*/
	update context_access set context_access.access=15 where context_access.room_id=room_id and
						  context_access.participant_id=give_to_id and
						  context_access.id=new_context_id and
						  context_access.granted_to=give_to_id;
	/*grant all access to giver*/
	update context_access set context_access.access=15 where context_access.room_id=room_id and
						  context_access.participant_id=give_to_id and
						  context_access.id=new_context_id and
						  context_access.granted_to=giver_id;


	select new_context_id as 'context_id';
	/*
	insert into pad (room_id,participant_id,context_id,config,access_control)
	select pad.room_id,give_to_id,new_context_id,pad.config,pad.id from pad where pad.room_id=room_id and pad.participant_id=giver_id and pad.context_id=context_id;
	


	
	OPEN pad_cur;
	REPEAT
	  FETCH pad_cur INTO pad_id,old_pad_id;
	     IF done=0 THEN
		/*add access entries for all members of this room to this pad*
		insert into pad_access (room_id,participant_id,context_id,id,granted_to,access)
		select room_id,give_to_id,new_context_id,pad_id,participant.user_id,0 from participant where participant.room_id =room_id;

		/*grant all access to the new owner*
		update pad_access set pad_access.access=3 where pad_access.room_id=room_id and
						  pad_access.participant_id=give_to_id and
						  pad_access.context_id=new_context_id and
						  pad_access.id=pad_id and
						  pad_access.granted_to=give_to_id;

		insert into element (room_id,participant_id,context_id,pad_id,config) 
		(select room_id,give_to_id,new_context_id,pad_id,element.config 
		from element where
		element.room_id=room_id and 
		element.participant_id=giver_id and 
		element.context_id=context_id and 
		element.pad_id=old_pad_id);

		/*This is a nasty hack, clear the access_control field which i used to save old id*
		/*update pad set access_control=0 where pad.room_id=room_id and pad.participant_id=give_to_id and pad.context_id = new_context_id;*
		set done=1;
	     END IF;
	  UNTIL done = 1 
	END REPEAT;
	CLOSE pad_cur;*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_accounts_receivable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_accounts_receivable`()
    SQL SECURITY INVOKER
BEGIN 
   
   select 
   id as "id",
   user_name as "userName",
   pass_word as "passWord",
   user_name as "emailAddress",
   name as "name",
   plan as 'plan',
   plan_status as 'planStatus',
   stripe_customer_id as 'stripeCustomerId',
   plan_start_date as 'planStartDate',
   next_billing_cycle_start_date as 'nextBillingCycleStartDate',
   last_invoice_date as 'lastInvoiceDate',
   last_invoice_id as 'lastInvoiceId',
   team_size as 'teamSize'
   from users where  (!is_super_user(users.id) and (users.status is null or users.status != 'inactive') and plan !='basic' and TIMESTAMPDIFF(DAY,next_billing_cycle_start_date,now())>=0)

   
   /*limit start,pagesize*/;
   
   /*
   PREPARE STMT FROM 
   'select 
   id as "id",
   user_name as "userName",
   pass_word as "passWord",
   user_name as "emailAddress",
   first_name as "firstName",
   last_name as "lastName" 
   from users  where users.status is null or users.status != "inactive" limit ?,?';
   EXECUTE STMT USING @start,@pagesize;
   */
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_account_signup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_account_signup`(IN domain_name varchar(128))
    SQL SECURITY INVOKER
BEGIN 
	declare account integer;

	select 
	count(account_signup.service_domain) into account
	from account_signup
	where(account_signup.service_domain = lower(domain_name));

        select account;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_all_deployed_applets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_all_deployed_applets`()
    SQL SECURITY INVOKER
BEGIN 	
	select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
	 from prod_widget where (prod_widget.show_in_menu='Yes');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_applets_by_toxonomy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_applets_by_toxonomy`(IN user_name varchar(128),IN category varchar(256))
    SQL SECURITY INVOKER
BEGIN 	
	declare creator_id integer;
	set creator_id = get_user_id(user_name);
	select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
	 from   widget where (  
                              (user_name='' or widget.creator_id=creator_id) and   
				(( (  ((category is null) or (category='default')) and (widget.dev_toxonomy is null or widget.dev_toxonomy='default'))  ) or  
				widget.dev_toxonomy = category));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_assignment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_assignment`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);
	
	select 
	assignment.user_id as 'userId',
	assignment.room_id as 'roomId',
	assignment.id as 'id',
	assignment.name as 'name',
	assignment.open_date_tm as 'openDate',
	assignment.close_date_tm as 'closeDate',
	assignment.status as 'status',	
	assignment.notification_id as 'notificationId',
	assignment.timezone as 'timeZone',
	assignment.allow_versioned_submission as 'allowVersioning',
	assignment.versioned_submission_limit as 'versioningLimit',
	assignment.first_reminder_date_tm as 'firstReminderDate',
	assignment.repeat_interval_in_minutes as 'reminderRepeatInterval',
	assignment.repeat_count as 'reminderRepeatCount'
	from assignment
	where(
              assignment.room_id=room_id and
	      assignment.id =id and 
	      assignment.status != 'archived' and
	      is_in_room(user_id,room_id));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_assignments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_assignments`(
							      IN user_name varchar(128),
							      IN room_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);
	
	select 
	assignment.user_id as 'userId',
	assignment.room_id as 'roomId',
	assignment.id as 'id',
	assignment.name as 'name',
	assignment.open_date_tm as 'openDate',
	assignment.close_date_tm as 'closeDate',	
	assignment.allow_versioned_submission as 'allowVersioning',
	assignment.versioned_submission_limit as 'versioningLimit',
	assignment.first_reminder_date_tm as 'firstReminderDate',
	assignment.repeat_interval_in_minutes as 'reminderRepeatInterval',
	assignment.repeat_count as 'reminderRepeatCount',
	assignment.status as 'status'	
	from assignment
	where(
              assignment.room_id=room_id and
	      assignment.status != 'archived' and
	      is_in_room(user_id,room_id));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_assignments_with_reminder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_assignments_with_reminder`()
    SQL SECURITY INVOKER
BEGIN 
	select 
	assignment.user_id as 'userId',
	assignment.room_id as 'roomId',
	assignment.id as 'id',
	assignment.name as 'name',
	assignment.open_date_tm as 'openDate',
	assignment.close_date_tm as 'closeDate',	
	assignment.allow_versioned_submission as 'allowVersioning',
	assignment.versioned_submission_limit as 'versioningLimit',
	assignment.first_reminder_date_tm as 'firstReminderDate',
	assignment.repeat_interval_in_minutes as 'reminderRepeatInterval',
	assignment.repeat_count as 'reminderRepeatCount',
	assignment.status as 'status'	
	from assignment
	where(assignment.status != 'archived' and 
              is_assignment_open(timezone,open_date_tm,close_date_tm) and
	      ((assignment.first_reminder_sent='no' and TIMESTAMPDIFF(MINUTE,assignment.first_reminder_date_tm,now())>=0) or (
	      assignment.repeat_count>0 and
	      TIMESTAMPDIFF(MINUTE,assignment.first_reminder_date_tm,now())>=assignment.repeat_interval_in_minutes)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_assignment_if_open` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_assignment_if_open`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);
	
	select 
	assignment.user_id as 'userId',
	assignment.room_id as 'roomId',
	assignment.id as 'id',
	assignment.name as 'name',
	assignment.open_date_tm as 'openDate',
	assignment.close_date_tm as 'closeDate',
	assignment.status as 'status',	
	assignment.notification_id as 'notificationId',
	assignment.timezone as 'timeZone',
	assignment.allow_versioned_submission as 'allowVersioning',
	assignment.versioned_submission_limit as 'versioningLimit',
	assignment.first_reminder_date_tm as 'firstReminderDate',
	assignment.repeat_interval_in_minutes as 'reminderRepeatInterval',
	assignment.repeat_count as 'reminderRepeatCount'
	from assignment
	where(
              assignment.room_id=room_id and
	      assignment.id =id and 
	      assignment.status != 'archived' and
	      is_in_room(user_id,room_id)and is_assignment_open(timezone,open_date_tm,close_date_tm));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_assignment_submission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_assignment_submission`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN src_context_id integer,
							      IN src_pad_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);

	select
	assignment_submission.room_id as 'roomId',
	assignment_submission.user_id as 'userId',
	assignment_submission.assignment_id as 'assignmentId',
	assignment_submission.context_id as 'contextId',
	assignment_submission.src_context_id as 'srcContextId',
	assignment_submission.src_pad_id as 'srcPadId'
	from assignment_submission where
	assignment_submission.room_id=room_id and
	assignment_submission.user_id=user_id and
	assignment_submission.src_context_id=src_context_id and
	assignment_submission.src_pad_id=src_pad_id and
	/*  src_pad_id=0 or assignment_submission.src_pad_id=src_pad_id) and*/
	assignment_submission.src_state = 'exists';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_assignment_submissions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_assignment_submissions`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN assignment_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);

	select
	assignment_submission.room_id as 'roomId',
	assignment_submission.user_id as 'userId',
	assignment_submission.assignment_id as 'assignmentId',
	assignment_submission.context_id as 'contextId',
	assignment_submission.src_context_id as 'srcContextId',
	assignment_submission.src_pad_id as 'srcPadId',
	convert_tz(assignment_submission.submit_time,'UTC',assignment.timezone) as 'submitTime'
	from assignment,assignment_submission where
	assignment.room_id=room_id and
	assignment.id=assignment_id and
	assignment.user_id=user_id and
	assignment_submission.room_id=room_id and
	assignment_submission.assignment_id=assignment_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_assignment_submission_from_source` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_assignment_submission_from_source`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN src_context_id integer,
							      IN src_pad_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);

	select
	assignment_submission.room_id as 'roomId',
	assignment_submission.user_id as 'userId',
	assignment_submission.assignment_id as 'assignmentId',
	assignment_submission.context_id as 'contextId',
	assignment_submission.src_context_id as 'srcContextId',
	assignment_submission.src_pad_id as 'srcPadId',
	convert_tz(assignment_submission.submit_time,'UTC',assignment.timezone) as 'submitTime'
	from assignment,assignment_submission where
	assignment.room_id=room_id and
	assignment_submission.room_id=assignment.room_id and
	assignment_submission.assignment_id=assignment.id and
	assignment_submission.user_id=user_id and
	assignment_submission.src_context_id=src_context_id and
	assignment_submission.src_pad_id=src_pad_id and
	assignment_submission.src_state = 'exists';	

	/*from assignment_submission where
	assignment_submission.room_id=room_id and
	assignment_submission.user_id=user_id and
	assignment_submission.src_context_id=src_context_id and
	assignment_submission.src_pad_id=src_pad_id and
	assignment_submission.src_state = 'exists';
	*/
	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_catalog_page_widgets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_catalog_page_widgets`(IN category varchar(256),IN catalog_page_index integer)
    SQL SECURITY INVOKER
BEGIN 	
	 select prod_widget.price,
		prod_widget.default_instance as 'defaultInstance' 
		from prod_widget where (prod_widget.category=category and prod_widget.catalog_page_index=catalog_page_index) order by id asc;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_context` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_context`(
								  IN user_name varchar(128),
								  IN room_id integer,								  
							          IN id integer,
								  IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer default get_user_id(user_name);

	declare read_access integer default 1;
	declare write_access integer default 2;
	declare read_write_access integer default (write_access & read_access);
	

	select 	context.room_id as 'roomId',
		context.participant_id as 'participantId',
		context.id as 'id',
		context.config as 'config',
		context.created_by as 'createdBy',
		UNIX_TIMESTAMP(context.create_date) as 'createDate',
		context.access_control as 'accessControl',
		context_access.access/*context.access_control*/ as 'access'
                
		from context,context_access where 
		context.room_id=room_id and
		context.participant_id=grantor and
	        context.id=id and
		has_context_access(grantor,room_id,context.id,participant_id,read_access) and

		context_access.room_id=context.room_id and 
		context_access.participant_id=grantor and
		context_access.granted_to=participant_id and
		context_access.id=context.id;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_contexts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_contexts`(
								   IN user_name varchar(128),
								   IN room_id integer,
								   IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;

	declare read_access integer default 1;
	declare write_access integer default 2;
	declare read_write_access integer default (write_access & read_access);


	set participant_id = get_user_id(user_name);
	

	select 	context.room_id as 'roomId',
		context.participant_id as 'participantId',
		context.id as 'id',
		context.config as 'config',
		context.created_by as 'createdBy',
		UNIX_TIMESTAMP(context.create_date) as 'createDate',
		context.access_control as 'accessControl',
		context_access.access/*context.access_control*/ as 'access'
                
		from context,context_access where 
		context.room_id=room_id and
		context.participant_id=grantor and
		has_context_access(grantor,room_id,context.id,participant_id,read_access) and

		context_access.room_id=context.room_id and 
		context_access.participant_id=grantor and
		context_access.granted_to=participant_id and
		context_access.id=context.id;
/*
	select 	context.room_id as 'roomId',
		context.participant_id as 'participantId',
		context.id as 'id',
		context.config as 'config',
		context.access_control as 'accessControl',
		context_access.access as 'access'
		from context,context_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       context_access.room_id=room_id and 
			       context_access.participant_id=grantor and
			       context_access.granted_to=participant_id and			       
			       (
				 context_access.access>0
			         or
			    	 (
			       	   select count(pad_access.id) from pad_access where pad_access.room_id=context_access.room_id and pad_access.participant_id=context_access.participant_id and pad_access.context_id=context_access.id and pad_access.granted_to=context_access.granted_to and pad_access.access>0
			         )>0
			       )
			    )
		    	    and		
		    	    (
				context.room_id=context_access.room_id and
				context.participant_id=context_access.participant_id and
				context.id=context_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				context.room_id=room_id and
				context.participant_id=grantor and
				(
				  context.access_control>0
				  or
				  (
				    select count(pad.id) from pad where pad.room_id=context.room_id and pad.participant_id=context.participant_id and pad.context_id=context.id and pad.access_control>0
				  )>0
			 	)
				and
				(				  
				  context_access.room_id=context.room_id and
				  context_access.participant_id=context.participant_id and
				  context_access.id=context.id	and
				  context_access.granted_to=participant_id				  
				)
			    )
			)
		    )
		)order by id asc ;*/
		
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_context_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_context_access`(
								  IN user_name varchar(128),
							          IN room_id integer,								  
							          IN id integer,
								  IN granted_to integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	select 
	room_id as 'roomId',
	participant_id as 'participantId',
	id as 'id',
	access as 'access',
	granted_to as 'grantedTo' 

	from context_access where 
					context_access.room_id=room_id and 
					context_access.participant_id=participant_id and 
					context_access.id=id and
					context_access.granted_to=granted_to;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_context_access_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_context_access_list`(
								  IN user_name varchar(128),
								  IN room_id integer,								  
								  IN granted_to integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	select 
	room_id as 'roomId',
	participant_id as 'participantId',
	id as 'id',
	access as 'access',
	granted_to as 'grantedTo'
	from context_access where context_access.room_id=room_id and 
						   context_access.participant_id=participant_id and
						   context_access.granted_to=granted_to;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_context_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_context_count`(
								  IN user_name varchar(128),
								  IN room_id integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer default get_user_id(user_name);
	declare cnt integer default 0;

	select 	count(context.id) into cnt                
		from context where 
		context.room_id=room_id and
		context.participant_id=participant_id;
        select cnt as 'count';

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_datastatement_preexecution_handlers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_datastatement_preexecution_handlers`(IN user_name varchar(256),	
											     IN datastatement_id varchar(256))
    SQL SECURITY INVOKER
BEGIN 	
	declare user_id integer default get_user_id(user_name);


select
datastatement_preexecution_handler.id as 'id',
datastatement_preexecution_handler.datastatement_id as 'dataStatementId',
datastatement_preexecution_handler.datastatement_id as 'definitionId',
datastatement_preexecution_handler.definition_invocation_id as 'definitionInvocationId',
datastatement_preexecution_handler.enabled as 'enabled',		
datastatement_preexecution_handler.path as 'path',
datastatement_preexecution_handler.type as 'type',
datastatement_preexecution_handler.return_val_name as 'returnValName',
datastatement_preexecution_handler.allow_override as 'allowOverride',
datastatement_preexecution_handler.description as 'description',
definition_invocation.invoked_by as 'invokedBy',
definition_invocation.name as 'name',
definition_invocation.return_val_as_arg as 'returnValAsArg'
from datastatement_preexecution_handler,definition_invocation,datastatement_accesscontrol
where
(
   datastatement_preexecution_handler.datastatement_id=datastatement_id and
   definition_invocation.id=datastatement_preexecution_handler.definition_invocation_id and
   (
      datastatement_accesscontrol.datastatement_key=datastatement_preexecution_handler.datastatement_id and
	  (
		datastatement_accesscontrol.user_id=user_id or 
		(
         	select count(user_roles.role_id) from 
         	user_roles where user_roles.user_id=user_id and user_roles.role_id=datastatement_accesscontrol.role_id
       	)>0
	  ) 
      and 
	  (
		 datastatement_accesscontrol.read_access='yes' or datastatement_accesscontrol.write_access='yes'
	  )
   )  
);

/*
	select
	datastatement_preexecution_handler.id as 'id',
	datastatement_preexecution_handler.datastatement_id as 'dataStatementId',
	datastatement_preexecution_handler.enabled as 'enabled',		
	datastatement_preexecution_handler.name as 'name',
	datastatement_preexecution_handler.type as 'type',
	datastatement_preexecution_handler.path as 'path',
	datastatement_preexecution_handler.description as 'description',
	datastatement_preexecution_handler.return_val_name as 'returnValName',
	datastatement_preexecution_handler.allow_override as 'allowOverride',
	definition_invocation.name as 'name',
	definition_invocation.return_val_as_arg as 'returnValAsArg'
	from datastatement_preexecution_handler,definition_invocation,datastatement_accesscontrol where
	(
		datastatement_preexecution_handler.datastatement_id=datastatement_id and
		definition_invocation.id=datastatement_preexecution_handler.definition_invocation_id and
   		datastatement_accesscontrol.datastatement_key=datastatement_preexecution_handler.datastatement_id and
   		(
	  	  (
			datastatement_accesscontrol.user_id=user_id or 
			(
         		select count(user_roles.role_id) from 
         		user_roles where user_roles.user_id=user_id and user_roles.role_id=datastatement_accesscontrol.role_id
       			)>0
	           ) 
                  and 
	          (
		    datastatement_accesscontrol.read_access='yes' or datastatement_accesscontrol.write_access='yes'
	          )
   		)  
	);*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_days_to_next_billing_cycle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_days_to_next_billing_cycle`(
								  IN user_name varchar(128))
    SQL SECURITY INVOKER
BEGIN 	
   declare days integer default 0;

   select 
   datediff (users.next_billing_cycle_start_date,now()) into days
   from users where users.next_billing_cycle_start_date != null && users.user_name=lower(user_name);

   select days as 'days';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_element` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_element`(
							       IN user_name varchar(128),
							       IN room_id integer,
							       IN context_id integer,
							       IN pad_id integer,
							       IN id integer,
							       IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;

	declare read_write_access integer;
	declare read_access integer;
	declare write_access integer;
	set read_access = 1;
	set write_access = 2;
	set read_write_access = 3;

	set participant_id = get_user_id(user_name);
	
	select 
	   element.room_id as 'roomId',
           element.participant_id as 'participantId',
           element.context_id as 'contextId',
           element.pad_id as 'padId',
           element.id as 'id',
           element.config as 'config',
	   element.created_by as 'createdBy',
	   UNIX_TIMESTAMP(element.create_date) as 'createDate',
	   element.access_control as 'accessControl',
	   element_access.access/*element.access_control*/ as 'access'

	   from element,element_access where
	   element.room_id=room_id and
	   element.participant_id=grantor and
	   element.context_id=context_id and
	   element.pad_id=pad_id and
	   element.id = id and
	   has_context_access(grantor,room_id,context_id,participant_id,read_access) and
	   has_pad_access(grantor,room_id,context_id,pad_id,participant_id,read_access) and
	   has_element_access(grantor,room_id,context_id,pad_id,element.id,participant_id,read_access) and

	   element_access.room_id=element.room_id and 
	   element_access.participant_id=grantor and
	   element_access.granted_to=participant_id and
	   element_access.context_id=element.context_id and
	   element_access.pad_id=element.pad_id and
	   element_access.id=element.id;
	/*
	select * from element where element.room_id=room_id and 
		      element.participant_id=participant_id and 
		      element.context_id=context_id and
		      element.pad_id=pad_id;
	*/
	

/*
	select 	count(pad.id) into pad_access_cnt
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.id=pad_id and
			       pad_access.granted_to=participant_id and
			       (
				 pad_access.access>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and context_access.access>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  pad.id=pad_id and
				  (
				    pad.access_control>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and context.access_control>0
				    )=1
				  )
				)
			 	and
				(
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id			  
				)
			    )
			)
		    )
		) ;


	/*
	if pad_access_cnt=1 then
	   select 
	   element.room_id as 'roomId',
           element.participant_id as 'participantId',
           element.context_id as 'contextId',
           element.pad_id as 'padId',
           element.id as 'id',
           element.config as 'config',
	   element.access_control as 'accessControl',
	   element_access.access as 'access'

	   from element,element_access where (element.room_id=room_id and 
		      element.participant_id=grantor and 
		      element.context_id=context_id and
		      element.pad_id=pad_id) order by id asc;
	else
	   select * from element where false;
	end if;
	*
	
	if pad_access_cnt=1 then
	   select 
	   element.room_id as 'roomId',
           element.participant_id as 'participantId',
           element.context_id as 'contextId',
           element.pad_id as 'padId',
           element.id as 'id',
           element.config as 'config',
	   element.access_control as 'accessControl',
	   element_access.access as 'access'

	   from element,element_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       element_access.room_id=room_id and 
			       element_access.participant_id=grantor and
			       element_access.context_id=context_id and
			       element_access.pad_id=pad_id and
			       element_access.granted_to=participant_id and
			       (
				 element_access.access>0
			         or
			    	 (
			       	   select count(pad_access.id) from pad_access where 
				   pad_access.room_id=element_access.room_id and 
				   pad_access.participant_id=element_access.participant_id and 
				   pad_access.context_id=element_access.context_id and 
                                   pad_access.id=element_access.pad_id and 
                                   pad_access.granted_to=element_access.granted_to and 
                                   pad_access.access>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				element.room_id=element_access.room_id and
				element.participant_id=element_access.participant_id and
				element.context_id=element_access.context_id and
				element.pad_id=element_access.pad_id and
				element.id=element_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  element.room_id=room_id and
				  element.participant_id=grantor and
				  element.context_id=context_id and
				  element.pad_id=pad_id and
				  (
				    element.access_control>0
				    or
				    (
				      select count(pad.id) from pad where pad.room_id=element.room_id and pad.participant_id=element.participant_id and pad.context_id=element.context_id and pad.id=element.pad_id and pad.access_control>0
				    )=1
				  )
				)
			 	and
				(
				  (
				  element_access.room_id=element.room_id and
				  element_access.participant_id=element.participant_id and
				  element_access.context_id=element.context_id and
				  element_access.pad_id=element.pad_id and
				  element_access.id=element.id and
				  element_access.granted_to=participant_id
				  )	  
				)
			    )
			)
		    )
		)order by id asc ;
	else
	   select * from element where false;
	end if;*/
	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_elements` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_elements`(
							       IN user_name varchar(128),
							       IN room_id integer,
							       IN context_id integer,
							       IN pad_id integer,
							       IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;

	declare read_write_access integer;
	declare read_access integer;
	declare write_access integer;
	set read_access = 1;
	set write_access = 2;
	set read_write_access = 3;

	set participant_id = get_user_id(user_name);
	
	select 
	   element.room_id as 'roomId',
           element.participant_id as 'participantId',
           element.context_id as 'contextId',
           element.pad_id as 'padId',
           element.id as 'id',
           element.config as 'config',
	   element.created_by as 'createdBy',
	   UNIX_TIMESTAMP(element.create_date) as 'createDate',
	   element.access_control as 'accessControl',
	   element_access.access/*element.access_control*/ as 'access'

	   from element,element_access where
	   element.room_id=room_id and
	   element.participant_id=grantor and
	   element.context_id=context_id and
	   element.pad_id=pad_id and
	   has_context_access(grantor,room_id,context_id,participant_id,read_access) and
	   has_pad_access(grantor,room_id,context_id,pad_id,participant_id,read_access) and
	   has_element_access(grantor,room_id,context_id,pad_id,element.id,participant_id,read_access) and

	   element_access.room_id=element.room_id and 
	   element_access.participant_id=grantor and
	   element_access.granted_to=participant_id and
	   element_access.context_id=element.context_id and
	   element_access.pad_id=element.pad_id and
	   element_access.id=element.id;
	/*
	select * from element where element.room_id=room_id and 
		      element.participant_id=participant_id and 
		      element.context_id=context_id and
		      element.pad_id=pad_id;
	*/
	

/*
	select 	count(pad.id) into pad_access_cnt
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.id=pad_id and
			       pad_access.granted_to=participant_id and
			       (
				 pad_access.access>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and context_access.access>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  pad.id=pad_id and
				  (
				    pad.access_control>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and context.access_control>0
				    )=1
				  )
				)
			 	and
				(
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id			  
				)
			    )
			)
		    )
		) ;


	/*
	if pad_access_cnt=1 then
	   select 
	   element.room_id as 'roomId',
           element.participant_id as 'participantId',
           element.context_id as 'contextId',
           element.pad_id as 'padId',
           element.id as 'id',
           element.config as 'config',
	   element.access_control as 'accessControl',
	   element_access.access as 'access'

	   from element,element_access where (element.room_id=room_id and 
		      element.participant_id=grantor and 
		      element.context_id=context_id and
		      element.pad_id=pad_id) order by id asc;
	else
	   select * from element where false;
	end if;
	*
	
	if pad_access_cnt=1 then
	   select 
	   element.room_id as 'roomId',
           element.participant_id as 'participantId',
           element.context_id as 'contextId',
           element.pad_id as 'padId',
           element.id as 'id',
           element.config as 'config',
	   element.access_control as 'accessControl',
	   element_access.access as 'access'

	   from element,element_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       element_access.room_id=room_id and 
			       element_access.participant_id=grantor and
			       element_access.context_id=context_id and
			       element_access.pad_id=pad_id and
			       element_access.granted_to=participant_id and
			       (
				 element_access.access>0
			         or
			    	 (
			       	   select count(pad_access.id) from pad_access where 
				   pad_access.room_id=element_access.room_id and 
				   pad_access.participant_id=element_access.participant_id and 
				   pad_access.context_id=element_access.context_id and 
                                   pad_access.id=element_access.pad_id and 
                                   pad_access.granted_to=element_access.granted_to and 
                                   pad_access.access>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				element.room_id=element_access.room_id and
				element.participant_id=element_access.participant_id and
				element.context_id=element_access.context_id and
				element.pad_id=element_access.pad_id and
				element.id=element_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  element.room_id=room_id and
				  element.participant_id=grantor and
				  element.context_id=context_id and
				  element.pad_id=pad_id and
				  (
				    element.access_control>0
				    or
				    (
				      select count(pad.id) from pad where pad.room_id=element.room_id and pad.participant_id=element.participant_id and pad.context_id=element.context_id and pad.id=element.pad_id and pad.access_control>0
				    )=1
				  )
				)
			 	and
				(
				  (
				  element_access.room_id=element.room_id and
				  element_access.participant_id=element.participant_id and
				  element_access.context_id=element.context_id and
				  element_access.pad_id=element.pad_id and
				  element_access.id=element.id and
				  element_access.granted_to=participant_id
				  )	  
				)
			    )
			)
		    )
		)order by id asc ;
	else
	   select * from element where false;
	end if;*/
	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_element_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_element_access`(
								  IN user_name varchar(128),
								  IN room_id integer,								  
								  IN context_id integer,
        							  IN pad_id integer,
							          IN id integer,
								  IN granted_to integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	select 
	room_id as 'roomId',
	participant_id as 'participantId',
	context_id as 'contextId',
        pad_id as 'padId',
	id as 'id',
	access as 'access'
	from element_access where 
					element_access.room_id=room_id and 
					element_access.participant_id=participant_id and 
					element_access.context_id=context_id and
                                        element_access.pad_id=pad_id and
					element_access.id=id and
					element_access.granted_to=granted_to;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_element_access_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_element_access_list`(
							       IN user_name varchar(128),
							       IN room_id integer,							       
							       IN context_id integer,
							       IN pad_id integer,
							       IN granted_to integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	select 
	room_id as 'roomId',
	participant_id as 'participantId',
	context_id as 'contextId',
        pad_id as 'padId',
	id as 'id',
	access as 'access'
	from element_access where element_access.room_id=room_id and 
				element_access.participant_id=participant_id and 
				element_access.context_id=context_id and
				element_access.pad_id=pad_id and
				element_access.granted_to=granted_to;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_embeded_elements` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_embeded_elements`(
							       IN room_id integer,
							       IN context_id integer,
							       IN pad_id integer,
							       IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;
        declare pad_access_cnt integer;
        set participant_id = grantor;

	


	/*
	select * from element where element.room_id=room_id and 
		      element.participant_id=participant_id and 
		      element.context_id=context_id and
		      element.pad_id=pad_id;
	*/
	
	select 	count(pad.id) into pad_access_cnt
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*/
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.id=pad_id and
			       pad_access.granted_to=participant_id and
			       (
				 pad_access.access>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and context_access.access>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*/
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  pad.id=pad_id and
				  (
				    pad.access_control>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and context.access_control>0
				    )=1
				  )
				)
			 	and
				(
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id			  
				)
			    )
			)
		    )
		) ;


	
	if pad_access_cnt=1 then
	   select 
	   element.room_id as 'roomId',
           element.participant_id as 'participantId',
           element.context_id as 'contextId',
           element.pad_id as 'padId',
           element.id as 'id',
           element.config as 'config'

	   from element where (element.room_id=room_id and 
		      element.participant_id=grantor and 
		      element.context_id=context_id and
		      element.pad_id=pad_id) order by id asc;
	else
	   select * from element where false;
	end if;
	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_embeded_pad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_embeded_pad`(IN embed_key varchar(128))
    SQL SECURITY INVOKER
BEGIN 	
	
	
	select 	pad.room_id as 'roomId',
		pad.participant_id as 'participantId',
		pad.context_id as 'contextId',
		pad.id as 'id',
                pad.embed_key as 'embedKey',
		pad.config as 'config',
		pad.access_control as 'accessControl'
		from pad where pad.embed_key = embed_key and (pad.access_control & 16)>0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_feature_matrix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_feature_matrix`()
    SQL SECURITY INVOKER
BEGIN 
    select 
    id as 'id',
    name as 'name',
    display as 'display',
    basic_plan_limit as 'basicPlanLimit',
    individual_plan_limit as 'individualPlanLimit',
    team_plan_limit as 'teamPlanLimit',
    display_text as 'displayText',
    basic_plan_limit_display_text as 'basicPlanLimitDisplayText',
    individual_plan_limit_display_text as 'individualPlanLimitDisplayText',
    team_plan_limit_display_text as 'teamPlanLimitDisplayText'
    from feature_matrix;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_feature_matrix_entry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_feature_matrix_entry`(name varchar(256))
    SQL SECURITY INVOKER
BEGIN 
    select 
    feature_matrix.id as 'id',
    feature_matrix.name as 'name',
    display as 'display',
    feature_matrix.basic_plan_limit as 'basicPlanLimit',
    feature_matrix.individual_plan_limit as 'individualPlanLimit',
    feature_matrix.team_plan_limit as 'teamPlanLimit',
    display_text as 'displayText',
    basic_plan_limit_display_text as 'basicPlanLimitDisplayText',
    individual_plan_limit_display_text as 'individualPlanLimitDisplayText',
    team_plan_limit_display_text as 'teamPlanLimitDisplayText'
    from feature_matrix where feature_matrix.name=name;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_feature_usage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_feature_usage`(user_name varchar(256),feature_id integer)
    SQL SECURITY INVOKER
BEGIN 
    declare user_id integer default get_user_id(user_name);
    select 
    feature_usage_matrix.user_id as 'userId',
    feature_usage_matrix.feature_id as 'featureId',
    feature_usage_matrix.usage as 'usage'
    from feature_usage_matrix where feature_usage_matrix.user_id=user_id and feature_usage_matrix.feature_id=feature_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_menu_widgets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_menu_widgets`(IN category varchar(256))
    SQL SECURITY INVOKER
BEGIN 	
	select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage'
	 from prod_widget where (prod_widget.category=category and prod_widget.show_in_menu='Yes');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_notification` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_notification`(
							      IN id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	select
	notifications.id as 'id',
        notifications.start_time as 'startTime',
	notifications.end_time as 'endTime',
	notifications.timezone as 'timeZone',
	notifications.repeat_interval as 'repeatInterval',
	notifications.repeat_interval_count as 'repeatIntervalCount',
        notifications.variable_definitions as 'variableDefinitions',
	notifications.message_template as 'messageTemplate',
	notifications.messaging_medium as 'messagingMedium',
	notifications.state as 'state'
	from notifications
 	where  notifications.id=id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_open_assignments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_open_assignments`(
							      IN user_name varchar(128),
							      IN room_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);
	
	select 
	assignment.user_id as 'userId',
	assignment.room_id as 'roomId',
	assignment.id as 'id',
	assignment.name as 'name',
	assignment.open_date_tm as 'openDate',
	assignment.close_date_tm as 'closeDate',	
	assignment.status as 'status'	
	from assignment
	where(assignment.room_id=room_id/* and assignment.status='open'*/and is_assignment_open(timezone,open_date_tm,close_date_tm) and is_in_room(user_id,room_id));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_packaged_applets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_packaged_applets`(
				   IN package_id varchar(128))
BEGIN 
	select  
	packaged_applets.package_id  as 'packageId',
        packaged_applets.id          as 'id',
        packaged_applets.name        as 'name',
        packaged_applets.description as 'description',
        packaged_applets.installed   as 'installed',
        packaged_applets.applet_id   as 'appletId',
        get_category(packaged_applets.installed,packaged_applets.applet_id) as 'category'
	from packaged_applets where  packaged_applets.package_id=package_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_packages` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_packages`()
BEGIN 
	select 
	*
        from applet_package;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_pad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_pad`(
							       IN user_name varchar(128),
							       IN room_id integer,							       
							       IN context_id integer,
							       IN id integer,
							       IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer default get_user_id(user_name);
	declare read_access integer default 1;
	declare write_access integer default 2;
	declare read_write_access integer default (write_access | read_access);

	select 	pad.room_id as 'roomId',
		pad.participant_id as 'participantId',
		pad.context_id as 'contextId',
		pad.parent_id as 'parentId',
		pad.pre_sibling as 'preSibling',
		pad.id as 'id',
                pad.embed_key as 'embedKey',
		pad.config as 'config',
		pad.created_by as 'createdBy',
		UNIX_TIMESTAMP(pad.create_date) as 'createDate',
		pad.access_control as 'accessControl',
		pad_access.access/*pad.access_control*/ as 'access'

		from pad,pad_access where 
		pad.room_id=room_id and
		pad.participant_id=grantor and
		pad.context_id=context_id and
		pad.id=id and
		has_context_access(grantor,room_id,context_id,participant_id,read_access) and
		has_pad_access(grantor,room_id,context_id,pad.id,participant_id,read_access) and

		pad_access.room_id=pad.room_id and 
		pad_access.participant_id=grantor and
		pad_access.granted_to=participant_id and
		pad_access.context_id=pad.context_id and
		pad_access.id=pad.id;

/*	select 	pad.room_id as 'roomId',
		pad.participant_id as 'participantId',
		pad.context_id as 'contextId',
		pad.id as 'id',
                pad.embed_key as 'embedKey',
		pad.config as 'config',
		pad.access_control as 'accessControl',
		pad_access.access as 'access'
               
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.granted_to=participant_id and
			       (
				 pad_access.access>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and context_access.access>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  (
				    pad.access_control>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and context.access_control>0
				    )=1
				  )
				)
			 	and
				(
				  (
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id
				  )	  
				)
			    )
			)
		    )
		)order by id asc ;*/

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_pads` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_pads`(
							       IN user_name varchar(128),
							       IN room_id integer,							       
							       IN context_id integer,
							       IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer default get_user_id(user_name);
	declare read_access integer default 1;
	declare write_access integer default 2;
	declare read_write_access integer default (write_access | read_access);

	select 	pad.room_id as 'roomId',
		pad.participant_id as 'participantId',
		pad.context_id as 'contextId',
		pad.parent_id as 'parentId',
		pad.pre_sibling as 'preSibling',
		pad.id as 'id',
                pad.embed_key as 'embedKey',
		pad.config as 'config',
		pad.created_by as 'createdBy',
		UNIX_TIMESTAMP(pad.create_date) as 'createDate',
		pad.access_control as 'accessControl',
		pad_access.access /*pad.access*/ as 'access'

		from pad,pad_access where 
		pad.room_id=room_id and
		pad.participant_id=grantor and
		pad.context_id=context_id and
		has_context_access(grantor,room_id,context_id,participant_id,read_access) and
		has_pad_access(grantor,room_id,context_id,pad.id,participant_id,read_access) and

		pad_access.room_id=pad.room_id and 
		pad_access.participant_id=grantor and
		pad_access.granted_to=participant_id and
		pad_access.context_id=pad.context_id and
		pad_access.id=pad.id;

/*	select 	pad.room_id as 'roomId',
		pad.participant_id as 'participantId',
		pad.context_id as 'contextId',
		pad.id as 'id',
                pad.embed_key as 'embedKey',
		pad.config as 'config',
		pad.access_control as 'accessControl',
		pad_access.access as 'access'
               
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.granted_to=participant_id and
			       (
				 pad_access.access>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and context_access.access>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  (
				    pad.access_control>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and context.access_control>0
				    )=1
				  )
				)
			 	and
				(
				  (
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id
				  )	  
				)
			    )
			)
		    )
		)order by id asc ;*/

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_pad_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_pad_access`(
								  IN user_name varchar(128),
								  IN room_id integer,								  
								  IN context_id integer,
							          IN id integer,
								  IN granted_to integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	select 
	room_id as 'roomId',
	participant_id as 'participantId',
	context_id as 'contextId',
	id as 'id',
	access as 'access'
	from pad_access where 
					pad_access.room_id=room_id and 
					pad_access.participant_id=participant_id and 
					pad_access.context_id=context_id and
					pad_access.id=id and
					pad_access.granted_to=granted_to;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_pad_access_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_pad_access_list`(
							       IN user_name varchar(128),
							       IN room_id integer,							       
							       IN context_id integer,
							       IN granted_to integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
	select 
	room_id as 'roomId',
	participant_id as 'participantId',
	context_id as 'contextId',
	id as 'id',
	access as 'access'
	from pad_access where pad_access.room_id=room_id and 
				pad_access.participant_id=participant_id and 
				pad_access.context_id=context_id and
				pad_access.granted_to=granted_to;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_pad_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_pad_count`(
								  IN user_name varchar(128),
								  IN room_id integer,
								  IN context_id integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare participant_id integer default get_user_id(user_name);

	declare cnt integer default 0;
	select 	count(pad.id) into cnt
		from pad where 
		pad.room_id=room_id and
		pad.participant_id=participant_id and
		pad.context_id=context_id;
	select cnt as 'count';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_participant` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_participant`(IN room_id integer,IN participant_id integer)
    SQL SECURITY INVOKER
BEGIN 

   select 
	participant.user_id as 'userId',
	/*replace(users.name,"'","\\'")*/users.name as 'name',	
	users.user_name as 'userName'
   from users,participant where (participant.room_id=room_id and participant.user_id=participant_id and participant.user_id=users.id);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_participants` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_participants`(IN room_id integer)
    SQL SECURITY INVOKER
BEGIN 
   select 
	participant.user_id as 'userId',
	/*replace(users.name,"'","\\'")*/users.name as 'name',	
	users.user_name as 'userName'
   from users,participant where (participant.room_id=room_id and participant.user_id=users.id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_resource` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_resource`(IN user_name varchar(128),
								   IN widget_id integer,
								   IN file_name varchar(256),
								   IN env char(128))
    SQL SECURITY INVOKER
BEGIN 
       if env='dev' then
	select 
	widget_id as 'widgetId',
	file_name as 'fileName',
	label,
	fs_name as 'fsName',
	type,
	mime,
	size,
	create_date as 'createDate',
	last_mod_date as 'lastModDate'
 	from resource where resource.widget_id=widget_id and resource.file_name=file_name;
       elseif env='queue' then
        select 
	widget_id as 'widgetId',
	file_name as 'fileName',
	label,
	fs_name as 'fsName',
	type,
	mime,
	size,
	create_date as 'createDate',
	last_mod_date as 'lastModDate'
	from queue_resource where queue_resource.widget_id=widget_id and queue_resource.file_name=file_name;
       elseif env='rejected' then
        select 
	widget_id as 'widgetId',
	file_name as 'fileName',
	label,
	fs_name as 'fsName',
	type,
	mime,
	size,
	create_date as 'createDate',
	last_mod_date as 'lastModDate'
	 from rejected_resource where rejected_resource.widget_id=widget_id and rejected_resource.file_name=file_name;
       else
        select 
	widget_id as 'widgetId',
	file_name as 'fileName',
	label,
	fs_name as 'fsName',
	type,
	mime,
	size,
	create_date as 'createDate',
	last_mod_date as 'lastModDate'
	from prod_resource where prod_resource.widget_id=widget_id and prod_resource.file_name=file_name;
       end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_resources` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_resources`(IN user_name varchar(128),
								    IN widget_id integer,
								    IN env char(128))
    SQL SECURITY INVOKER
BEGIN 
       if env='dev' then
	select 
	widget_id as 'widgetId',
	file_name as 'fileName',
	label,
	fs_name as 'fsName',
	type,
	mime,
	size,
	create_date as 'createDate',
	last_mod_date as 'lastModDate'
	from resource where resource.widget_id=widget_id;
       elseif env='queue' then        
        select 
	widget_id as 'widgetId',
	file_name as 'fileName',
	label,
	fs_name as 'fsName',
	type,
	mime,
	size,
	create_date as 'createDate',
	last_mod_date as 'lastModDate'
	 from queue_resource where queue_resource.widget_id=widget_id;
       elseif env='rejected' then        
        select 
	widget_id as 'widgetId',
	file_name as 'fileName',
	label,
	fs_name as 'fsName',
	type,
	mime,
	size,
	create_date as 'createDate',
	last_mod_date as 'lastModDate'
	 from rejected_resource where rejected_resource.widget_id=widget_id;
       elseif env='prod' then
        select 
	widget_id as 'widgetId',
	file_name as 'fileName',
	label,
	fs_name as 'fsName',
	type,
	mime,
	size,
	create_date as 'createDate',
	last_mod_date as 'lastModDate'
	 from prod_resource where prod_resource.widget_id=widget_id;
       end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_roles` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_roles`()
    SQL SECURITY INVOKER
BEGIN 
	select roles.role from roles;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_room` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_room`(IN user_name varchar(256),IN room_id integer)
    SQL SECURITY INVOKER
BEGIN 
    declare user_id integer;
    set user_id = get_user_id(user_name);

    select 
    room.id as 'id',
    /*replace(room.title,"'","\\'")*/room.title as 'title',
    room.access_control as 'accessControl',
    room.access_code as 'accessCode',
    room.creation_date as 'createDate',
    room.amq_topic_uri as 'topicUri',
    room.user_id as 'userId'
    from room where (room.id=room_id and  !room_is_empty(room.id) and is_in_room(user_id,room.id));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_rooms` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_rooms`(IN user_name varchar(256))
    SQL SECURITY INVOKER
BEGIN 
    declare user_id integer;
    set user_id = get_user_id(user_name);

    select 
    room.id as 'id',
    /*replace(room.title,"'","\\'")*/room.title as 'title',
    room.creation_date as 'createDate',
    room.amq_topic_uri as 'topicUri',
    room.user_id as 'userId'
    from room where (!room_is_empty(room.id) and is_in_room(user_id,room.id));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_rooms_owned_by` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_rooms_owned_by`(IN user_name varchar(256))
    SQL SECURITY INVOKER
BEGIN 
    declare user_id integer;
    set user_id = get_user_id(user_name);

    select 
    room.id as 'id',
    /*replace(room.title,"'","\\'")*/room.title as 'title',
    room.creation_date as 'createDate',
    room.amq_topic_uri as 'topicUri',
    room.user_id as 'userId'
    from room where (!room_is_empty(room.id) and is_in_room(user_id,room.id) and room.user_id=user_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_room_ext` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_room_ext`(IN room_id integer)
    SQL SECURITY INVOKER
BEGIN 
    select 
    room.id as 'id',
    /*replace(room.title,"'","\\'")*/room.title as 'title',
    room.access_control as 'accessControl',
    room.access_code as 'accessCode',
    room.creation_date as 'createDate',
    room.amq_topic_uri as 'topicUri',
    room.user_id as 'userId'
    from room where (room.id=room_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_room_orders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_room_orders`(IN room_id integer)
    SQL SECURITY INVOKER
BEGIN 
     select prod_widget.category,prod_widget.id,prod_widget.default_instance,prod_widget.catalog_page_index from prod_widget,widget_order where widget_order.room_id=room_id and widget_order.widget_id=prod_widget.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_room_orders_by_category` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_room_orders_by_category`(IN room_id integer,IN category varchar(256))
    SQL SECURITY INVOKER
BEGIN 
     select prod_widget.category,prod_widget.id,prod_widget.default_instance,prod_widget.catalog_page_index from prod_widget,widget_order where widget_order.room_id=room_id and 
					widget_order.widget_id=prod_widget.id and
					prod_widget.category=category;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_room_topic_orders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_room_topic_orders`(IN room_id integer,IN category varchar(256))
    SQL SECURITY INVOKER
BEGIN 
     select prod_widget.category,prod_widget.id,prod_widget.default_instance,prod_widget.catalog_page_index from prod_widget,widget_order where widget_order.room_id=room_id and 
					widget_order.widget_id=prod_widget.id and
					prod_widget.category=category;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_signup_request` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_signup_request`(IN id integer,
									 IN security_tk varchar(256))
    SQL SECURITY INVOKER
BEGIN 	
	select * from signup_request where signup_request.id=id and signup_request.security_tk=security_tk;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_signup_request_queue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_signup_request_queue`()
    SQL SECURITY INVOKER
BEGIN 	
	select * from signup_request;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_static_reference` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_static_reference`(IN file_name varchar(256))
    SQL SECURITY INVOKER
BEGIN 
	select static_references.reference_count from static_references where static_references.file_name = file_name;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_submitted_assignments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_submitted_assignments`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN assignment_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);
	select 	context.room_id as 'roomId',
		context.participant_id as 'participantId',
		context.id as 'id',
		context.config as 'config',
		context.access_control as 'accessControl',
		/*context_access.access*/context.access_control as 'access'
	from assignment_submission,context where
	assignment_submission.room_id=room_id and
	assignment_submission.assignment_id=assignment_id and
	assignment_submission.context_id=context.id and
	context.participant_id=user_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_text_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_text_data`(IN id varchar(256))
    SQL SECURITY INVOKER
BEGIN 
    select * from text_data where (text_data.id=id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_user`(IN email_address varchar(256))
    SQL SECURITY INVOKER
BEGIN 
   select 
   id as 'id',
   user_name as 'userName',
   pass_word as 'passWord',
   user_name as 'emailAddress',
   name as 'name',
   status as 'status',

   plan as 'plan',
   plan_status as 'planStatus',
   stripe_customer_id as 'stripeCustomerId',
   plan_start_date as 'planStartDate',
   next_billing_cycle_start_date as 'nextBillingCycleStartDate',
   last_invoice_date as 'lastInvoiceDate',
   last_invoice_id as 'lastInvoiceId',
   team_size as 'teamSize'

   from users where users.user_name=lower(email_address);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_users`(start integer,pagesize integer,filter varchar(256))
    SQL SECURITY INVOKER
BEGIN 
   
   select 
   id as "id",
   user_name as "userName",
   pass_word as "passWord",
   user_name as "emailAddress",
   name as "name",
   status as 'status',

   plan as 'plan',
   plan_status as 'planStatus',
   stripe_customer_id as 'stripeCustomerId',
   plan_start_date as 'planStartDate',
   next_billing_cycle_start_date as 'nextBillingCycleStartDate',
   last_invoice_date as 'lastInvoiceDate',
   last_invoice_id as 'lastInvoiceId',
   team_size as 'teamSize'

   from users where  (!is_super_user(users.id) and (users.status is null or users.status != 'inactive'))
   /*limit start,pagesize*/;
   
   /*
   PREPARE STMT FROM 
   'select 
   id as "id",
   user_name as "userName",
   pass_word as "passWord",
   user_name as "emailAddress",
   first_name as "firstName",
   last_name as "lastName" 
   from users  where users.status is null or users.status != "inactive" limit ?,?';
   EXECUTE STMT USING @start,@pagesize;
   */
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_user_applets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_user_applets`(
									IN user_name varchar(256),
									IN room_id integer)
    SQL SECURITY INVOKER
BEGIN 	
	declare user_id integer;
	set user_id = get_user_id(user_name);
	select 
		prod_widget.id,
		prod_widget.creator_id as 'creatorId',
		prod_widget.name,
		prod_widget.description,
		prod_widget.icon_res_id as 'iconId',
		prod_widget.code,
		prod_widget.status,
		prod_widget.version,
		prod_widget.author_name as 'authorName',
		prod_widget.author_link as 'authorLink',
		prod_widget.category,
		prod_widget.tags,
		prod_widget.create_date as 'createDate',
		prod_widget.last_mod_date as 'lastModDate' ,
		prod_widget.show_in_menu as 'showInMenu',
		prod_widget.default_instance as 'defaultInstance',
		prod_widget.question,
		prod_widget.price,
		prod_widget.catalog_page_index as 'catalogPage',
		prod_widget.unique_key as 'uniqueKey'
	 from applet_access,prod_widget where (((applet_access.user_id is null and (applet_access.room_id is null or applet_access.room_id=0)) or  applet_access.user_id=user_id or applet_access.room_id=room_id) and prod_widget.id=applet_access.applet_id and prod_widget.show_in_menu='Yes');

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_user_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_user_by_id`(IN user_id integer)
    SQL SECURITY INVOKER
BEGIN 
   select 
   id as 'id',
   user_name as 'userName',
   pass_word as 'passWord',
   user_name as 'emailAddress',
   name as 'name'
   from users where users.id=user_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_user_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_user_count`(filter varchar(256))
    SQL SECURITY INVOKER
BEGIN 
   select count(id) as 'count' from users;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_user_id`(IN user_name varchar(128))
    SQL SECURITY INVOKER
BEGIN 
   select id as 'user_id' from users where lower(users.user_name)=lower(user_name);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_user_roles` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_user_roles`(user_id integer)
    SQL SECURITY INVOKER
BEGIN 
	select roles.role from roles,user_roles where 
	user_roles.user_id=user_id and roles.id=user_roles.role_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_user_settings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_user_settings`(IN user_name varchar(256))
    SQL SECURITY INVOKER
BEGIN 
	declare user_id,cnt integer;
	set user_id= get_user_id(user_name);
	select count(user_settings.user_id) into cnt from user_settings  where user_settings.user_id=user_id;
	
	if cnt = 0 then
		insert into user_settings (user_id) values(user_id);
	end if;

   	select user_id as 'userId',
	       dev_toxonomy as 'devToxonomy'
       from user_settings where user_settings.user_id=user_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_uuid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_uuid`(IN strlength integer)
    SQL SECURITY INVOKER
BEGIN 
   select SUBSTRING(REPLACE(UUID(),"-",""),1,strlength) as 'uuid';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_widget`(IN id integer,IN env char(128))
    SQL SECURITY INVOKER
BEGIN 
	if env='dev' then
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
		from widget where widget.id=id;
	elseif env='queue' then
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
		 from queue_widget where queue_widget.id=id;
	elseif env='rejected' then
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
		 from rejected_widget where rejected_widget.id=id;
	else
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
	 from prod_widget where prod_widget.id=id;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_widgets` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_widgets`(IN user_name varchar(256),IN env char(128))
    SQL SECURITY INVOKER
BEGIN 	
	declare creator_id integer;
	set creator_id = get_user_id(user_name);

	if env='dev' then
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		dev_toxonomy as 'devToxonomy',
		unique_key as 'uniqueKey'
		from widget where (user_name='' or widget.creator_id=creator_id)order by id asc;
	elseif env='queue' then
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
                dev_toxonomy as 'devToxonomy',
		unique_key as 'uniqueKey'
		 from queue_widget where (user_name='' or queue_widget.creator_id=creator_id)order by id asc;
	elseif env='rejected' then
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		dev_toxonomy as 'devToxonomy',
		unique_key as 'uniqueKey'
		 from rejected_widget where (user_name='' or rejected_widget.creator_id=creator_id)order by id asc;
	else
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		dev_toxonomy as 'devToxonomy',
		unique_key as 'uniqueKey'
		 from prod_widget where (user_name='' or prod_widget.creator_id=creator_id) order by id asc;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_widget_dependencies` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_get_widget_dependencies`(
								  IN widget_id integer)
    SQL SECURITY INVOKER
BEGIN 
	select widget_dependency.widget_id as 'widgetId',
               widget_dependency.dependency_id as 'dependencyId',
               widget_dependency.dependency_path as 'dependencyPath'
	from widget_dependency where (widget_dependency.widget_id=widget_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_grant_applet_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_grant_applet_access`(
							      IN applet_id integer,
							      IN user_name varchar(128),
							      IN room_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	insert into applet_access values(applet_id,get_user_id(user_name),room_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_has_applet_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_has_applet_access`(IN user_name varchar(128),IN applet_id integer)
    SQL SECURITY INVOKER
BEGIN 
	declare creator_id,cnt integer;
	set creator_id = get_user_id(user_name);
	
	select count(id) into cnt
		from widget where widget.id=applet_id and widget.creator_id=creator_id;
        select cnt as 'count';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_has_applet_installed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_has_applet_installed`(IN user_name varchar(128),IN applet_id integer)
    SQL SECURITY INVOKER
BEGIN 
	declare user_id,cnt integer;
	set user_id = get_user_id(user_name);
	
	select count(applet_access.applet_id) into cnt
		from applet_access where applet_access.applet_id=applet_id and applet_access.user_id=user_id;
        select cnt as 'count';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_install_applet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_install_applet`(
								 IN creator_id integer,
								 IN name varchar(256),
								 IN description varchar(512),
								 IN category text,
								 IN tags varchar(256),
								 IN show_in_menu char(8),
								 IN code text,
								 IN author_name varchar(256),
								 IN author_link varchar(256),
								 IN version char(32),
								 IN price float,
								 IN catalog_page_index integer)
    SQL SECURITY INVOKER
BEGIN 
     declare crtdate datetime;
     declare widget_id integer;
     select now() into crtdate;


     insert into widget (creator_id,
		         name,
			 description,
			 category,
			 tags,
			 show_in_menu,
			 code,			 
			 author_name,
			 author_link,
			 version,
			 status,
			 create_date ,
			 last_mod_date,
			 price,
			 catalog_page_index,
			 dev_toxonomy)
			 values (creator_id,
				 name,
				 description,
				 category,
				 tags,
				 show_in_menu,
				 code,
				 author_name,
				 author_link,
				 version,
				 'installed',
				 crtdate,
				 crtdate,
				 price,
				 catalog_page_index,
				 dev_toxonomy);
     select LAST_INSERT_ID() into widget_id;

     insert into prod_widget (
			 id,
                         creator_id,
		         name,
			 description,
			 category,
			 tags,
			 show_in_menu,
			 code,			 
			 author_name,
			 author_link,
			 version,
			 status,
			 create_date ,
			 last_mod_date,
			 price,
			 catalog_page_index)
			 values (widget_id,
				 creator_id,
				 name,
				 description,
				 category,
				 tags,
				 show_in_menu,
				 code,
				 author_name,
				 author_link,
				 version,
				 'APPROVED',
				 crtdate,
				 crtdate,
				 price,
				 catalog_page_index);
     /*select LAST_INSERT_ID() into widget_id;*/
     select widget_id as 'widget_id';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_make_developer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_make_developer`(IN vroom_res_id integer,IN id integer)
    SQL SECURITY INVOKER
BEGIN 
        declare dev_role_id integer;
	select roles.id into dev_role_id from roles where role='developer';
	update vroom_participant set role_id=dev_role_id where res_id=vroom_res_id and participant_id=id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_mark_installed_applet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_mark_installed_applet`(						
							IN package_id varchar(128),
				   			IN id integer,
							IN applet_id integer)
    SQL SECURITY INVOKER
BEGIN 
      update packaged_applets set 
      packaged_applets.applet_id=applet_id,
      packaged_applets.installed='Yes' where 
      packaged_applets.package_id = package_id and
      packaged_applets.id = id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_mark_uninstalled_applet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_mark_uninstalled_applet`(						
							IN package_id varchar(128),
				   			IN id integer)
    SQL SECURITY INVOKER
BEGIN 
      update packaged_applets set 
      packaged_applets.installed='No',
      packaged_applets.applet_id=0
      where packaged_applets.package_id = package_id and packaged_applets.id = id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_move_pad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_move_pad`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN context_id integer,							      
							      IN id integer,							     
							      IN new_parent_id integer,
							      IN new_pre_sibling integer,
							      IN children_only char(8))
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer default get_user_id(user_name);

	if children_only = 'yes' then
	
		/*update sibling link of first child item*/
		update pad set pad.pre_sibling=new_pre_sibling where 
		(
			pad.room_id=room_id and 
	 		pad.participant_id=/*grantor*/participant_id and /*should only allow update to pads created by this user*/
	 		pad.context_id=context_id and
	 		pad.parent_id=id and
			pad.pre_sibling=0
		);

		update pad set pad.parent_id=new_parent_id where 
		(
			pad.room_id=room_id and 
	 		pad.participant_id=/*grantor*/participant_id and /*should only allow update to pads created by this user*/
	 		pad.context_id=context_id and
	 		pad.parent_id=id
		);
	else
		update pad set 
		pad.parent_id=new_parent_id,
		pad.pre_sibling=new_pre_sibling
		where 
		(
			pad.room_id=room_id and 
	 		pad.participant_id=/*grantor*/participant_id and /*should only allow update to pads created by this user*/
	 		pad.context_id=context_id and
	 		pad.id=id
		);
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_poll_notifications` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_poll_notifications`()
    SQL SECURITY INVOKER
BEGIN 
	select start_time as 'startTime',
               end_time as 'endTime',
               timezone as 'timeZone',
               repeat_interval as 'repeatInterval',
               repeat_interval_count as 'repeatIntervalCount',
               variable_definitions as 'variableDefinitions',
               message_template as 'messageTemplate',
               messaging_medium as 'messagingMedium',
	       state as 'state'
	from notification;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_queue_signup_request` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_queue_signup_request`(IN email varchar(256),
                                                                           IN fname varchar(256),
									   IN lname varchar(256),
									   IN course varchar(256),
									   IN home_page text)
    SQL SECURITY INVOKER
BEGIN 
	insert into signup_request (email,first_name,last_name,course,home_page,request_date,security_tk)
	values(email,fname,lname,course,home_page,now(),uuid());
	select * from signup_request where id=LAST_INSERT_ID();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reject_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_reject_widget`(IN id integer)
    SQL SECURITY INVOKER
BEGIN 
	/*Move from review queue to reject pool*/
	insert into rejected_widget (select * from queue_widget where queue_widget.id=id);
	  
	update rejected_widget set 
	code=replace(rejected_widget.code,'47bafa4e-f466-102c-91e5-0019b958a435','bfcc4a7c-f503-102c-8fa4-0019b958a435'),
        status='REJECTED' where (rejected_widget.id=id);

	insert into rejected_resource ( select * from queue_resource where queue_resource.widget_id = id);

	/*Remove from review queue*/
	delete from queue_resource where widget_id=id;
	delete from queue_widget where queue_widget.id=id;

	select 	* from rejected_widget where (rejected_widget.id=id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_resubmit_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_resubmit_widget`(IN user_name varchar(128),IN id integer)
    SQL SECURITY INVOKER
BEGIN 
	declare creator_id,inprocess integer;
	set creator_id = get_user_id(user_name);

	/*Don't allow submission if there is already one in process*/
	select count(queue_widget.id) into inprocess from queue_widget where queue_widget.creator_id=creator_id and queue_widget.id=id and queue_widget.status='IN-PROCESS';

	IF inprocess > 0 THEN
	  select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
	 from queue_widget where (queue_widget.creator_id=creator_id and queue_widget.id=id and queue_widget.status='IN-PROCESS');
	ELSE
		
	  insert into queue_widget (select * from rejected_widget where rejected_widget.creator_id=creator_id and rejected_widget.id=id);
	  
	  update queue_widget set 
	  code=replace(queue_widget.code,'bfcc4a7c-f503-102c-8fa4-0019b958a435','47bafa4e-f466-102c-91e5-0019b958a435'),
          status='IN-PROCESS' where (queue_widget.creator_id=creator_id and queue_widget.id=id);

	  insert into queue_resource ( select rejected_resource.* from rejected_widget,rejected_resource where rejected_widget.creator_id=creator_id and rejected_widget.id=id and rejected_resource.widget_id = rejected_widget.id);


	  /*delete from rejected environment*
	  delete from rejected_resource where (rejected_widget.creator_id=creator_id and rejected_widget.id=id and rejected_resource.widget_id = rejected_widget.id);
	  delete from rejected_widget where (rejected_widget.creator_id=creator_id and rejected_widget.id=id);
	  */
	  call sp_del_widget(user_name,id,'rejected');
	  select 	id,
			creator_id as 'creatorId',
			name,
			description,
			icon_res_id as 'iconId',
			code,
			'SUCCESS' AS 'status',
			version,
			author_name as 'authorName',
			author_link as 'authorLink',
			category,
			tags,
			create_date as 'createDate',
			last_mod_date as 'lastModDate',
			show_in_menu as 'showInMenu',
			unique_key as 'uniqueKey'
			from queue_widget where (queue_widget.creator_id=creator_id and queue_widget.id=id);
						   
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_revoke_applet_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_revoke_applet_access`(							      
							      IN user_name varchar(128),
							      IN applet_id integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	delete from applet_access where (applet_access.applet_id=applet_id and applet_access.user_id=get_user_id(user_name));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_save_widget_code` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_save_widget_code`(
								 IN user_name varchar(256),
								 IN id integer,
								 IN code text,
								 IN env char(128)								 
								 )
    SQL SECURITY INVOKER
BEGIN 
     declare creator_id integer;
     set creator_id = get_user_id(user_name);

     if env='dev' then
        update widget set widget.code=code
		       where (widget.id=id and widget.creator_id=creator_id);
     elseif env='rejected' then
        update rejected_widget set rejected_widget.code=code
		       where (rejected_widget.id=id and rejected_widget.creator_id=creator_id);
     elseif env='prod' then
        update prod_widget set prod_widget.code=code
		       where (prod_widget.id=id and prod_widget.creator_id=creator_id);
     end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_serve_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_serve_widget`(IN unique_key varchar(256),IN env char(128))
    SQL SECURITY INVOKER
BEGIN 
	if env='dev' then
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
		from widget where widget.unique_key=unique_key;
	elseif env='queue' then
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
		 from queue_widget where queue_widget.unique_key=unique_key;
	elseif env='rejected' then
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
		 from rejected_widget where rejected_widget.unique_key=unique_key;
	else
	   select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
	 from prod_widget where prod_widget.unique_key=unique_key;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_set_text_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_set_text_data`(IN id varchar(256),IN txtData text)
    SQL SECURITY INVOKER
BEGIN 
    update text_data set text_data.data=txtData where (text_data.id=id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_submit_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_submit_widget`(IN user_name varchar(128),IN id integer)
    SQL SECURITY INVOKER
BEGIN 
	declare creator_id,inprocess integer;	
	set creator_id = get_user_id(user_name);

	/*Don't allow submission if there is already one in process*/
	select count(queue_widget.id) into inprocess from queue_widget where queue_widget.creator_id=creator_id and queue_widget.id=id and queue_widget.status='IN-PROCESS';

	IF inprocess > 0 THEN
	  select 
		id,
		creator_id as 'creatorId',
		name,
		description,
		icon_res_id as 'iconId',
		code,
		status,
		version,
		author_name as 'authorName',
		author_link as 'authorLink',
		category,
		tags,
		create_date as 'createDate',
		last_mod_date as 'lastModDate' ,
		show_in_menu as 'showInMenu',
		default_instance as 'defaultInstance',
		question,
		price,
		catalog_page_index as 'catalogPage',
		unique_key as 'uniqueKey'
	 from queue_widget where (queue_widget.creator_id=creator_id and queue_widget.id=id and queue_widget.status='IN-PROCESS');
	ELSE
		
	  insert into queue_widget (select * from widget where widget.creator_id=creator_id and widget.id=id);
	  
	  update queue_widget set 
	  code=replace(queue_widget.code,'53d66824-f1ad-102c-a54b-0019b958a435','47bafa4e-f466-102c-91e5-0019b958a435'),
          status='IN-PROCESS' where (queue_widget.creator_id=creator_id and queue_widget.id=id);

	  insert into queue_resource ( select resource.* from resource,queue_widget where queue_widget.creator_id=creator_id and queue_widget.id=id and resource.widget_id = queue_widget.id);

	  select 	id,
			creator_id as 'creatorId',
			name,
			description,
			icon_res_id as 'iconId',
			code,
			'SUCCESS' AS 'status',
			version,
			author_name as 'authorName',
			author_link as 'authorLink',
			category,
			tags,
			create_date as 'createDate',
			last_mod_date as 'lastModDate',
		    	show_in_menu as 'showInMenu',
			default_instance as 'defaultInstance',
			question,
			price,
			catalog_page_index as 'catalogPage',
			unique_key as 'uniqueKey'
			from queue_widget where (queue_widget.creator_id=creator_id and queue_widget.id=id);
						   
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_undeploy_applet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_undeploy_applet`(IN user_name varchar(128),IN id integer)
    SQL SECURITY INVOKER
BEGIN 
	declare status char(16);
        select widget.status into status from widget where widget.id=id;

        if status='installed' then
           call sp_del_widget('',id,'dev');
        end if;

	call sp_del_widget('',id,'prod');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_assignment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_assignment`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN id integer,							      
							      IN name varchar(256),
							      IN open_date datetime,
							      IN close_date datetime,
							      IN timezone varchar(128),
							      IN allow_versioned_submission char(8),
							      IN versioned_submission_limit integer,
							      IN first_reminder_date_tm datetime,
							      IN repeat_interval_in_minutes integer,
							      IN repeat_count integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	declare user_id integer default get_user_id(user_name);
	
	update assignment set assignment.name=name,
			      assignment.open_date_tm=open_date,
			      assignment.close_date_tm=close_date,
			      assignment.timezone = timezone,
			      assignment.allow_versioned_submission=allow_versioned_submission,
			      assignment.versioned_submission_limit=versioned_submission_limit,			      
			      assignment.repeat_interval_in_minutes=repeat_interval_in_minutes,
			      assignment.repeat_count=repeat_count
	where(assignment.user_id=user_id and
              assignment.room_id=room_id and
	      assignment.id =id);

	/*Check to see if reminder needs to be reset*/
	update assignment set assignment.first_reminder_sent='no'
	where(assignment.user_id=user_id and
              assignment.room_id=room_id and
	      assignment.id =id and
	      TIMESTAMPDIFF(MINUTE,assignment.first_reminder_date_tm,first_reminder_date_tm)!=0);

	update assignment set assignment.first_reminder_date_tm=first_reminder_date_tm
	where(assignment.user_id=user_id and
              assignment.room_id=room_id and
	      assignment.id =id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_assignments_with_reminder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_assignments_with_reminder`()
    SQL SECURITY INVOKER
BEGIN 
	update assignment set
	assignment.first_reminder_date_tm = ADDDATE(assignment.first_reminder_date_tm,INTERVAL assignment.repeat_interval_in_minutes MINUTE),
	assignment.repeat_count=assignment.repeat_count-1,
	assignment.first_reminder_sent='yes'
	where(assignment.status != 'archived' and 
              is_assignment_open(timezone,open_date_tm,close_date_tm) and
	      ((assignment.first_reminder_sent='no' and TIMESTAMPDIFF(MINUTE,assignment.first_reminder_date_tm,now())>=0) or (
	      assignment.repeat_count>0 and
	      TIMESTAMPDIFF(MINUTE,assignment.first_reminder_date_tm,now())>=assignment.repeat_interval_in_minutes)));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_context` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_context`(
							      IN user_name varchar(128),
							      IN room_id integer,							      							      
							      IN id integer,							     
							      IN config text,
							      IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;

	declare read_access integer default 1;
	declare write_access integer default 2;
	declare read_write_access integer default (write_access | read_access);

	set participant_id = get_user_id(user_name);

	update context set context.config=config where 
	(
	 context.room_id=room_id and 
	 context.participant_id=/*grantor*/participant_id and /*should only allow update to context created by this user*/
	 context.id=id/* and
	 has_context_access(grantor,room_id,context.id,participant_id,write_access)*/
	);	
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_context_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_context_access`(
							      IN user_name varchar(128),
							      IN room_id integer,							      							      
							      IN id integer,
							      IN granted_to integer,
							      IN access integer)
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
/*	declare access_count integer;
	select count(id) into access_count from context_access  where (
				   context_access.room_id=room_id and 
				   context_access.participant_id=participant_id and 
				   context_access.id=id and
				   context_access.granted_to=granted_to);

	if access_count>0 then
		update context_access set context_access.access=access where (
				   context_access.room_id=room_id and 
				   context_access.participant_id=participant_id and 
				   context_access.id=id and
				   context_access.granted_to=granted_to);
	else
	     	call sp_add_context_access(room_id,participant_id,id,granted_to,access);
	end if;	*/
	if granted_to = 0 then
                update context set context.access_control=access where (
                                   context.room_id=room_id and 
				   context.participant_id=participant_id and 
				   context.id=id);
	else	
		update context_access set context_access.access=access where (
				   context_access.room_id=room_id and 
				   context_access.participant_id=participant_id and 
				   context_access.id=id and
				   context_access.granted_to=granted_to);
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_element` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_element`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN context_id integer,
							      IN pad_id integer,
							      IN id integer,
							      IN config longtext,
							      IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 
	
	declare participant_id integer;

	declare read_write_access integer;
	declare read_access integer;
	declare write_access integer;
	set read_access = 1;
	set write_access = 2;
	set read_write_access = 3;

	set participant_id = get_user_id(user_name);

	update element set element.config=config where 
	(
	element.room_id=room_id and 
	element.participant_id=grantor and 
	element.context_id=context_id and
	element.pad_id=pad_id and
	element.id=id and
	has_context_access(grantor,room_id,context_id,participant_id,read_access) and
	has_pad_access(grantor,room_id,context_id,pad_id,participant_id,write_access) and
	has_element_access(grantor,room_id,context_id,pad_id,element.id,participant_id,write_access)
	);
	/*declare pad_access_cnt,participant_id integer;
	set participant_id = get_user_id(user_name);

	select 	count(pad.id) into pad_access_cnt
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.id=pad_id and
			       pad_access.granted_to=participant_id and
			       (
				 (pad_access.access & 2)>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and (context_access.access & 2)>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  pad.id=pad_id and
				  (
				    (pad.access_control & 2)>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and (context.access_control & 2)>0
				    )=1
				  )
				)
			 	and
				(
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id			  
				)
			    )
			)
		    )
		) ;

	if pad_access_cnt=1 then
		update element set element.config=config where (element.room_id=room_id and 
				   element.participant_id=grantor and 
				   element.context_id=context_id and
				   element.pad_id=pad_id and
				   element.id=id);
	end if;	*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_element_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_element_access`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN context_id integer,
							      IN pad_id integer,							      
							      IN id integer,
							      IN grantor integer,
							      IN granted_to integer,
							      IN access integer)
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;

	declare read_access integer default 1;
	declare write_access integer default 2;
	declare alter_security_access integer default 32;
	declare full_access integer default (write_access | read_access | alter_security_access);

	set participant_id = get_user_id(user_name);
/*
	declare access_count integer;
	select count(id) into access_count from pad_access where (
				   pad_access.room_id=room_id and 
				   pad_access.participant_id=participant_id and 
				   pad_access.context_id=context_id and
				   pad_access.id=id and
				   pad_access.granted_to=granted_to);	
	if access_count>0 then
		update pad_access set pad_access.access=access where (
				   pad_access.room_id=room_id and 
				   pad_access.participant_id=participant_id and 
				   pad_access.context_id=context_id and
				   pad_access.id=id and
				   pad_access.granted_to=granted_to);
	else
		call sp_add_pad_access(room_id,participant_id,context_id,id,granted_to,access);
	end if;	
*/
	if has_element_access(grantor,room_id,context_id,pad_id,id,participant_id,full_access) then

		if granted_to = 0 then
		
			update element set element.access_control=access where (
				   element.room_id=room_id and 
				   element.participant_id=grantor and 
				   element.context_id=context_id and
				   element.pad_id=pad_id and
				   element.id=id);
		else
			update element_access set element_access.access=access where (
				   element_access.room_id=room_id and 
				   element_access.participant_id=grantor and 
				   element_access.context_id=context_id and
				   element_access.pad_id=pad_id and
				   element_access.id=id and
				   element_access.granted_to=granted_to);
		end if;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_feature_usage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_feature_usage`(user_name varchar(256),feature_id integer, usage_value char(32))
    SQL SECURITY INVOKER
BEGIN 
    declare user_id integer default get_user_id(user_name);

    update feature_usage_matrix set 
    feature_usage_matrix.usage = usage_value
    where feature_usage_matrix.user_id=user_id and feature_usage_matrix.feature_id=feature_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_notification` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_notification`(
							      IN id integer,
							      IN start_time datetime,
							      IN end_time datetime,
							      IN timezone varchar(128),
							      IN repeat_interval long,
							      IN repeat_interval_count integer
							      )
    SQL SECURITY INVOKER
BEGIN 
	update notifications 
        set    notifications.start_time=start_time,
	       notifications.end_time=end_time,
	       notifications.timezone=timezone,
	       notifications.repeat_interval=repeat_interval,
	       notifications.repeat_interval_count=repeat_interval_count
 	where  notifications.id=id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_pad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_pad`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN context_id integer,							      
							      IN id integer,							     
							      IN config text,
							      IN grantor integer)
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer default get_user_id(user_name);

	declare read_access integer default 1;
	declare write_access integer default 2;
	declare read_write_access integer default (write_access | read_access);

	update pad set pad.config=config where 
	(pad.room_id=room_id and 
	 pad.participant_id=/*grantor*/participant_id and /*should only allow update to pads created by this user*/
	 pad.context_id=context_id and
	 pad.id=id/* and
	 has_context_access(grantor,room_id,context_id,participant_id,write_access) and
	 has_pad_access(grantor,room_id,context_id,pad.id,participant_id,write_access)*/
	);
	/*declare pad_access_cnt,participant_id integer;
	set participant_id = get_user_id(user_name);
	select 	count(pad.id) into pad_access_cnt
		from pad,pad_access where
		(
		    (
		    	(   /*either individual access has been granted*
			    (
			       pad_access.room_id=room_id and 
			       pad_access.participant_id=grantor and
			       pad_access.context_id=context_id and
			       pad_access.id=id and
			       pad_access.granted_to=participant_id and
			       (
				 (pad_access.access & 2)>0
			         or
			    	 (
			       	   select count(context_access.id) from context_access where context_access.room_id=pad_access.room_id and context_access.participant_id=pad_access.participant_id and context_access.id=pad_access.context_id and context_access.granted_to=pad_access.granted_to and (context_access.access & 2)>0
			         )=1
			       )
			    )
		    	    and		
		    	    (
				pad.room_id=pad_access.room_id and
				pad.participant_id=pad_access.participant_id and
				pad.context_id=pad_access.context_id and
				pad.id=pad_access.id
		    	    )
		    	)
			or
			(/*or global access has been granted*
			    (
				(
				  pad.room_id=room_id and
				  pad.participant_id=grantor and
				  pad.context_id=context_id and
				  pad.id=id and
				  (
				    (pad.access_control & 2)>0
				    or
				    (
				      select count(context.id) from context where context.room_id=pad.room_id and context.participant_id=pad.participant_id and context.id=pad.context_id and (context.access_control & 2)>0
				    )=1
				  )
				)
			 	and
				(
				  pad_access.room_id=pad.room_id and
				  pad_access.participant_id=pad.participant_id and
				  pad_access.context_id=pad.context_id and
				  pad_access.id=pad.id and
				  pad_access.granted_to=participant_id			  
				)
			    )
			)
		    )
		) ;
	if (grantor=participant_id and pad_access_cnt=1) then
		update pad set pad.config=config,pad.access_control=access_control where (pad.room_id=room_id and 
				   pad.participant_id=grantor and 
				   pad.context_id=context_id and
				   pad.id=id);	

	elseif pad_access_cnt=1 then
		update pad set pad.config=config where (pad.room_id=room_id and 
				   pad.participant_id=grantor and 
				   pad.context_id=context_id and
				   pad.id=id);	
	end if;*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_pad_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_pad_access`(
							      IN user_name varchar(128),
							      IN room_id integer,							      
							      IN context_id integer,							      
							      IN id integer,
							      IN granted_to integer,
							      IN access integer)
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer;
	set participant_id = get_user_id(user_name);
/*
	declare access_count integer;
	select count(id) into access_count from pad_access where (
				   pad_access.room_id=room_id and 
				   pad_access.participant_id=participant_id and 
				   pad_access.context_id=context_id and
				   pad_access.id=id and
				   pad_access.granted_to=granted_to);	
	if access_count>0 then
		update pad_access set pad_access.access=access where (
				   pad_access.room_id=room_id and 
				   pad_access.participant_id=participant_id and 
				   pad_access.context_id=context_id and
				   pad_access.id=id and
				   pad_access.granted_to=granted_to);
	else
		call sp_add_pad_access(room_id,participant_id,context_id,id,granted_to,access);
	end if;	
*/
	if granted_to = 0 then
	   update pad set pad.access_control=access where (
				   pad.room_id=room_id and 
				   pad.participant_id=participant_id and 
				   pad.context_id=context_id and
				   pad.id=id);
	else
	   update pad_access set pad_access.access=access where (
				   pad_access.room_id=room_id and 
				   pad_access.participant_id=participant_id and 
				   pad_access.context_id=context_id and
				   pad_access.id=id and
				   pad_access.granted_to=granted_to);
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_pad_pre_sibling` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_pad_pre_sibling`(
							      IN user_name varchar(128),
							      IN room_id integer,
							      IN context_id integer,							      
							      IN id integer,
							      IN new_pre_sibling integer)
    SQL SECURITY INVOKER
BEGIN 
	declare participant_id integer default get_user_id(user_name);

	/*update sibling link*/
	update pad set pad.pre_sibling=new_pre_sibling where 
	(
	    pad.room_id=room_id and 
	    pad.participant_id=/*grantor*/participant_id and /*should only allow update to pads created by this user*/
	    pad.context_id=context_id and
	    pad.id=id
	);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_plan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_plan`(IN user_name varchar(255),
							       	   IN plan varchar(255))
    SQL SECURITY INVOKER
BEGIN 
    update users set
    users.plan=plan,
    users.plan_status="active"
    where users.user_name=user_name;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_plan_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_plan_status`(IN user_name varchar(255),
							       	   IN plan_status varchar(255))
    SQL SECURITY INVOKER
BEGIN 
    update users set
    users.plan_status=plan_status
    where users.user_name=lower(user_name);
    
    /*reset billing cycle if necessary
    update users set
    users.next_billing_cycle_start_date = now()
    where users.user_name=lower(user_name) and users.plan != 'basic' and plan_status = 'active' ;*/

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_resource` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_resource`(
								      IN user_name varchar(128),
								      IN widget_id integer,
								      IN old_name varchar(256),
								      IN file_name varchar(256),								      
								      IN label varchar(256),
								      IN type  varchar(64),
								      IN mime varchar(64)								      
								      )
    SQL SECURITY INVOKER
BEGIN 
     update resource set resource.label=label,
			 resource.type=type,
			 resource.mime=mime,
			 resource.file_name=file_name,
			 resource.last_mod_date=now() 
			where (resource.widget_id and resource.file_name=old_name);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_room_access` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_room_access`(IN user_name varchar(256),IN id integer,IN access integer)
    SQL SECURITY INVOKER
BEGIN 
    declare user_id integer;
    set user_id = get_user_id(user_name);

    update room set
    room.access_control=access
    where
    room.user_id=user_id and room.id=id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_room_access_code` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_room_access_code`(IN user_name varchar(256),IN id integer)
    SQL SECURITY INVOKER
BEGIN 
    declare user_id integer;
    set user_id = get_user_id(user_name);

    update room set    
    room.access_code=substring(replace(uuid(),'-',''),1,16)
    where
    room.user_id=user_id and room.id=id;

    select room.access_code from room where room.user_id=user_id and room.id=id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_room_title` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_room_title`(IN user_id integer,IN id integer,IN title varchar(256))
    SQL SECURITY INVOKER
BEGIN 
    update room set
    room.title = title
    where
    room.user_id=user_id and room.id=id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_static_reference` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_static_reference`(IN file_name varchar(256), IN reference_count integer)
    SQL SECURITY INVOKER
BEGIN 
	if reference_count = 0 then
	   delete from static_references where static_references.file_name = file_name;
	else
	   update static_references set static_references.reference_count=reference_count where static_references.file_name = file_name;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_stripe_customer_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_stripe_customer_id`(IN user_name varchar(255),
							           IN stripe_customer_id varchar(256))
    SQL SECURITY INVOKER
BEGIN 
    update users set
    users.stripe_customer_id=stripe_customer_id
    where users.user_name=user_name;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_stripe_invoice_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_stripe_invoice_id`(IN user_name varchar(255),
								   	       IN invoice_id varchar(256))
    SQL SECURITY INVOKER
BEGIN 
    update users set
    users.last_invoice_id=invoice_id,
    users.last_invoice_date=now(),
    users.next_billing_cycle_start_date=ADDDATE(users.next_billing_cycle_start_date, INTERVAL 30 DAY)
    where users.user_name=user_name;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_team_size` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_team_size`(IN user_name varchar(255),
							       	       IN team_size integer)
    SQL SECURITY INVOKER
BEGIN 
    update users set
    users.team_size=team_size
    where users.user_name=user_name;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_user_fullname` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_user_fullname`(IN email_address varchar(256),IN name varchar(255))
    SQL SECURITY INVOKER
BEGIN 
     update users set users.name=name where lower(users.user_name)=lower(email_address);     
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_user_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_user_password`(IN email_address varchar(256),IN pass_word varchar(255))
    SQL SECURITY INVOKER
BEGIN 
     update users set users.pass_word=pass_word where lower(users.user_name)=lower(email_address);     
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_user_settings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_user_settings`(IN user_name varchar(256),IN dev_toxonomy text)
    SQL SECURITY INVOKER
BEGIN 
	declare user_id,cnt integer;
	
	set user_id= get_user_id(user_name);
	select count(user_settings.user_id) into cnt from user_settings where user_settings.user_id=user_id;
	
	if cnt=1 then
   		update user_settings set user_settings.dev_toxonomy=dev_toxonomy where user_settings.user_id=user_id;
	else
		insert into user_settings values(user_id,dev_toxonomy);
        end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_user_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_user_status`(IN user_name varchar(255),
							       	   IN status varchar(255))
    SQL SECURITY INVOKER
BEGIN 
    update users set
    users.status=status
    where users.user_name=lower(user_name);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_widget`(
								 IN id integer,
								 IN name varchar(256),
								 IN description varchar(512),
								 IN category varchar(1024),
								 IN tags varchar(256),
								 IN show_in_menu char(8),
								 IN author_name varchar(256),
								 IN author_link varchar(256),
								 IN price float,
								 IN catalog_page_index integer,
								 IN version varchar(32),
								 IN dev_toxonomy char(64),
								 IN env char(128))
    SQL SECURITY INVOKER
BEGIN 
     if env='dev' then
        update widget set widget.name=name,
		       widget.description=description,
		       widget.category=category,
	               widget.tags=tags,
		       widget.show_in_menu=show_in_menu,
		       widget.author_name=author_name,
		       widget.author_link=author_link,
		       widget.price=price,
		       widget.catalog_page_index=catalog_page_index,
		       widget.version=version,
		       widget.dev_toxonomy=dev_toxonomy 
		       where (widget.id=id);
     elseif env='queue' then
        update queue_widget set 
		       queue_widget.name=name,
		       queue_widget.description=description,
		       queue_widget.category=category,
	               queue_widget.tags=tags,
		       queue_widget.show_in_menu=show_in_menu,
		       queue_widget.author_name=author_name,
		       queue_widget.author_link=author_link,
		       queue_widget.price=price,
		       queue_widget.catalog_page_index=catalog_page_index,
		       queue_widget.version=version,
		       queue_widget.dev_toxonomy=dev_toxonomy  
		       where (queue_widget.id=id);
     elseif env='rejected' then
        update rejected_widget set 
		       rejected_widget.name=name,
		       rejected_widget.description=description,
		       rejected_widget.category=category,
	               rejected_widget.tags=tags,
		       rejected_widget.show_in_menu=show_in_menu,
		       rejected_widget.author_name=author_name,
		       rejected_widget.author_link=author_link,
		       rejected_widget.price=price,
		       rejected_widget.catalog_page_index=catalog_page_index,
		       rejected_widget.version=version,
		       rejected_widget.dev_toxonomy=dev_toxonomy 
		       where (rejected_widget.id=id);
     end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_widget_default_instance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_update_widget_default_instance`(
								 IN id integer,
								 IN catalog_page_index integer,
								 IN default_instance text)
    SQL SECURITY INVOKER
BEGIN 

        update prod_widget set 
		       prod_widget.catalog_page_index=catalog_page_index,
		       prod_widget.default_instance=default_instance
		       where (prod_widget.id=id);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_upgrade_account` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_upgrade_account`(IN user_name varchar(255),
							       	   IN plan varchar(255),
							           IN stripe_customer_id varchar(256),
								   IN invoice_id varchar(256))
    SQL SECURITY INVOKER
BEGIN 
    declare upgrade_date datetime default now();

    update users set
    users.plan=plan,
    users.plan_status="active",
    users.stripe_customer_id=stripe_customer_id,
    users.plan_start_date=upgrade_date,
    users.last_invoice_date=upgrade_date,
    users.next_billing_cycle_start_date=adddate(upgrade_date,INTERVAL 30 DAY),
    users.last_invoice_id=invoice_id
    where users.user_name=user_name;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_user_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_user_user`(IN email_address varchar(256),IN pass_word varchar(255))
    SQL SECURITY INVOKER
BEGIN 
     update users set users.pass_word=pass_word where users.user_name=email_address;     
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_withdraw_widget` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`bitlooter`@`localhost`*/ /*!50003 PROCEDURE `sp_withdraw_widget`(IN user_name varchar(128),IN id integer)
    SQL SECURITY INVOKER
BEGIN 
	/*declare creator_id integer;
	set creator_id = get_user_id(user_name);*/
	call sp_del_widget(user_name,id,'queue');

	/*Remove from review queue
	delete from queue_resource where queue_widget.creator_id=creator_id and queue_widget.id=id and resource.widget_id = queue_widget.id;
	delete from queue_widget where queue_widget.creator_id=creator_id and queue_widget.id=id;
	*/
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-12-01  8:51:58
