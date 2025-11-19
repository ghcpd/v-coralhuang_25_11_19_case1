// src/createEmotionCache.ts
import createCache from '@emotion/cache';

export default function createEmotionCache() {
  let insertionPoint: HTMLElement | undefined;

  if (typeof document !== 'undefined') {
    const emotionInsertionPoint = document.querySelector<HTMLMetaElement>(
      'meta[name="emotion-insertion-point"]'
    );
    if (emotionInsertionPoint) {
      insertionPoint = emotionInsertionPoint;
    }
  }

  return createCache({ key: 'mui', insertionPoint });
}
