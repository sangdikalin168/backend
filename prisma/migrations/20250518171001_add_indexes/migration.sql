-- CreateTable
CREATE TABLE `Member` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `phone` VARCHAR(191) NULL,
    `gender` ENUM('MALE', 'FEMALE') NULL,
    `image` VARCHAR(191) NULL,
    `rfidTag` VARCHAR(191) NULL,
    `fingerprintHash` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Member_rfidTag_key`(`rfidTag`),
    INDEX `Member_name_idx`(`name`),
    INDEX `Member_phone_idx`(`phone`),
    INDEX `Member_rfidTag_idx`(`rfidTag`),
    INDEX `Member_gender_idx`(`gender`),
    INDEX `Member_createdAt_idx`(`createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MembershipPackage` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `durationDays` INTEGER NOT NULL,
    `maxCheckInsPerDay` INTEGER NULL,
    `price` DOUBLE NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MemberMembership` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `memberId` INTEGER NOT NULL,
    `membershipPackageId` INTEGER NOT NULL,
    `purchaseDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `expiryDate` DATETIME(3) NOT NULL,
    `remainingCheckIns` INTEGER NULL,
    `isSuspended` BOOLEAN NOT NULL DEFAULT false,
    `suspendedUntil` DATETIME(3) NULL,

    INDEX `MemberMembership_memberId_expiryDate_idx`(`memberId`, `expiryDate`),
    INDEX `MemberMembership_memberId_idx`(`memberId`),
    INDEX `MemberMembership_membershipPackageId_idx`(`membershipPackageId`),
    INDEX `MemberMembership_expiryDate_idx`(`expiryDate`),
    INDEX `MemberMembership_isSuspended_idx`(`isSuspended`),
    INDEX `MemberMembership_suspendedUntil_idx`(`suspendedUntil`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MemberCheckIn` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `memberId` INTEGER NOT NULL,
    `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `MemberCheckIn_memberId_timestamp_idx`(`memberId`, `timestamp`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MemberTransferRequest` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `fromMemberId` INTEGER NOT NULL,
    `toMemberId` INTEGER NOT NULL,
    `fromMembershipId` INTEGER NOT NULL,
    `toMembershipId` INTEGER NOT NULL,
    `reason` VARCHAR(191) NULL,
    `requestedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `approvedAt` DATETIME(3) NULL,
    `status` ENUM('PENDING', 'APPROVED', 'DECLINED') NOT NULL DEFAULT 'PENDING',
    `approvedById` INTEGER NULL,
    `requestedById` INTEGER NULL,

    INDEX `MemberTransferRequest_fromMemberId_toMemberId_idx`(`fromMemberId`, `toMemberId`),
    INDEX `MemberTransferRequest_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MemberHoldRequest` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `memberId` INTEGER NOT NULL,
    `membershipId` INTEGER NOT NULL,
    `reason` VARCHAR(191) NULL,
    `startDate` DATETIME(3) NOT NULL,
    `endDate` DATETIME(3) NOT NULL,
    `status` ENUM('PENDING', 'APPROVED', 'DECLINED') NOT NULL DEFAULT 'PENDING',
    `requestedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `approvedAt` DATETIME(3) NULL,
    `approvedById` INTEGER NULL,
    `requestedById` INTEGER NULL,

    INDEX `MemberHoldRequest_memberId_idx`(`memberId`),
    INDEX `MemberHoldRequest_membershipId_idx`(`membershipId`),
    INDEX `MemberHoldRequest_status_idx`(`status`),
    INDEX `MemberHoldRequest_requestedAt_idx`(`requestedAt`),
    INDEX `MemberHoldRequest_approvedAt_idx`(`approvedAt`),
    INDEX `MemberHoldRequest_approvedById_idx`(`approvedById`),
    INDEX `MemberHoldRequest_requestedById_idx`(`requestedById`),
    INDEX `MemberHoldRequest_memberId_status_idx`(`memberId`, `status`),
    INDEX `MemberHoldRequest_endDate_idx`(`endDate`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Ticket` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `qrCode` VARCHAR(191) NOT NULL,
    `printedBy` VARCHAR(191) NOT NULL,
    `soldAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `expiresAt` DATETIME(3) NOT NULL,
    `isUsed` BOOLEAN NOT NULL DEFAULT false,

    UNIQUE INDEX `Ticket_qrCode_key`(`qrCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TicketCheckIn` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `ticketId` INTEGER NOT NULL,
    `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `TicketCheckIn_ticketId_timestamp_idx`(`ticketId`, `timestamp`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CouponType` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `totalUses` INTEGER NOT NULL,
    `durationDays` INTEGER NULL,
    `price` DECIMAL(65, 30) NOT NULL,
    `expiresAfterDays` INTEGER NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Coupon` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `couponId` INTEGER NOT NULL,
    `qrCode` VARCHAR(191) NOT NULL,
    `soldAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `printedBy` VARCHAR(191) NOT NULL,
    `expiresAt` DATETIME(3) NOT NULL,
    `remainingUses` INTEGER NOT NULL,
    `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Coupon_qrCode_key`(`qrCode`),
    INDEX `Coupon_couponId_timestamp_idx`(`couponId`, `timestamp`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CouponCheckIn` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `couponId` INTEGER NOT NULL,
    `timestamp` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `CouponCheckIn_couponId_timestamp_idx`(`couponId`, `timestamp`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Promotion` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `discountPercent` DOUBLE NULL,
    `discountAmount` DECIMAL(65, 30) NULL,
    `startDate` DATETIME(3) NOT NULL,
    `endDate` DATETIME(3) NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,

    UNIQUE INDEX `Promotion_code_key`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PromotionUsage` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `promotionId` INTEGER NOT NULL,
    `usedById` INTEGER NULL,
    `usedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `PromotionUsage_promotionId_usedById_idx`(`promotionId`, `usedById`),
    INDEX `PromotionUsage_usedAt_idx`(`usedAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Account` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `type` ENUM('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE') NOT NULL,
    `balance` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,

    UNIQUE INDEX `Account_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `JournalEntry` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `description` VARCHAR(191) NOT NULL,
    `referenceId` VARCHAR(191) NULL,
    `postedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `totalCredit` DECIMAL(65, 30) NULL,
    `totalDebit` DECIMAL(65, 30) NULL,

    INDEX `JournalEntry_postedAt_idx`(`postedAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `JournalLineItem` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `accountId` INTEGER NOT NULL,
    `journalId` INTEGER NOT NULL,
    `amount` DECIMAL(65, 30) NOT NULL,
    `type` ENUM('CREDIT', 'DEBIT') NOT NULL,

    INDEX `JournalLineItem_accountId_idx`(`accountId`),
    INDEX `JournalLineItem_journalId_idx`(`journalId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE INDEX `User_email_idx` ON `User`(`email`);

-- CreateIndex
CREATE INDEX `User_role_idx` ON `User`(`role`);

-- CreateIndex
CREATE INDEX `User_createdAt_idx` ON `User`(`createdAt`);

-- AddForeignKey
ALTER TABLE `MemberMembership` ADD CONSTRAINT `fk_membership_member` FOREIGN KEY (`memberId`) REFERENCES `Member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberMembership` ADD CONSTRAINT `fk_membership_package` FOREIGN KEY (`membershipPackageId`) REFERENCES `MembershipPackage`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberCheckIn` ADD CONSTRAINT `MemberCheckIn_memberId_fkey` FOREIGN KEY (`memberId`) REFERENCES `Member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberTransferRequest` ADD CONSTRAINT `fk_transfer_approved_by_user` FOREIGN KEY (`approvedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberTransferRequest` ADD CONSTRAINT `fk_transfer_requested_by_user` FOREIGN KEY (`requestedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberTransferRequest` ADD CONSTRAINT `fk_transfer_from_member` FOREIGN KEY (`fromMemberId`) REFERENCES `Member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberTransferRequest` ADD CONSTRAINT `fk_transfer_to_member` FOREIGN KEY (`toMemberId`) REFERENCES `Member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberTransferRequest` ADD CONSTRAINT `fk_transfer_from_membership` FOREIGN KEY (`fromMembershipId`) REFERENCES `MemberMembership`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberTransferRequest` ADD CONSTRAINT `fk_transfer_to_membership` FOREIGN KEY (`toMembershipId`) REFERENCES `MemberMembership`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberHoldRequest` ADD CONSTRAINT `MemberHoldRequest_memberId_fkey` FOREIGN KEY (`memberId`) REFERENCES `Member`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberHoldRequest` ADD CONSTRAINT `MemberHoldRequest_membershipId_fkey` FOREIGN KEY (`membershipId`) REFERENCES `MemberMembership`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberHoldRequest` ADD CONSTRAINT `MemberHoldRequest_approvedById_fkey` FOREIGN KEY (`approvedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MemberHoldRequest` ADD CONSTRAINT `MemberHoldRequest_requestedById_fkey` FOREIGN KEY (`requestedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TicketCheckIn` ADD CONSTRAINT `TicketCheckIn_ticketId_fkey` FOREIGN KEY (`ticketId`) REFERENCES `Ticket`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Coupon` ADD CONSTRAINT `Coupon_couponId_fkey` FOREIGN KEY (`couponId`) REFERENCES `CouponType`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CouponCheckIn` ADD CONSTRAINT `CouponCheckIn_couponId_fkey` FOREIGN KEY (`couponId`) REFERENCES `Coupon`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PromotionUsage` ADD CONSTRAINT `fk_promotion_usage_promotion` FOREIGN KEY (`promotionId`) REFERENCES `Promotion`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PromotionUsage` ADD CONSTRAINT `fk_promotion_used_by_member` FOREIGN KEY (`usedById`) REFERENCES `Member`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `JournalLineItem` ADD CONSTRAINT `fk_journal_credit_account` FOREIGN KEY (`accountId`) REFERENCES `Account`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `JournalLineItem` ADD CONSTRAINT `fk_journal_debit_account` FOREIGN KEY (`accountId`) REFERENCES `Account`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `JournalLineItem` ADD CONSTRAINT `JournalLineItem_journalId_fkey` FOREIGN KEY (`journalId`) REFERENCES `JournalEntry`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
