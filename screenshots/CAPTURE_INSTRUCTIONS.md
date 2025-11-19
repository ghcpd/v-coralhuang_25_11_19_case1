# Screenshot Placeholders

This directory contains screenshots comparing the broken and fixed versions:

## broken.png
- Shows the **FOUC (Flash of Unstyled Content)** issue
- Initial HTML render lacks MUI/Emotion styles
- Components appear as plain, unstyled HTML elements
- AppBar appears as plain text instead of styled header
- Buttons appear as basic HTML buttons without Material-UI styling
- Paper component lacks elevation/shadow styling

To capture this screenshot:
1. Build and start the broken version: `npm run build:broken && npm run start:broken`
2. Open http://localhost:3000 immediately
3. Capture screenshot before JavaScript hydrates (within ~100ms)
4. You'll see unstyled content flash before styles apply

## fixed.png
- Shows **proper SSR with full styling**
- Initial HTML includes all Emotion-generated CSS
- Components appear fully styled immediately on load
- AppBar has proper blue background and elevation
- Buttons have Material-UI contained/outlined styling
- Paper component has proper shadows and padding
- No FOUC - consistent rendering from first paint

To capture this screenshot:
1. Build and start the fixed version: `npm run build:fixed && npm run start:fixed`
2. Open http://localhost:3001
3. Capture screenshot immediately
4. You'll see fully styled content from the very first render

## Automated Screenshot Capture

Run the PowerShell script to capture both automatically:
```powershell
.\scripts\capture-screenshots.ps1
```

This will:
1. Start both servers
2. Wait for them to be ready
3. Use Playwright to capture screenshots
4. Stop the servers
5. Save screenshots to this directory
