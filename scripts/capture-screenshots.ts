import { chromium } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';

async function captureScreenshots() {
  console.log('Starting screenshot capture...');
  
  const browser = await chromium.launch();
  const context = await browser.newContext({
    viewport: { width: 1280, height: 720 }
  });

  // Ensure screenshots directory exists
  const screenshotsDir = path.join(process.cwd(), 'screenshots');
  if (!fs.existsSync(screenshotsDir)) {
    fs.mkdirSync(screenshotsDir, { recursive: true });
  }

  try {
    // Capture broken version
    console.log('Capturing broken version (port 3000)...');
    const brokenPage = await context.newPage();
    await brokenPage.goto('http://localhost:3000', { waitUntil: 'domcontentloaded' });
    
    // Wait just a tiny bit to show the unstyled content before hydration
    await brokenPage.waitForTimeout(100);
    
    await brokenPage.screenshot({
      path: path.join(screenshotsDir, 'broken.png'),
      fullPage: false
    });
    console.log('✓ Saved screenshots/broken.png');
    await brokenPage.close();

    // Capture fixed version
    console.log('Capturing fixed version (port 3001)...');
    const fixedPage = await context.newPage();
    await fixedPage.goto('http://localhost:3001', { waitUntil: 'domcontentloaded' });
    
    // Wait a moment for rendering
    await fixedPage.waitForTimeout(100);
    
    await fixedPage.screenshot({
      path: path.join(screenshotsDir, 'fixed.png'),
      fullPage: false
    });
    console.log('✓ Saved screenshots/fixed.png');
    await fixedPage.close();

    console.log('\nScreenshot capture complete!');
  } catch (error) {
    console.error('Error capturing screenshots:', error);
    throw error;
  } finally {
    await browser.close();
  }
}

captureScreenshots().catch(console.error);
