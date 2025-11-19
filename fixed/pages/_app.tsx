import * as React from 'react';
import type { AppProps } from 'next/app';
import { ThemeProvider, CssBaseline } from '@mui/material';
import { AppCacheProvider } from '@mui/material-nextjs/v15-pagesRouter';
import type { EmotionCache } from '@emotion/react';
import createEmotionCache from '../src/createEmotionCache';
import theme from '../src/theme';

const clientSideEmotionCache = createEmotionCache();

interface MyAppProps extends AppProps {
  emotionCache?: EmotionCache;
}

export default function MyApp(props: MyAppProps) {
  const { Component, pageProps, emotionCache = clientSideEmotionCache } = props;

  // Use the cache provided by SSR when available to keep style order consistent.
  return (
    <AppCacheProvider emotionCache={emotionCache}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <Component {...pageProps} />
      </ThemeProvider>
    </AppCacheProvider>
  );
}
