SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `chats`;
DROP TABLE IF EXISTS `peer_matches`;
DROP TABLE IF EXISTS `channels`;
DROP TABLE IF EXISTS `communities`;
DROP TABLE IF EXISTS `user_interests`;
DROP TABLE IF EXISTS `user_profiles`;
DROP TABLE IF EXISTS `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================================
-- 1. TABLE STRUCTURES
-- =========================================================================

CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `role` ENUM('Student', 'Mentor') NOT NULL DEFAULT 'Student',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `user_profiles` (
  `user_id` INT PRIMARY KEY,
  `full_name` VARCHAR(100) NOT NULL,
  `institution` VARCHAR(150) NULL,
  `major` VARCHAR(100) NULL,
  `study_phase` VARCHAR(50) NULL,
  `objective` VARCHAR(255) NULL,
  `bio` TEXT NULL,
  `avatar_url` VARCHAR(255) NULL,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `user_interests` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `subject_name` VARCHAR(100) NOT NULL,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `idx_user_subject` (`user_id`, `subject_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `communities` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL,
  `privacy` ENUM('Public', 'Private') NOT NULL DEFAULT 'Public',
  `creator_id` INT NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`creator_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `channels` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `community_id` INT NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `type` ENUM('text', 'voice') NOT NULL DEFAULT 'text',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`community_id`) REFERENCES `communities`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `peer_matches` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `requester_id` INT NOT NULL,
  `receiver_id` INT NOT NULL,
  `status` ENUM('pending', 'accepted', 'rejected', 'blocked') NOT NULL DEFAULT 'pending',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`requester_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`receiver_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `idx_match_pair` (`requester_id`, `receiver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `chats` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `sender_id` INT NOT NULL,
  `receiver_id` INT NULL,  -- NULL if it's a channel message
  `channel_id` INT NULL,   -- NULL if it's a direct message
  `message` TEXT NOT NULL,
  `timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`sender_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`receiver_id`) REFERENCES `users`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`channel_id`) REFERENCES `channels`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================================
-- 2. SEED DATA
-- =========================================================================

-- Seed Built-in Admin/Dummy Accounts (Like Lumiora)
INSERT INTO `users` (`id`, `email`, `password_hash`, `role`) VALUES
(1, 'shandy@educonnect.com', '$2a$10$placeholderplaceholderplaceholderplaceholderplaceholder', 'Student'),
(2, 'mentor@educonnect.com', '$2a$10$placeholderplaceholderplaceholderplaceholderplaceholder', 'Mentor')
ON DUPLICATE KEY UPDATE `email`=VALUES(`email`);

INSERT INTO `user_profiles` (`user_id`, `full_name`, `institution`, `major`, `study_phase`, `objective`) VALUES
(1, 'Shandy Developer', 'Universitas Indonesia', 'Teknik Informatika', 'Semester 5', 'Mencari teman belajar untuk Machine Learning'),
(2, 'Dr. Budi', 'Institut Teknologi Bandung', 'Ilmu Komputer', 'Lulus', 'Membantu mahasiswa yang kesulitan dengan algoritma')
ON DUPLICATE KEY UPDATE `full_name`=VALUES(`full_name`);

INSERT INTO `user_interests` (`user_id`, `subject_name`) VALUES
(1, 'Machine Learning'),
(1, 'Web Dev'),
(2, 'Algoritma'),
(2, 'Machine Learning')
ON DUPLICATE KEY UPDATE `subject_name`=VALUES(`subject_name`);

INSERT INTO `communities` (`id`, `name`, `description`, `privacy`, `creator_id`) VALUES
(1, 'Komunitas Machine Learning', 'Tempat berbagi ilmu tentang AI dan ML', 'Public', 2)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

INSERT INTO `channels` (`id`, `community_id`, `name`, `type`) VALUES
(1, 1, 'general', 'text'),
(2, 1, 'voice-study', 'voice')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);
