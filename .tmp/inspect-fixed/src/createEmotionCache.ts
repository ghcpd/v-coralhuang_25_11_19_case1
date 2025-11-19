import { createEmotionCache as createMuiEmotionCache } from '@mui/material-nextjs/v15-pagesRouter';

export default function createEmotionCache() {
  // Defer to MUI's shared cache factory so both SSR and CSR agree on cache configuration.
  return createMuiEmotionCache();
}
