# 📧 Настройка Email Verification для SDU Match

## 🎯 Что настраиваем

После регистрации пользователь получает email с ссылкой для подтверждения почты. Эта ссылка должна:
1. Открывать приложение (не браузер)
2. Автоматически подтверждать email
3. Показывать красивое сообщение

---

## 📝 Шаг 1: Настроить Email Template в Supabase

### 1.1 Открыть Email Templates

1. Откройте [Supabase Dashboard](https://supabase.com/dashboard/project/bomhoafsiolfhfxcdiwt)
2. Перейдите в: **Authentication → Email Templates**
3. Выберите **"Confirm signup"**

### 1.2 Изменить Subject (тему письма)

```
Подтверди свой email в SDU Match 💙
```

### 1.3 Изменить Body (текст письма)

Замените весь текст на:

```html
<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
  <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px; text-align: center; border-radius: 10px 10px 0 0;">
    <h1 style="color: white; margin: 0; font-size: 32px;">💙 SDU Match</h1>
  </div>
  
  <div style="background: #f7f9fc; padding: 40px; border-radius: 0 0 10px 10px;">
    <h2 style="color: #333; margin-top: 0;">Привет! 👋</h2>
    
    <p style="color: #666; font-size: 16px; line-height: 1.6;">
      Добро пожаловать в <strong>SDU Match</strong> — приложение для знакомств студентов SDU!
    </p>
    
    <p style="color: #666; font-size: 16px; line-height: 1.6;">
      Пожалуйста, подтверди свой email, чтобы начать знакомиться с другими студентами.
    </p>
    
    <div style="text-align: center; margin: 30px 0;">
      <a href="{{ .ConfirmationURL }}" 
         style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                color: white; 
                padding: 15px 40px; 
                text-decoration: none; 
                border-radius: 25px; 
                font-size: 16px; 
                font-weight: bold;
                display: inline-block;">
        Подтвердить Email ✨
      </a>
    </div>
    
    <p style="color: #999; font-size: 14px; margin-top: 30px;">
      Если кнопка не работает, скопируй эту ссылку в браузер:
    </p>
    <p style="color: #667eea; font-size: 12px; word-break: break-all;">
      {{ .ConfirmationURL }}
    </p>
    
    <hr style="border: none; border-top: 1px solid #e0e0e0; margin: 30px 0;">
    
    <p style="color: #999; font-size: 12px; text-align: center;">
      Если ты не регистрировался в SDU Match, просто игнорируй это письмо.
    </p>
  </div>
</div>
```

### 1.4 Сохранить

Нажмите **Save** внизу страницы.

---

## 🔗 Шаг 2: Настроить Redirect URLs

Это критически важно, чтобы ссылка открывала приложение!

### 2.1 Открыть URL Configuration

1. В Supabase Dashboard: **Authentication → URL Configuration**
2. Найдите секцию **Redirect URLs**

### 2.2 Добавить Deep Link URLs

Добавьте следующие URL (каждый на новой строке):

```
com.example.sdu_match://login-callback
com.example.sdu_match://email-callback
http://localhost
```

### 2.3 Установить Site URL

```
com.example.sdu_match://
```

### 2.4 Сохранить

Нажмите **Save**

---

## 📱 Шаг 3: Проверка на устройстве

### Android

1. Соберите APK:
   ```bash
   flutter build apk
   ```

2. Установите на телефон:
   ```bash
   flutter install
   ```

3. Зарегистрируйтесь с реальным email
4. Откройте письмо НА ТЕЛЕФОНЕ
5. Нажмите кнопку в письме → должно открыть приложение

### iOS

1. Запустите на iOS устройстве или симуляторе:
   ```bash
   flutter run
   ```

2. Зарегистрируйтесь
3. Проверьте email на устройстве

⚠️ **Важно**: Deep links работают только на реальных устройствах или после установки APK. В эмуляторе могут не работать!

---

## 🐛 Устранение проблем

### Проблема: Ссылка открывает браузер, а не приложение

**Решение:**
1. Проверьте что deep links правильно настроены в `AndroidManifest.xml` и `Info.plist`
2. Убедитесь что URL в Supabase точно совпадает: `com.example.sdu_match://login-callback`
3. Переустановите приложение

### Проблема: Email не приходит

**Решение:**
1. Проверьте папку Спам
2. В Supabase Dashboard → Settings → Auth убедитесь что:
   - "Enable email confirmations" включено
   - Email provider настроен
3. Для тестирования можно отключить email confirmation:
   - Settings → Auth → "Enable email confirmations" → OFF

### Проблема: "Invalid email confirmation link"

**Решение:**
- Ссылка действует только 24 часа
- Попробуйте зарегистрироваться заново
- Проверьте что Redirect URLs настроены правильно

---

## 🧪 Тестирование без email verification

Для разработки можно временно отключить подтверждение email:

1. Supabase Dashboard → **Settings → Auth**
2. Найдите **"Enable email confirmations"**
3. Выключите переключатель
4. Теперь пользователи сразу будут подтверждены

⚠️ **Не забудьте включить обратно перед продакшеном!**

---

## ✨ Дополнительные Email Templates

### Восстановление пароля

В **Email Templates → "Reset Password"** можно настроить письмо для сброса пароля.

### Изменение email

В **Email Templates → "Change Email Address"** можно настроить письмо при смене email.

---

## 📋 Чеклист

- [ ] Email Template настроен с красивым дизайном
- [ ] Redirect URLs добавлены в Supabase
- [ ] Site URL установлен
- [ ] Deep links работают в AndroidManifest.xml
- [ ] Deep links работают в Info.plist
- [ ] Email приходит (проверьте Спам)
- [ ] Ссылка открывает приложение
- [ ] После перехода пользователь авторизован

---

## 🎉 Готово!

Теперь при регистрации:
1. ✅ Пользователь получает красивое письмо
2. ✅ Нажимает кнопку → открывается приложение
3. ✅ Email автоматически подтверждается
4. ✅ Пользователь попадает в онбординг

Если возникнут проблемы, проверьте [SUPABASE_SETUP.md](SUPABASE_SETUP.md)
