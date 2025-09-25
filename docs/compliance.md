# Compliance & Risk

This document contains instructions for running various compliance scripts for Gumroad.

To use, run these commands in the production console.

## User compliance

### Suspend users for ToS violation

```rb
user_ids = []

users = User.find(user_ids)
users.each do |user|
  begin
    user.flag_for_tos_violation!(
      author_id: GUMROAD_ADMIN_ID,
      content: "Suspended for TOS violation on #{Time.current.to_fs(:formatted_date_full_month)}",
      bulk: true
    )
    user.suspend_for_tos_violation!(
      author_id: GUMROAD_ADMIN_ID,
      content: "Suspended for TOS violation on #{Time.current.to_fs(:formatted_date_full_month)}",
      bulk: true
    )
  rescue => e
    puts "Error processing user #{user.id}: #{e.message}"
  end
end
```

### Suspend users for fraud

```rb
user_ids = []

users = User.find(user_ids)
users.each do |user|
  begin
    user.flag_for_fraud!(
      author_id: GUMROAD_ADMIN_ID,
      content: "Suspended for fraud on #{Time.current.to_fs(:formatted_date_full_month)}"
    )
    user.suspend_for_fraud!(
      author_id: GUMROAD_ADMIN_ID,
      content: "Suspended for fraud on #{Time.current.to_fs(:formatted_date_full_month)}"
    )
  rescue => e
    puts "Error processing user #{user.id}: #{e.message}"
  end
end
```

### Suspend for fraud and refund user purchases

```rb
user_ids = []

users = User.find(user_ids)
users.each do |user|
  begin
    user.flag_for_fraud!(
      author_id: GUMROAD_ADMIN_ID,
      content: "Suspended for fraud on #{Time.current.to_fs(:formatted_date_full_month)}"
    )
    user.suspend_for_fraud!(
      author_id: GUMROAD_ADMIN_ID,
      content: "Suspended for fraud on #{Time.current.to_fs(:formatted_date_full_month)}"
    )
    user.sales.where(purchase_success_balance_id: user.unpaid_balances.pluck(:id)).not_fully_refunded.not_chargedback_or_chargedback_reversed.each do |purchase|
      begin
        next if user.unpaid_balance_cents <= 0
        purchase.refund!(refunding_user_id: GUMROAD_ADMIN_ID)
      rescue => e
        puts "Error refunding purchase #{purchase.id} for user #{user.id}: #{e.message}"
      end
    end
  rescue => e
    puts "Error processing user #{user.id}: #{e.message}"
  end
end
```

### Mark users compliant (unsuspend users)

```rb
user_ids = []

users = User.find(user_ids)
users.each do |user|
  begin
    user.mark_compliant!(author_name: "Iffy")
  rescue => e
    puts "Error processing user #{user.id}: #{e.message}"
  end
end
```

## Purchases

### Refund purchases

```rb
purchase_ids = []

purchase_ids.each do |purchase_id|
  begin
    purchase = Purchase.not_fully_refunded.not_chargedback_or_chargedback_reversed.find_by(id: purchase_id)
    if purchase
      purchase.refund!(refunding_user_id: GUMROAD_ADMIN_ID)
    end
  rescue => e
    puts "Error processing purchase #{purchase_id}: #{e.message}"
  end
end
```
