#!/usr/bin/env node
import { spawn } from 'node:child_process';
import { once } from 'node:events';
import { randomInt } from 'node:crypto';
import path from 'node:path';
import { promises as fs } from 'node:fs';

const nodeBin = process.execPath;
const nextCli = path.join(process.cwd(), 'node_modules', 'next', 'dist', 'bin', 'next');
const envBase = {
  ...process.env,
  NEXT_TELEMETRY_DISABLED: '1',
};

function spawnCommand(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      stdio: ['ignore', 'pipe', 'pipe'],
      env: envBase,
      ...options,
    });

    let stdout = '';
    let stderr = '';

    child.stdout.on('data', (chunk) => {
      stdout += chunk.toString();
    });

    child.stderr.on('data', (chunk) => {
      stderr += chunk.toString();
    });

    child.on('error', (err) => {
      reject(err);
    });

    child.on('close', (code) => {
      if (code === 0) {
        resolve({ stdout, stderr });
      } else {
        const error = new Error(
          `Command ${command} ${args.join(' ')} failed with exit code ${code}`
        );
        error.stdout = stdout;
        error.stderr = stderr;
        error.exitCode = code;
        reject(error);
      }
    });
  });
}

function startServer(dir, port) {
  const child = spawn(
    nodeBin,
    [nextCli, 'start', dir, '--port', String(port)],
    {
      env: envBase,
      stdio: ['ignore', 'pipe', 'pipe'],
    }
  );

  child.stdout.setEncoding('utf8');
  child.stderr.setEncoding('utf8');

  const logs = { stdout: '', stderr: '' };
  child.stdout.on('data', (chunk) => {
    logs.stdout += chunk;
  });
  child.stderr.on('data', (chunk) => {
    logs.stderr += chunk;
  });

  let exited = false;
  let exitCode = 0;
  child.on('exit', (code) => {
    exited = true;
    exitCode = code ?? 0;
  });

  const waitForReady = async () => {
    const start = Date.now();
    const deadline = start + 45000;
    while (Date.now() < deadline) {
      if (exited) {
        throw new Error(`next start (${dir}) exited early with code ${exitCode}`);
      }

      try {
        const response = await fetch(`http://127.0.0.1:${port}/`, {
          method: 'GET',
          headers: {
            accept: 'text/html',
          },
        });

        if (response.ok || response.status === 404) {
          return;
        }
      } catch (error) {
        // Server not ready yet; continue polling.
      }

      await new Promise((resolve) => setTimeout(resolve, 500));
    }

    throw new Error(`Timed out waiting for next start (${dir})`);
  };

  const dispose = async () => {
    if (!child.killed) {
      child.kill('SIGTERM');
    }
    try {
      await once(child, 'exit');
    } catch (error) {
      // ignore while cleaning up
    }
    return { ...logs };
  };

  return waitForReady()
    .then(() => ({
      logs,
      child,
      stop: dispose,
    }))
    .catch(async (error) => {
      await dispose();
      throw error;
    });
}

async function ensureBuild(dir) {
  await spawnCommand(nodeBin, [nextCli, 'build', dir], {
    env: {
      ...envBase,
      NEXT_DISABLE_ESLINT: '1',
      TSC_COMPILE_ON_ERROR: '1',
    },
  });
}

async function prepareProject(label, sourceDir) {
  const tempRoot = path.join(process.cwd(), '.tmp');
  await fs.mkdir(tempRoot, { recursive: true });
  const workDir = path.join(tempRoot, `${label}-${Date.now()}-${randomInt(1e6)}`);

  await fs.cp(sourceDir, workDir, {
    recursive: true,
    filter: (src) => {
      const relative = path.relative(sourceDir, src);
      if (!relative) {
        return true;
      }

      if (relative.startsWith('.next')) {
        return false;
      }

      return true;
    },
  });

  const configPath = path.join(workDir, 'next.config.js');
  const configContent = `module.exports = {\n  typescript: { ignoreBuildErrors: true },\n  eslint: { ignoreDuringBuilds: true }\n};\n`;
  await fs.writeFile(configPath, configContent, 'utf8');

  return workDir;
}

async function fetchHtml(port) {
  const response = await fetch(`http://127.0.0.1:${port}/`, {
    headers: {
      'user-agent': 'SSR-style-test/1.0',
      'cache-control': 'no-cache',
      pragma: 'no-cache',
      accept: 'text/html',
    },
  });

  if (!response.ok) {
    throw new Error(`Unexpected HTTP status ${response.status}`);
  }

  return response.text();
}

