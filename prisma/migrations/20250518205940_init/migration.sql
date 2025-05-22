/*
  Warnings:

  - You are about to drop the `coupontype` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `coupon` DROP FOREIGN KEY `Coupon_couponId_fkey`;

-- DropTable
DROP TABLE `coupontype`;

-- CreateTable
CREATE TABLE `CouponCard` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `totalUses` INTEGER NOT NULL,
    `durationDays` INTEGER NULL,
    `price` DECIMAL(65, 30) NOT NULL,
    `expiresAfterDays` INTEGER NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Coupon` ADD CONSTRAINT `Coupon_couponId_fkey` FOREIGN KEY (`couponId`) REFERENCES `CouponCard`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
