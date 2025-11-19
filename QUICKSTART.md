# Next.js + MUI SSR Debug - Quick Start Guide

## 🎯 What This Project Does

This project demonstrates and fixes **5 critical SSR bugs** in a Next.js + Material-UI + Emotion integration that cause:
- ❌ FOUC (Flash of Unstyled Content)
- ❌ Missing styles on initial page load  
- ❌ Broken rendering with JavaScript disabled
- ❌ Potential hydration mismatches

## 📁 Project Structure

```
.
├── input/           ← BROKEN version (demonstrates bugs)
├── fixed/           ← FIXED version (proper SSR)
├── tests/           ← Automated Playwright tests
├── scripts/         ← Helper scripts
├── screenshots/     ← Visual comparison
│
├── setup.ps1        ← Install dependencies (Windows)
├── setup.sh         ← Install dependencies (Linux/Mac)
├── run.ps1          ← Run servers (Windows)
├── run.sh           ← Run servers (Linux/Mac)
├── test.ps1         ← Run tests (Windows)
├── test.sh          ← Run tests (Linux/Mac)
├── Dockerfile       ← Docker test environment
│
├── README.md        ← Full documentation
├── BUGS_AND_FIXES.md ← Detailed bug analysis
└── package.json     ← Dependencies
```

## 🚀 Quick Start (Windows)

### 1. Install Dependencies
```powershell
.\setup.ps1
```

### 2. Run Both Versions
```powershell
# Development mode
.\run.ps1 dev

# Production mode
.\run.ps1 prod
```

- **Broken version**: http://localhost:3000 (shows FOUC)
- **Fixed version**: http://localhost:3001 (proper SSR)

### 3. Run Tests
```powershell
.\test.ps1
```

### 4. Test with Docker
```powershell
docker build -t nextjs-mui-ssr-test .
docker run --rm nextjs-mui-ssr-test
```

## 🚀 Quick Start (Linux/Mac)

### 1. Install Dependencies
```bash
chmod +x setup.sh run.sh test.sh
./setup.sh
```

### 2. Run Both Versions
```bash
# Development mode
./run.sh dev

# Production mode
./run.sh prod
```

### 3. Run Tests
```bash
./test.sh
```

### 4. Test with Docker
```bash
docker build -t nextjs-mui-ssr-test .
docker run --rm nextjs-mui-ssr-test
```

## 🐛 The 5 Bugs (Summary)

| # | Bug | Impact | Fix |
|---|-----|--------|-----|
| 1 | Missing Emotion SSR extraction | No styles in HTML | Use `createEmotionServer` |
| 2 | `DocumentHeadTags` gets empty array | Styles discarded | Pass `emotionStyleTags` prop |
| 3 | No server-side Emotion cache | Inconsistent rendering | Create cache in `getInitialProps` |
| 4 | `getInitialProps` doesn't extract | Lost styles | Call `extractCriticalToChunks` |
| 5 | Insertion point not wired | Hydration issues | Consistent cache config |

See `BUGS_AND_FIXES.md` for detailed analysis of each bug.

## 🧪 What the Tests Verify

1. ✅ **SSR Style Detection** - Fixed version has styles in HTML
2. ✅ **FOUC Detection** - Broken version lacks initial styles
3. ✅ **JavaScript Disabled** - Fixed version works without JS
4. ✅ **Hydration Validation** - No warnings in fixed version
5. ✅ **Meta Tag Verification** - Proper insertion point setup

## 📸 Visual Comparison

### Broken Version (FOUC)
- Unstyled HTML on initial load
- Plain text instead of AppBar
- Basic buttons without MUI styling
- No Paper elevation/shadows

### Fixed Version (Proper SSR)
- Fully styled on initial load
- Styled AppBar with blue background
- Material-UI button styling
- Proper Paper component styling

Screenshots: `screenshots/broken.png` and `screenshots/fixed.png`

## 📋 Key Files Changed

