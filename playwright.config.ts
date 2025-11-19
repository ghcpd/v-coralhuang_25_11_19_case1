import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: 0,
  workers: 1,
  reporter: 'list',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
  webServer: [
    {
      command: 'npm run build:broken && npm run start:broken',
      port: 3000,
      timeout: 120000,
      reuseExistingServer: false,
    },
    {
      command: 'npm run build:fixed && npm run start:fixed',
      port: 3001,
      timeout: 120000,
      reuseExistingServer: false,
    },
  ],
});
