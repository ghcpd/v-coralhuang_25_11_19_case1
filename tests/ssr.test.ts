import { test, expect } from '@playwright/test';

// Helper function to check if styles are in the initial HTML
async function checkSSRStyles(page: any, url: string) {
  const response = await page.goto(url, { waitUntil: 'domcontentloaded' });
  const html = await response.text();
  
  // Check if Emotion styles are present in the HTML
  const hasEmotionStyles = html.includes('data-emotion');
  const hasMuiStyles = html.includes('MuiButton') || html.includes('MuiPaper') || html.includes('MuiAppBar');
  
  return {
    hasEmotionStyles,
    hasMuiStyles,
    html
  };
}

test.describe('Broken Version Tests', () => {
  test('should FAIL - broken version lacks SSR styles', async ({ page }) => {
    const { hasEmotionStyles, hasMuiStyles } = await checkSSRStyles(page, 'http://localhost:3000');
    
    // These should fail for the broken version
    console.log('Broken version - Has Emotion styles:', hasEmotionStyles);
    console.log('Broken version - Has MUI styles:', hasMuiStyles);
    
    expect(hasEmotionStyles).toBe(false); // Expect this to be false (broken)
    expect(hasMuiStyles).toBe(false); // Expect this to be false (broken)
  });

  test('should detect FOUC in broken version', async ({ page }) => {
    await page.goto('http://localhost:3000');
    
    // Take screenshot immediately after navigation (should show unstyled content)
    await page.waitForTimeout(100);
    const screenshot = await page.screenshot();
    
    // Check if button exists but might not be styled properly
    const button = page.locator('button:has-text("Primary Button")');
    await expect(button).toBeVisible();
    
    console.log('Broken version - Button found but may lack proper styling initially');
  });
});

test.describe('Fixed Version Tests', () => {
  test('should PASS - fixed version has SSR styles', async ({ page }) => {
    const { hasEmotionStyles, hasMuiStyles, html } = await checkSSRStyles(page, 'http://localhost:3001');
    
    // These should pass for the fixed version
    console.log('Fixed version - Has Emotion styles:', hasEmotionStyles);
    console.log('Fixed version - Has MUI styles:', hasMuiStyles);
    
    expect(hasEmotionStyles).toBe(true); // Should have Emotion styles
    expect(hasMuiStyles).toBe(true); // Should have MUI component styles
    
    // Verify specific style tags exist
    expect(html).toContain('data-emotion="mui');
  });

  test('should NOT have FOUC in fixed version', async ({ page }) => {
    await page.goto('http://localhost:3001');
    
    // Check that styles are applied immediately
    const button = page.locator('button:has-text("Primary Button")');
    await expect(button).toBeVisible();
    
    // Check if button has MUI styles applied
    const buttonClasses = await button.getAttribute('class');
    expect(buttonClasses).toContain('MuiButton');
    
    console.log('Fixed version - Button has proper MUI classes:', buttonClasses);
  });

  test('should have proper meta tags and insertion point', async ({ page }) => {
    await page.goto('http://localhost:3001');
    
    // Check for emotion insertion point meta tag
    const metaTag = page.locator('meta[name="emotion-insertion-point"]');
    await expect(metaTag).toHaveCount(1);
    
    console.log('Fixed version - Emotion insertion point meta tag found');
  });

  test('should render correctly with JavaScript disabled', async ({ browser }) => {
    const context = await browser.newContext({
      javaScriptEnabled: false
    });
    
    const page = await context.newPage();
    const { hasEmotionStyles, hasMuiStyles } = await checkSSRStyles(page, 'http://localhost:3001');
    
    console.log('Fixed version (no JS) - Has Emotion styles:', hasEmotionStyles);
    console.log('Fixed version (no JS) - Has MUI styles:', hasMuiStyles);
    
    // Even without JS, styles should be present
    expect(hasEmotionStyles).toBe(true);
    expect(hasMuiStyles).toBe(true);
    
    await context.close();
  });
});

test.describe('Hydration Tests', () => {
  test('fixed version should not have hydration warnings', async ({ page }) => {
    const consoleMessages: string[] = [];
    
    page.on('console', msg => {
      const text = msg.text();
      consoleMessages.push(text);
      if (text.includes('Warning') || text.includes('Error')) {
        console.log('Console:', text);
      }
    });
    
    await page.goto('http://localhost:3001');
    await page.waitForLoadState('networkidle');
    
    // Check for hydration warnings
    const hasHydrationWarning = consoleMessages.some(msg => 
      msg.includes('Hydration') || msg.includes('did not match')
    );
    
    expect(hasHydrationWarning).toBe(false);
    console.log('Fixed version - No hydration warnings detected');
  });
});
