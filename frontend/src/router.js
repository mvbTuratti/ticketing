import { createMemoryHistory, createRouter } from 'vue-router'

import SignIn from './components/SignIn.vue'
import Representative from './components/Representative.vue'

const routes = [
  { path: '/', component: SignIn },
  { path: '/representative/:name', component: Representative },
]

const router = createRouter({
  history: createMemoryHistory(),
  routes,
})

export default router