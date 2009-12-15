use `rms_production`;
ALTER TABLE `profiles` ADD `chinese_name` varchar(255);
ALTER TABLE `profiles` ADD `mobile_phone` varchar(255);
ALTER TABLE `profiles` ADD `email` varchar(255);
ALTER TABLE `profiles` ADD `channel` varchar(255);
INSERT INTO schema_migrations (version) VALUES ('20091215080122');
