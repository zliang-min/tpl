use `rms_production`;
ALTER TABLE `profiles` ADD `assigned_at` datetime;
INSERT INTO schema_migrations (version) VALUES ('20091215073412');
