import { createApp, provide, h } from 'vue'
import { ApolloClients } from '@vue/apollo-composable'
import { apolloClient, apolloClientTickets } from './apollo'
import { createPinia } from 'pinia'
import './output.css'
import router from './router'
import App from './App.vue'

const pinia = createPinia()

createApp({
    setup () {
        provide(ApolloClients, {
          default: apolloClient,
          tickets: apolloClientTickets,
        })
      },
    render: () => h(App),
}).use(router).use(pinia).mount('#app')
