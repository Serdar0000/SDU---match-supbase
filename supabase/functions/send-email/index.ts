// Supabase Edge Function для отправки email-уведомлений
// Деплой: supabase functions deploy send-email

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  try {
    const { to, subject, body } = await req.json();

    // Вариант 1: Используйте Resend (бесплатно 100 email/день)
    const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY');
    
    if (RESEND_API_KEY) {
      const response = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${RESEND_API_KEY}`,
        },
        body: JSON.stringify({
          from: 'SDU Match <noreply@yourdomain.com>',
          to: [to],
          subject: subject,
          html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
              <h2 style="color: #FF6B9D;">SDU Match</h2>
              <p>${body}</p>
              <hr style="border: 1px solid #eee; margin: 20px 0;">
              <p style="color: #666; font-size: 12px;">
                Вы получили это письмо, потому что у вас включены email-уведомления в SDU Match.
                <br>
                Чтобы отключить, откройте приложение → Настройки → Email уведомления.
              </p>
            </div>
          `,
        }),
      });

      const result = await response.json();
      
      return new Response(
        JSON.stringify({ success: true, result }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Вариант 2: Используйте SendGrid
    const SENDGRID_API_KEY = Deno.env.get('SENDGRID_API_KEY');
    
    if (SENDGRID_API_KEY) {
      const response = await fetch('https://api.sendgrid.com/v3/mail/send', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${SENDGRID_API_KEY}`,
        },
        body: JSON.stringify({
          personalizations: [{
            to: [{ email: to }],
          }],
          from: { email: 'noreply@yourdomain.com', name: 'SDU Match' },
          subject: subject,
          content: [{
            type: 'text/html',
            value: `
              <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #FF6B9D;">SDU Match</h2>
                <p>${body}</p>
              </div>
            `,
          }],
        }),
      });

      return new Response(
        JSON.stringify({ success: true }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Если нет API ключей - просто логируем
    console.log(`Email to ${to}: ${subject} - ${body}`);
    
    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Email logged (no API key configured)' 
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    );

  } catch (error) {
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
