# Loyalty Reward manual test sheet

Run `Database/schema.sql`, `Database/sample-data.sql`, then the migration when upgrading an existing database. Record Actual result and Pass/Fail during execution.

| Test ID | Precondition | Steps | Expected result | Actual result | Pass/Fail |
|---|---|---|---|---|---|
| GI09-01 | Admin logged in | Change POINT_EXPIRY_MONTHS, reload settings | New DB value is displayed; invalid/non-positive value is rejected | Not run | Not run |
| GI09-02 | Customer session | Open `/admin/tiers` | HTTP 403 | Not run | Not run |
| GI09-03 | Existing tier | Update unique min points and priority | Tier and booking lookup use new DB values | Not run | Not run |
| GI09-04 | Reward exists | Disable it, open customer rewards | Reward is absent from catalog; issued vouchers retain snapshots | Not run | Not run |
| GI05-01 | Active batch with expires_at <= GETDATE() | Open `/rewards` twice | Batch becomes EXPIRED once; one EXPIRED transaction; balance excludes it | Not run | Not run |
| GI05-02 | Two concurrent browser requests | Open `/rewards` simultaneously | UPDLOCK/conditional update prevents double expiry | Not run | Not run |
| GI06-01 | Enough active points in 2 batches | Redeem active reward | Earliest expiry batches deducted FIFO; voucher AVAILABLE; one REDEEMED transaction | Not run | Not run |
| GI06-02 | Insufficient/expired points | Submit redeem | No negative balance, voucher, or partial deduction | Not run | Not run |
| GI06-03 | One request token | POST the same token twice | One voucher only; same voucher code returned | Not run | Not run |
| GI07-01 | Owned pending booking and percentage voucher | POST bookingId + voucherCode | Server subtotal used; capped discount and final amount persisted | Not run | Not run |
| GI07-02 | Voucher belongs to another customer | Apply it | Rejected without booking changes | Not run | Not run |
| GI07-03 | One voucher, concurrent requests | Apply to two bookings | Unique indexes/transaction allow only one | Not run | Not run |
| GI07-04 | Voucher attached to booking | Complete booking through `transitionBooking` | Booking and voucher commit together; voucher USED | Not run | Not run |
| GI07-05 | Voucher attached to booking | Cancel before completion | Voucher AVAILABLE if valid, otherwise EXPIRED; booking discount cleared | Not run | Not run |

Verification queries:

```sql
SELECT * FROM LoyaltyConfig ORDER BY config_key;
SELECT * FROM LoyaltyPointBatch WHERE customer_id=? ORDER BY expires_at, earned_at;
SELECT * FROM LoyaltyTransaction WHERE customer_id=? ORDER BY created_at, transaction_id;
SELECT * FROM Redemption WHERE customer_id=? ORDER BY redemption_id;
SELECT booking_id, original_amount, discount_amount, final_amount, applied_redemption_id FROM Booking WHERE booking_id=?;
```
