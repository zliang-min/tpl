-- # create database
-- ## change the database name if neccessary
CREATE DATABASE `rms_production` DEFAULT CHARACTER SET `utf8`;
use `rms_production`;

-- # schema
CREATE TABLE `schema_migrations` (`version` varchar(255) NOT NULL) ENGINE=InnoDB;
CREATE UNIQUE INDEX `unique_schema_migrations` ON `schema_migrations` (`version`);
CREATE TABLE `categories` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `name` varchar(255) NOT NULL, `description` varchar(1000)) ENGINE=InnoDB;
CREATE UNIQUE INDEX `index_categories_on_name` ON `categories` (`name`);
INSERT INTO schema_migrations (version) VALUES ('20091106082749');
CREATE TABLE `positions` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `name` varchar(255) NOT NULL, `description` varchar(1000), `need` int(11) DEFAULT 0, `filled` int(11) DEFAULT 0, `category_id` int(11), `created_at` datetime, `updated_at` datetime) ENGINE=InnoDB;
CREATE  INDEX `index_positions_on_category_id` ON `positions` (`category_id`);
CREATE  INDEX `index_positions_on_name` ON `positions` (`name`);
INSERT INTO schema_migrations (version) VALUES ('20091106094728');
CREATE TABLE `profiles` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `name` varchar(255) NOT NULL, `birthday` date, `education` varchar(255), `work_experience` int(11), `state` varchar(255), `profile_logs_count` int(11), `position_id` int(11), `created_at` datetime, `updated_at` datetime) ENGINE=InnoDB;
CREATE  INDEX `index_profiles_on_position_id` ON `profiles` (`position_id`);
INSERT INTO schema_migrations (version) VALUES ('20091109022111');
CREATE TABLE `feedbacks` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `content` text, `profile_log_id` int(11), `created_at` datetime, `updated_at` datetime) ENGINE=InnoDB;
CREATE  INDEX `index_feedbacks_on_profile_log_id` ON `feedbacks` (`profile_log_id`);
INSERT INTO schema_migrations (version) VALUES ('20091109040700');
CREATE TABLE `profile_logs` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `action` varchar(255) NOT NULL, `profile_id` int(11), `created_at` datetime, `updated_at` datetime) ENGINE=InnoDB;
CREATE  INDEX `index_profile_logs_on_profile_id` ON `profile_logs` (`profile_id`);
INSERT INTO schema_migrations (version) VALUES ('20091109095255');
ALTER TABLE `profiles` ADD `picture_file_name` varchar(255);
ALTER TABLE `profiles` ADD `picture_content_type` varchar(255);
ALTER TABLE `profiles` ADD `picture_file_size` int(11);
ALTER TABLE `profiles` ADD `picture_file_updated_at` datetime;
ALTER TABLE `profiles` ADD `cv_file_name` varchar(255);
ALTER TABLE `profiles` ADD `cv_content_type` varchar(255);
ALTER TABLE `profiles` ADD `cv_file_size` int(11);
ALTER TABLE `profiles` ADD `cv_file_updated_at` datetime;
INSERT INTO schema_migrations (version) VALUES ('20091110033114');
CREATE TABLE `operations` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `event` text, `created_at` datetime, `updated_at` datetime) ENGINE=InnoDB;
INSERT INTO schema_migrations (version) VALUES ('20091111025642');
CREATE TABLE `users` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `position` varchar(255), `physicaldeliveryofficename` varchar(255), `displayname` varchar(255), `email` varchar(255) NOT NULL, `remember_token` varchar(20), `remember_created_at` datetime, `created_at` datetime, `updated_at` datetime) ENGINE=InnoDB;
CREATE UNIQUE INDEX `index_users_on_email` ON `users` (`email`);
INSERT INTO schema_migrations (version) VALUES ('20091111091951');
ALTER TABLE `positions` ADD `user_id` int(11);
ALTER TABLE `profile_logs` ADD `user_id` int(11);
ALTER TABLE `operations` ADD `user_id` int(11);
INSERT INTO schema_migrations (version) VALUES ('20091117070645');
CREATE TABLE `configurations` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `name` varchar(255), `type` varchar(255)) ENGINE=InnoDB;
CREATE  INDEX `index_configurations_on_name_and_type` ON `configurations` (`name`, `type`);
INSERT INTO schema_migrations (version) VALUES ('20091118023642');
CREATE TABLE `preferences` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `name` varchar(255) NOT NULL, `owner_id` int(11) NOT NULL, `owner_type` varchar(255) NOT NULL, `group_id` int(11), `group_type` varchar(255), `value` varchar(255), `created_at` datetime, `updated_at` datetime) ENGINE=InnoDB;
CREATE UNIQUE INDEX `index_preferences_on_owner_and_name_and_preference` ON `preferences` (`owner_id`, `owner_type`, `name`, `group_id`, `group_type`);
INSERT INTO schema_migrations (version) VALUES ('20091118053213');
-- 20091204075149
ALTER TABLE `profiles` ADD `assign_to` varchar(255);
ALTER TABLE `profiles` ADD `cv` text;
INSERT INTO schema_migrations (version) VALUES ('20091204075149');
-- 20091209092934
ALTER TABLE `positions` ADD `closed` tinyint(1) DEFAULT 0;
INSERT INTO schema_migrations (version) VALUES ('20091209092934');
-- 20091215073412
ALTER TABLE `profiles` ADD `assigned_at` datetime;
INSERT INTO schema_migrations (version) VALUES ('20091215073412');
-- 20091215080122
ALTER TABLE `profiles` ADD `chinese_name` varchar(255);
ALTER TABLE `profiles` ADD `mobile_phone` varchar(255);
ALTER TABLE `profiles` ADD `email` varchar(255);
ALTER TABLE `profiles` ADD `channel` varchar(255);
INSERT INTO schema_migrations (version) VALUES ('20091215080122');
-- 20091229041815
ALTER TABLE `positions` ADD `jd_file_name` varchar(255);
ALTER TABLE `positions` ADD `jd_content_type` varchar(255);
ALTER TABLE `positions` ADD `jd_file_size` int(11);
ALTER TABLE `positions` ADD `jd_file_updated_at` datetime;
INSERT INTO schema_migrations (version) VALUES ('20091229041815');
-- 20100106074852
CREATE TABLE `resumes` (`id` int(11) DEFAULT NULL auto_increment PRIMARY KEY, `file_file_name` varchar(255), `file_content_type` varchar(255), `file_file_size` int(11), `file_file_updated_at` datetime, `profile_id` int(11)) ENGINE=InnoDB;
CREATE  INDEX `index_resumes_on_profile_id` ON `resumes` (`profile_id`);
INSERT INTO schema_migrations (version) VALUES ('20100106074852');
