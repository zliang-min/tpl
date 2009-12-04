ALTER TABLE `profiles` ADD `assign_to` varchar(255);
ALTER TABLE `profiles` ADD `cv` text;
INSERT INTO schema_migrations (version) VALUES ('20091204075149');
