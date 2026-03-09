// Supabase Edge Function для отправки email-уведомлений
// Деплой: supabase functions deploy send-email

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req: Request) => {
  try {
    const { to, subject, body } = await req.json();

    // Используем Resend API (вместо SendGrid)
    const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY');
    
    if (!RESEND_API_KEY) {
      console.error('RESEND_API_KEY is not set');
      return new Response(
        JSON.stringify({ error: 'RESEND_API_KEY is not set' }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${RESEND_API_KEY}`,
      },
      body: JSON.stringify({
        from: 'SDU Match <onboarding@resend.dev>', // Или ваш верифицированный домен в Resend
        to: [to],
        subject: subject,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 10px;">
            <h2 style="color: #FF6B9D; text-align: center;">SDU Match</h2>
            <div style="font-size: 16px; line-height: 1.6; color: #333;">
              ${body}
            </div>
            <div style="margin-top: 30px; text-align: center;">
              <a href="https://sdu-match.kz" style="background-color: #FF6B9D; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold;">Перейти в приложение</a>
            </div>
            <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">
            <p style="color: #999; font-size: 12px; text-align: center;">
              Вы получили это письмо, потому что у вас включены уведомления в SDU Match.
            </p>
          </div>
        `,
      }),
    });

    if (response.ok) {
      const result = await response.json();
      return new Response(
        JSON.stringify({ success: true, result }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      );
    } else {
      const errorData = await response.text();
      console.error('Resend error:', errorData);
      return new Response(
        JSON.stringify({ error: 'Failed to send email via Resend', details: errorData }),
        { status: response.status, headers: { 'Content-Type': 'application/json' } }
      );
    }

  } catch (error) {
    console.error('Function error:', error);
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
