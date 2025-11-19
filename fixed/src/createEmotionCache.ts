import { createEmotionCache as createMuiEmotionCache } from '@mui/material-nextjs/v15-pagesRouter';

export default function createEmotionCache() {
  // Enable the CSS layer wrapper so SSR can preserve component style ordering.
  return createMuiEmotionCache({ key: 'mui', enableCssLayer: true });
}
