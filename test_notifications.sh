// Test Edge Function locally to check Firebase integration
// Run this in Supabase SQL Editor or via curl

// 1. Test the notify-fcm function by calling it directly
curl -X POST 'YOUR_SUPABASE_URL/functions/v1/notify-fcm' \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ANON_KEY' \
  -d '{
    "user_id": "USER_ID_TO_NOTIFY",
    "title": "It'\''s a Match!",
    "body": "You have a new match! 🎉",
    "data": {
      "screen": "match",
      "match_id": "MATCH_ID"
    }
  }'

// 2. Check if FCM token is stored in profiles table
select id, fcm_token from profiles where fcm_token is not null limit 5;

// 3. Check Edge Function logs in Supabase
// Go to: Supabase Dashboard → Functions → notify-fcm → Logs