### `fixed/pages/_document.tsx` (Main Fix)
```typescript
// ✅ Import Emotion server
import createEmotionServer from '@emotion/server/create-instance';
import createEmotionCache from '../src/createEmotionCache';

// ✅ Extract styles in getInitialProps
const cache = createEmotionCache();
const { extractCriticalToChunks } = createEmotionServer(cache);

// ✅ Inject cache during rendering
ctx.renderPage = () => originalRenderPage({
  enhanceApp: (App) => (props) => <App emotionCache={cache} {...props} />
});

// ✅ Extract and return style tags
const emotionStyles = extractCriticalToChunks(initialProps.html);
const emotionStyleTags = emotionStyles.styles.map(/* ... */);
return { ...initialProps, emotionStyleTags };

// ✅ Pass styles to DocumentHeadTags
<DocumentHeadTags {...this.props} emotionStyleTags={emotionStyleTags} />
```

## 🎓 What You'll Learn

- ✅ How CSS-in-JS SSR actually works
- ✅ Why Emotion needs explicit style extraction
- ✅ How to properly integrate MUI with Next.js SSR
- ✅ How to avoid FOUC in production
- ✅ How to test SSR implementations
- ✅ Best practices for Next.js + MUI + Emotion

## 📚 Full Documentation

- **README.md** - Complete setup and usage guide
- **BUGS_AND_FIXES.md** - Detailed bug analysis and fixes
- **screenshots/CAPTURE_INSTRUCTIONS.md** - How to capture screenshots

## ⚡ Common Commands

```powershell
# Windows
.\setup.ps1                          # Install
.\run.ps1 dev                        # Dev servers
.\run.ps1 prod                       # Production servers
.\test.ps1                           # Run tests

# Build individual versions
npm run build:broken
npm run build:fixed

# Start individual servers
npm run start:broken                 # Port 3000
npm run start:fixed                  # Port 3001
```

```bash
# Linux/Mac
./setup.sh                           # Install
./run.sh dev                         # Dev servers
./run.sh prod                        # Production servers  
./test.sh                            # Run tests
```

## 🔍 Verification Checklist

- [ ] Install dependencies successfully
- [ ] Build broken version (shows the bugs)
- [ ] Build fixed version (proper SSR)
- [ ] Run broken version and observe FOUC
- [ ] Run fixed version and confirm no FOUC
- [ ] Test with JavaScript disabled (broken fails, fixed works)
- [ ] Run automated tests (all pass)
- [ ] Check HTML source (broken has no styles, fixed has styles)
- [ ] Review console for hydration warnings (none in fixed)
- [ ] Test in Docker (reproducible environment)

## 🎯 Success Criteria

### Broken Version Should:
- ❌ Show FOUC on page load
- ❌ Have no styles in initial HTML source
- ❌ Be completely unstyled with JS disabled
- ❌ Pass "broken version" tests

### Fixed Version Should:
- ✅ Show styled content immediately
- ✅ Have `data-emotion` style tags in HTML source
- ✅ Work perfectly with JS disabled
- ✅ Have no hydration warnings
- ✅ Pass "fixed version" tests

## 🆘 Troubleshooting

### Tests Fail to Start Servers
```powershell
# Clean build directories
Remove-Item -Recurse -Force input\.next, fixed\.next

# Rebuild
npm run build:broken
npm run build:fixed
```

### Port Already in Use
```powershell
# Find and kill processes on ports 3000/3001
netstat -ano | findstr :3000
netstat -ano | findstr :3001
taskkill /PID <process_id> /F
```

### Playwright Browsers Not Installed
```powershell
npx playwright install chromium --with-deps
```

## 📞 Support

For detailed technical information:
- See `README.md` for full documentation
- See `BUGS_AND_FIXES.md` for bug analysis
- Check `tests/ssr.test.ts` for test implementation
- Review `fixed/pages/_document.tsx` for complete fix

## ✨ Summary

This project provides:
- ✅ Reproducible SSR bugs
- ✅ Complete fixes with explanations
- ✅ Automated test suite
- ✅ Visual comparisons
- ✅ Docker support
- ✅ Comprehensive documentation

Run `.\setup.ps1` (Windows) or `./setup.sh` (Linux/Mac) to get started!
