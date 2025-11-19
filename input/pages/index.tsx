// pages/index.tsx
import * as React from 'react';
import {
  AppBar,
  Toolbar,
  Typography,
  Container,
  Button,
  Box,
  Paper,
} from '@mui/material';

export default function HomePage() {
  return (
    <>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" component="div">
            Demo App
          </Typography>
        </Toolbar>
      </AppBar>

      <Container maxWidth="md">
        <Box mt={4}>
          <Paper elevation={3} sx={{ p: 4 }}>
            <Typography variant="h4" gutterBottom>
              Welcome to MUI + Next.js
            </Typography>
            <Typography variant="body1" paragraph>
              This page is used to reproduce an SSR styling issue.
            </Typography>
            <Button variant="contained" color="primary" sx={{ mr: 2 }}>
              Primary Button
            </Button>
            <Button variant="outlined" color="primary">
              Outlined Button
            </Button>
          </Paper>
        </Box>
      </Container>
    </>
  );
}
