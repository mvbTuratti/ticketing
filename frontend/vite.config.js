import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/gql': 'http://localhost:4000',
      '/socket': "ws://localhost:4000"
    },
  },
})
