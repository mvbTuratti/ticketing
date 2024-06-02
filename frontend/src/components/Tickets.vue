<template>

<div class="stats shadow">
  
  <div class="stat">
    <div class="stat-figure text-primary">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-8 h-8 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
    </div>
    <div class="stat-title">Tickets Assinalados</div>
    <div class="stat-value text-primary">{{ data.open }}</div>
    <div class="stat-desc">Assinalados ao usuario</div>
  </div>
  
  <div class="stat">
    <div class="stat-figure text-secondary">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-8 h-8 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
    </div>
    <div class="stat-title">Total de Tickets</div>
    <div class="stat-value text-secondary">{{ data.total }}</div>
    <div class="stat-desc">Tickets abertos ou fechados</div>
  </div>
  
  <div class="stat">
    <div class="stat-figure text-secondary">
    </div>
    <div class="stat-value">{{ data.percentage }}%</div>
    <div class="stat-title">Tickets feitos</div>
    <div class="stat-desc text-secondary">{{ data.open }} tickets em aberto</div>
  </div>
  
</div> 
<div class="form-control">
    <label class="label cursor-pointer">
        <span class="label-text text-black pr-4 ">{{ checked ? `Meus` : `Todos` }}</span> 
        <input type="checkbox" class="toggle checked:bg-green-600" checked @click="checked = !checked"/>
    </label>
</div>

<AllTickets :tickets="allTickets" v-if="!checked"></AllTickets>
<UserTickets v-else></UserTickets>
</template>

<script setup>
import { ref, reactive, watch, computed } from 'vue'
import { useQuery } from '@vue/apollo-composable'
import AllTickets from './AllTickets.vue'
import UserTickets from './UserTickets.vue'
import gql from 'graphql-tag'

const checked = ref(true)
const data = ref({open: 0, total: 0, percentage: 0})
const allTickets = ref([])

watch(checked, (newValue, oldValue) => {
    if (!newValue){
        refetch()
    }
})

const { result, loading, error, refetch } = useQuery(gql`
    query ListTickets {
        listAllTickets(limit: 250) {
            results {
                id
                subject
                status
                representative {
                    id
                    name
                }
            }
        }
    }
`)
watch(result, value => {
    allTickets.value = value.listAllTickets?.results ?? []
    console.log(allTickets.value.length)
    data.value.total = allTickets.value.length
})

</script>