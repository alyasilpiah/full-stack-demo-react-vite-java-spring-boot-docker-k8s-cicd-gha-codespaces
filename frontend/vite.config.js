import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

const getApiProxyTarget = () => {
  const apiUrl = process.env.VITE_API_URL
  if (!apiUrl?.startsWith('http')) {
    return 'http://localhost:8080'
  }
  const url = new URL(apiUrl)
  const segments = url.pathname.split('/').filter(Boolean)
  if (segments[segments.length - 1] === 'api') {
    segments.pop()
    url.pathname = `/${segments.join('/')}`
  }
  return `${url.origin}${url.pathname === '/' ? '' : url.pathname}`
}

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: true,
    port: 5173,
    strictPort: true,
    proxy: {
      '/api': {
        target: getApiProxyTarget(),
        changeOrigin: true,
        secure: false,
      }
    }
  }
})
