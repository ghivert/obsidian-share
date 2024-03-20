import * as path from 'path'
import gleam from 'vite-gleam'

const childProcess = path.resolve(process.cwd(), './src/polyfills/child_process.js')
const fs = path.resolve(process.cwd(), './src/polyfills/fs.js')

export default {
  resolve: {
    alias: [
      { find: 'node:child_process', replacement: childProcess },
      { find: 'node:fs', replacement: fs },
    ],
  },
  plugins: [gleam()],
}
