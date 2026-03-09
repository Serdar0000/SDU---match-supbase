import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import { JWT } from "https://esm.sh/google-auth-library@9"
import "https://deno.land/std@0.168.0/dotenv/load.ts";


const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const FIREBASE_SERVICE_ACCOUNT = JSON.parse(Deno.env.get('FIREBASE_SERVICE_ACCOUNT') || '{}');

serve(async (req) => {
  try {
    const { user_id, title, body, data } = await req.json();

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Получаем FCM токен пользователя
    const { data: profile, error } = await supabase
      .from('profiles')
      .select('fcm_token')
      .eq('id', user_id)
      .single();

    if (error || !profile?.fcm_token) {
      console.error("FCM Token not found for user:", user_id);
      return new Response(JSON.stringify({ error: "No FCM token found" }), { status: 404 });
    }

    const accessToken = await getGoogleAccessToken();

    const response = await fetch(`https://fcm.googleapis.com/v1/projects/${FIREBASE_SERVICE_ACCOUNT.project_id}/messages:send`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        message: {
          token: profile.fcm_token,
          notification: { title, body },
          data: data || {},
        }
      }),
    });

    const result = await response.json();
    console.log("FCM Result:", result);

    return new Response(JSON.stringify(result), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Error in notify-fcm:", err);
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});

async function getGoogleAccessToken() {
  const client = new JWT({
    email: FIREBASE_SERVICE_ACCOUNT.client_email,
    key: FIREBASE_SERVICE_ACCOUNT.private_key,
    scopes: ['https://www.googleapis.com/auth/cloud-platform'],
  });
  const res = await client.getAccessToken();
  return res.token;
}
