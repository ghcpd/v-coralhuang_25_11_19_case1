import * as React from 'react';
import Document, {
  Html,
  Head,
  Main,
  NextScript,
  DocumentContext,
  DocumentInitialProps,
} from 'next/document';
import {
  DocumentHeadTags,
  documentGetInitialProps,
} from '@mui/material-nextjs/v15-pagesRouter';
import theme from '../src/theme';

type MyDocumentProps = Awaited<ReturnType<typeof documentGetInitialProps>> &
  DocumentInitialProps;

export default class MyDocument extends Document<MyDocumentProps> {
  render() {
    return (
      <Html lang="en">
        <Head>
          <meta name="theme-color" content={theme.palette.primary.main} />
          <link rel="icon" href="/favicon.ico" />
          <DocumentHeadTags {...this.props} />
        </Head>
        <body>
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}

MyDocument.getInitialProps = async (
  ctx: DocumentContext
): Promise<MyDocumentProps> => {
  const initialProps = await documentGetInitialProps(ctx);

  const divMarker = '<div id="__next">';
  const markerIndex = initialProps.html.indexOf(divMarker);
  let html = initialProps.html;
  const movedStyleTags: React.ReactElement[] = [];

  if (markerIndex !== -1) {
    const contentStart = markerIndex + divMarker.length;
    const afterMarker = html.slice(contentStart);
    const beforeMarker = html.slice(0, contentStart);
    const stylePattern = /<style\b([^>]*)>([\s\S]*?)<\/style>/gi;
    const attrPattern = /([\w-:]+)="([^"]*)"/g;

    let cleanedBody = '';
    let cursor = 0;
    let attributeMatch: RegExpExecArray | null;

    for (const styleMatch of afterMarker.matchAll(stylePattern)) {
      const [raw, attributeFragment, css] = styleMatch;
      const matchIndex = styleMatch.index ?? 0;
      cleanedBody += afterMarker.slice(cursor, matchIndex);
      cursor = matchIndex + raw.length;

      const attributes: Record<string, string> = {};

      while ((attributeMatch = attrPattern.exec(attributeFragment))) {
        attributes[attributeMatch[1]] = attributeMatch[2];
      }

      attrPattern.lastIndex = 0;

      const dataEmotion = attributes['data-emotion'];

      if (dataEmotion && css.trim()) {
        const { nonce: nonceValue, ...other } = attributes;
        const elementProps: Record<string, unknown> = {
          ...other,
          'data-emotion': dataEmotion,
          dangerouslySetInnerHTML: { __html: css },
        };

        if (nonceValue) {
          elementProps.nonce = nonceValue;
        }

        movedStyleTags.push(
          React.createElement('style', {
            ...elementProps,
            key: `${dataEmotion}-${movedStyleTags.length}`,
          })
        );
      } else {
        cleanedBody += raw;
      }
    }

    cleanedBody += afterMarker.slice(cursor);

    if (movedStyleTags.length > 0) {
      html = beforeMarker + cleanedBody;
    }
  }

  const existingTags = (initialProps.emotionStyleTags ?? []).filter(
    (tag): tag is React.ReactElement => Boolean(tag)
  );

  return {
    ...initialProps,
    html,
    emotionStyleTags: [...existingTags, ...movedStyleTags],
  };
};
