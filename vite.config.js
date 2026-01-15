import { defineConfig } from 'vite';
import injectHTML from 'vite-plugin-html-inject';
import { viteStaticCopy } from 'vite-plugin-static-copy';
import { resolve } from 'path';
import { readdirSync, lstatSync } from 'fs';

// Helper to find all HTML files in the directory recursively
function getHtmlEntries(dir, entries = {}) {
  const files = readdirSync(dir);

  files.forEach(file => {
    const filePath = resolve(dir, file);
    if (lstatSync(filePath).isDirectory()) {
      if (file !== 'node_modules' && file !== 'dist' && file !== 'src') {
        getHtmlEntries(filePath, entries);
      }
    } else if (file.endsWith('.html')) {
      const name = filePath
        .replace(resolve(__dirname), '')
        .replace(/\\/g, '/')
        .replace(/^\//, '')
        .replace(/\.html$/, '');
      entries[name] = filePath;
    }
  });

  return entries;
}

export default defineConfig({
  plugins: [
    injectHTML(),
    viteStaticCopy({
      targets: readdirSync(__dirname)
        .filter(f => f.startsWith('sira_') && lstatSync(resolve(__dirname, f)).isDirectory())
        .map(folder => ({
          src: `${folder}/*.png`,
          dest: folder
        }))
    })
  ],
  build: {
    rollupOptions: {
      input: getHtmlEntries(__dirname)
    }
  },
  server: {
    port: 3000,
    open: true
  }
});