function analyzeHtml(html) {
  const [headHtml = '', bodyHtml = ''] = html.split('<div id="__next"');
  const emotionRegex = /<style[^>]+data-emotion="([^"]+)"/g;
  const headMatches = [...headHtml.matchAll(emotionRegex)];
  const bodyMatches = [...bodyHtml.matchAll(emotionRegex)];
  const allMatches = [...headMatches, ...bodyMatches];
  const headHasEmotionStyles = headMatches.length > 0;
  const bodyHasEmotionStyles = bodyMatches.length > 0;
  const expectedPrefixes = ['mui', 'css'];
  const headHasExpectedEmotionChunk = headMatches.some((match) =>
    expectedPrefixes.some((prefix) => match[1]?.startsWith(prefix))
  );
  const allHasExpectedEmotionChunk = allMatches.some((match) =>
    expectedPrefixes.some((prefix) => match[1]?.startsWith(prefix))
  );
  const insertionIndex = headHtml.indexOf('name="emotion-insertion-point"');
  const firstHeadStyleIndex = headHtml.indexOf('data-emotion="');
  const insertionPrecedesStyles =
    insertionIndex !== -1 && firstHeadStyleIndex !== -1 && insertionIndex < firstHeadStyleIndex;
  const hasEmotionRule = /\.css-[a-z0-9_-]+/.test(html);

  return {
    headHasEmotionStyles,
    bodyHasEmotionStyles,
    headEmotionStyleCount: headMatches.length,
    bodyEmotionStyleCount: bodyMatches.length,
    headHasExpectedEmotionChunk,
    allHasExpectedEmotionChunk,
    insertionPrecedesStyles,
    hasEmotionRule,
  };
}

async function runScenario(label, dir) {
  const sourceDir = path.join(process.cwd(), dir);
  const workDir = await prepareProject(label, sourceDir);
  const port = 4100 + randomInt(1000);
  try {
    await ensureBuild(workDir);
    const server = await startServer(workDir, port);

    try {
      const html = await fetchHtml(port);
      const metrics = analyzeHtml(html);
      const logsSnapshot = await server.stop();

      return {
        label,
        html,
        logs: logsSnapshot,
        ...metrics,
      };
    } catch (error) {
      await server.stop();
      throw error;
    }
  } finally {
    await fs.rm(workDir, { recursive: true, force: true });
  }
}

(async () => {
  try {
    console.log('Running regression checks against the broken reproduction (input)...');
    const broken = await runScenario('broken', 'input');

    const brokenSignals = [];
    if (!broken.headHasEmotionStyles) {
      brokenSignals.push('No Emotion style tags detected inside <head>.');
    }
    if (!broken.headHasExpectedEmotionChunk) {
      brokenSignals.push('Emotion styles were missing the expected Emotion cache key prefix.');
    }
    if (broken.bodyHasEmotionStyles) {
      brokenSignals.push('Emotion styles were rendered inside the body subtree.');
    }

    if (brokenSignals.length === 0) {
      throw new Error(
        'Broken project passed all SSR style checks unexpectedly. The regression detector needs values that expose the bug.'
      );
    } else {
      brokenSignals.forEach((msg) => console.warn(`Expected broken behaviour observed: ${msg}`));
    }

    console.log('Running verification against the fixed implementation...');
    const fixed = await runScenario('fixed', 'fixed');

    const failures = [];
    if (!fixed.headHasEmotionStyles) {
      failures.push('Fixed project did not emit Emotion SSR style tags in <head>.');
    }

    if (!fixed.headHasExpectedEmotionChunk || !fixed.allHasExpectedEmotionChunk) {
      failures.push('Fixed project did not emit Emotion SSR tags with the expected cache key.');
    }

    if (fixed.bodyHasEmotionStyles) {
      failures.push('Fixed project rendered Emotion style tags inside the body subtree.');
    }

    if (!fixed.insertionPrecedesStyles) {
      failures.push('Emotion insertion point meta tag does not precede SSR style tags.');
    }

    if (!fixed.hasEmotionRule) {
      failures.push('SSR CSS does not contain Emotion-generated class rules.');
    }

    if (/Warning:\s/i.test(`${fixed.logs.stdout}\n${fixed.logs.stderr}`)) {
      failures.push('Hydration warnings detected in server output.');
    }

    if (/Warning:\s/i.test(`${broken.logs.stdout}\n${broken.logs.stderr}`)) {
      failures.push('Broken project emitted hydration warnings during SSR run.');
    }

    if (failures.length > 0) {
      failures.forEach((msg) => console.error(`- ${msg}`));
      process.exit(1);
    }

    console.log('SSR checks passed for the fixed project, and failures were detected for the broken build.');
  } catch (error) {
    if (error instanceof Error) {
      console.error(error.message);
      if (error.stdout) {
        console.error(error.stdout);
      }
      if (error.stderr) {
        console.error(error.stderr);
      }
    } else {
      console.error(error);
    }
    process.exit(1);
  }
})();
