// Supabase Edge Function для удаления аккаунта (GDPR)
// Деплой: supabase functions deploy delete-user-account --no-verify-jwt

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.4"

serve(async (req: Request) => {
  try {
    // Извлекаем JWT из заголовка Authorization
    const authHeader = req.headers.get('Authorization');
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return new Response(
        JSON.stringify({ error: 'Missing or invalid Authorization header' }),
        { status: 401, headers: { 'Content-Type': 'application/json' } }
      );
    }
    const userJwt = authHeader.replace('Bearer ', '');

    const { user_id } = await req.json();

    if (!user_id) {
      return new Response(
        JSON.stringify({ error: 'user_id is required' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Инициализируем Supabase администратором
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

    if (!supabaseUrl || !supabaseServiceRoleKey) {
      return new Response(
        JSON.stringify({ error: 'Missing Supabase configuration' }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const supabase = createClient(supabaseUrl, supabaseServiceRoleKey);

    // Проверяем JWT и убеждаемся, что пользователь удаляет только свой аккаунт
    const { data: { user: callerUser }, error: jwtError } = await supabase.auth.getUser(userJwt);
    if (jwtError || !callerUser) {
      return new Response(
        JSON.stringify({ error: 'Invalid or expired token' }),
        { status: 401, headers: { 'Content-Type': 'application/json' } }
      );
    }
    if (callerUser.id !== user_id) {
      return new Response(
        JSON.stringify({ error: 'Forbidden: cannot delete another user account' }),
        { status: 403, headers: { 'Content-Type': 'application/json' } }
      );
    }

    console.log(`🗑️ Starting account deletion for user: ${user_id}`);

    // Шаг 1: Удаляем профиль (это удалит данные через CASCADE)
    const { error: profileError } = await supabase
      .from('profiles')
      .delete()
      .eq('id', user_id);

    if (profileError) {
      console.error('❌ Error deleting profile:', profileError);
      throw new Error(`Failed to delete profile: ${profileError.message}`);
    }

    console.log(`✅ Profile for user ${user_id} deleted`);

    // Шаг 2: Удаляем пользователя из auth.users через REST API
    // (напрямую вместо SDK, так как это более надежно в Deno)
    try {
      const deleteAuthResponse = await fetch(
        `${supabaseUrl}/auth/v1/admin/users/${user_id}`,
        {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${supabaseServiceRoleKey}`,
            'apikey': supabaseServiceRoleKey,
          },
        }
      );

      if (!deleteAuthResponse.ok) {
        const errorData = await deleteAuthResponse.json();
        console.warn(`⚠️ Failed to delete auth user: ${deleteAuthResponse.status}`, errorData);
        // Не выбрасываем ошибку, так как профиль уже удален (это главное)
      } else {
        console.log(`✅ Auth user ${user_id} deleted from auth.users`);
      }
    } catch (authApiError) {
      console.warn(`⚠️ Error calling auth API: ${authApiError}`);
      // Продолжаем, так как профиль удален
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Account deleted successfully (profile removed, auth user deletion attempted)',
        user_id: user_id
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error in delete-user-account:', error);
    return new Response(
      JSON.stringify({ 
        error: error.message || 'Internal server error',
        success: false
      }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});

