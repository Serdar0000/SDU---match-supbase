# ⚡ Быстрый старт: Email Verification

## 🎯 Что нужно сделать (5 минут)

### 1. В Supabase Dashboard

Откройте: https://supabase.com/dashboard/project/bomhoafsiolfhfxcdiwt

#### A) Добавить Redirect URLs
1. **Authentication → URL Configuration**
2. В **Redirect URLs** добавьте:
   ```
   com.example.sdu_match://login-callback
   com.example.sdu_match://email-callback
   http://localhost
   ```
3. **Site URL**: `com.example.sdu_match://`
4. Жмите **Save**

#### B) Настроить Email Template (опционально, но красиво)
1. **Authentication → Email Templates → "Confirm signup"**
2. **Subject**: `Подтверди свой email в SDU Match 💙`
3. **Body**: Скопируйте шаблон из [EMAIL_VERIFICATION_SETUP.md](EMAIL_VERIFICATION_SETUP.md#12-изменить-subject-тему-письма)

### 2. В приложении

Уже настроено! ✅
- Deep links добавлены в AndroidManifest.xml
- Deep links добавлены в Info.plist
- Auth listener настроен в main.dart

### 3. Тестирование

```bash
# Соберите APK
flutter build apk

# Установите на телефон
flutter install

# Или просто запустите
flutter run
```

**Чтобы протестировать:**
1. Зарегистрируйтесь с реальным email (формат: `240103064@sdu.edu.kz`)
2. Проверьте почту НА ТЕЛЕФОНЕ
3. Нажмите кнопку в письме
4. Приложение откроется и вы авторизуетесь! 🎉

---

## 🐛 Не работает?

### Email не приходит?
- Проверьте Спам
- Или отключите verification: **Settings → Auth → "Enable email confirmations" → OFF**

### Ссылка открывает браузер?
- Deep links работают только на реальном устройстве или после установки APK
- Эмулятор может не поддерживать deep links

### "Invalid confirmation link"?
- Ссылка живет только 24 часа
- Зарегистрируйтесь заново

---

## 📖 Подробная инструкция

Смотрите [EMAIL_VERIFICATION_SETUP.md](EMAIL_VERIFICATION_SETUP.md) для детальной настройки.
