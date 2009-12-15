use `rms_production`;
ALTER TABLE `positions` ADD `closed` tinyint(1) DEFAULT 0;
INSERT INTO schema_migrations (version) VALUES ('20091209092934');
