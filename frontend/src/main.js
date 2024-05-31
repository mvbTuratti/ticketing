import { createApp, provide, h } from 'vue'
import { DefaultApolloClient } from '@vue/apollo-composable'
import apolloClient from './apollo'
import { createPinia } from 'pinia'
import './output.css'
import router from './router'
import App from './App.vue'

const pinia = createPinia()

createApp({
    setup () {
        provide(DefaultApolloClient, apolloClient)
      },
    render: () => h(App),
}).use(router).use(pinia).mount('#app')
