# SRS.md

**Version:** v0.1.0 (Draft)

## Purpose

Đặc tả nghiệp vụ Assessment AutoWashPro.

## Scope

-   Booking
-   Loyalty
-   Membership Tier
-   Reward & Voucher
-   Promotion
-   Reports
-   Guest
-   Admin Controls

## FR-AS-15

Tier Review dùng active_spent_money_12m hoặc active_visit_count_12m.
Không dùng active_points.

## FR-AS-16

Admin Controls: - Tier Management - Reward Management - Promotion
Management - Loyalty Settings - Reports

## FR-AS-17

Promotion theo tier, lưu DB.

## FR-AS-18

Reports: - Customer Loyalty - Booking & Revenue - Reward Redemption -
Promotion Delivery

## FR-AS-19

Roles: - Admin - Customer

## FR-AS-20

Status chuẩn: - Booking: PENDING, CONFIRMED, COMPLETED, CANCELLED -
Voucher: AVAILABLE, USED, EXPIRED, CANCELLED - Promotion: DRAFT, ACTIVE,
EXPIRED, INACTIVE - Point Batch: ACTIVE, USED_UP, EXPIRED

## FR-AS-21

Demo Flow: Guest -\> Register -\> Login -\> Booking -\> Completed -\>
Loyalty -\> Tier -\> Reward -\> Voucher -\> Promotion -\> Reports

## FR-AS-22

Guest chỉ xem thông tin công khai và đăng ký.

## Principles

-   Dữ liệu lấy từ database.
-   Không hardcode.
-   SRS chỉ mô tả nghiệp vụ.

## Next

-   Hoàn thiện database
-   Review source
