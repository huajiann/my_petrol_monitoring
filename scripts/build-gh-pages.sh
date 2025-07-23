#!/bin/bash

# Build script for GitHub Pages deployment
# This script builds the Flutter web app with the correct base href

echo "🚀 Building Flutter web app for GitHub Pages..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for GitHub Pages with correct base href
echo "🔨 Building web app..."
flutter build web --base-href "/my_petrol_monitoring/" --release

echo "✅ Build completed! Files are in build/web/"
echo "📁 You can now commit and push to trigger GitHub Pages deployment"
