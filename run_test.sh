#!/bin/bash

# Quick Test Script for Match Flow
# Run this to verify everything is working

echo "🧪 Running Match Flow Tests..."

# Test 1: Check Supabase connectivity
echo ""
echo "1️⃣ Testing Supabase connection..."
flutter pub get && echo "✅ Dependencies OK" || echo "❌ Dependencies failed"

# Test 2: Build project
echo ""
echo "2️⃣ Building project..."
flutter build apk --debug 2>&1 | head -20

# Test 3: Run app in debug mode
echo ""
echo "3️⃣ Starting app in debug mode..."
echo "⏳ App is starting... You should see these logs:"
echo "  ✅ 🔄 [SwipeBloc] LoadInfos: Loading profiles..."
echo "  ✅ 👉 [SwipeBloc] SwipeRight: Liking..."
echo "  ✅ 🎉 [SwipeBloc] MATCH FOUND! (THIS IS KEY!)"
echo ""
echo "If you DON'T see 'MATCH FOUND' - the mutual like wasn't detected"
echo ""

flutter run -v
