const playwright = require('playwright');
const fs = require('fs');
const path = require('path');

async function captureScreenshots() {
  console.log('Starting screenshot capture...');
  
  const browser = await playwright.chromium.launch();

  const screenshotsDir = path.join(__dirname, '..', 'screenshots');
  if (!fs.existsSync(screenshotsDir)) {
    fs.mkdirSync(screenshotsDir, { recursive: true });
  }

  try {
    // Capture broken version WITH JavaScript disabled to show missing SSR styles
    console.log('Capturing broken version (port 3000) with JS disabled...');
    const brokenContext = await browser.newContext({
      viewport: { width: 1280, height: 720 },
      javaScriptEnabled: false  // Disable JS to see pure SSR output
    });
    const brokenPage = await brokenContext.newPage();
    await brokenPage.goto('http://localhost:3000', { waitUntil: 'domcontentloaded' });
    await brokenPage.waitForTimeout(500);
    
    await brokenPage.screenshot({
      path: path.join(screenshotsDir, 'broken.png'),
      fullPage: false
    });
    console.log('✓ Saved screenshots/broken.png (JS disabled - shows missing SSR styles)');
    await brokenPage.close();
    await brokenContext.close();

    // Capture fixed version with JavaScript disabled to show it still works
    console.log('Capturing fixed version (port 3001) with JS disabled...');
    const fixedContext = await browser.newContext({
      viewport: { width: 1280, height: 720 },
      javaScriptEnabled: false  // Disable JS to prove SSR works
    });
    const fixedPage = await fixedContext.newPage();
    await fixedPage.goto('http://localhost:3001', { waitUntil: 'domcontentloaded' });
    await fixedPage.waitForTimeout(500);
    
    await fixedPage.screenshot({
      path: path.join(screenshotsDir, 'fixed.png'),
      fullPage: false
    });
    console.log('✓ Saved screenshots/fixed.png (JS disabled - shows proper SSR styles)');
    await fixedPage.close();
    await fixedContext.close();

    console.log('\n========================================');
    console.log('Screenshot capture complete!');
    console.log('========================================');
    console.log('The difference should now be clear:');
    console.log('  broken.png - Unstyled (no SSR styles)');
    console.log('  fixed.png  - Fully styled (proper SSR)');
    console.log('Both captured with JavaScript DISABLED to show pure SSR output.');
  } catch (error) {
    console.error('Error capturing screenshots:', error);
    throw error;
  } finally {
    await browser.close();
  }
}

captureScreenshots().catch(console.error);
