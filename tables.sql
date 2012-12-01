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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-12-01  8:51:46
