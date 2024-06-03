<template>

<div class="stats shadow">
  
  <div class="stat">
    <div class="stat-figure text-primary">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-8 h-8 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
    </div>
    <div class="stat-title">Tickets Assinalados</div>
    <div class="stat-value text-primary">{{ assignedTasks }}</div>
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
    <div class="stat-value">{{ completedTasksByUser }}%</div>
    <div class="stat-title">Tickets feitos</div>
    <div class="stat-desc text-secondary">{{ openAssignedTasks }} tickets em aberto</div>
  </div>
  
</div> 
<div class="flex mt-2">
    <div class="form-control">
        <label class="label cursor-pointer">
            <span class="label-text text-black pr-4 ">{{ !checked ? `Meus` : `Todos` }}</span> 
            <input type="checkbox" class="toggle checked:bg-green-600" checked @click="checked = !checked"/>
        </label>
    </div>
    <div class="pl-4 mt-1 text-white">
        <button class="btn btn-sm" onclick="my_modal_5.showModal()">Criar Ticket</button>
        <dialog id="my_modal_5" class="modal modal-bottom sm:modal-middle">
        <div class="modal-box">
            <h3 class="font-bold text-lg">Crie um ticket:</h3>
            <p class="py-4">Digite o motivo do ticket</p>
            <input type="text" v-model="novoTicket" placeholder="Digite aqui" class="input input-bordered w-full max-w-xs" :class="novoTicket ? `` : `input-error`" />
            <div class="modal-action">
            <form method="dialog">
                <button class="btn btn-active btn-primary mr-6" v-if="novoTicket" @click="createTicketFunction">Criar Ticket</button>
                <button class="btn">Close</button>
            </form>
            </div>
        </div>
        </dialog>
    </div>
</div>
<AllTickets :tickets="allTickets" v-if="checked"></AllTickets>
<UserTickets :tickets="taskAssignedToUser" v-else></UserTickets>
</template>

<script setup>
import { ref, reactive, watch, computed } from 'vue'
import { useQuery, useMutation, provideApolloClient } from '@vue/apollo-composable'
import gql from 'graphql-tag'
import AllTickets from './AllTickets.vue'
import UserTickets from './UserTickets.vue'
import { storeToRefs } from 'pinia'
import { useRepresentativeStore } from '../../stores/representatives'

const store = useRepresentativeStore()
const { userId, representativesData } = storeToRefs(store)

const checked = ref(true)
const data = ref({total: 0})
const allTickets = ref([])
const novoTicket = ref("")

watch(checked, (newValue, oldValue) => {
    if (!newValue){
        refetch()
    }
})
const assignedTasks = computed(() => {
    return allTickets.value.filter((ticket) => ticket.representative?.id === userId.value).length
})

const openAssignedTasks = computed(() => {
    return allTickets.value.filter((ticket) => ticket.representative?.id === userId.value && ticket.status === 'open').length
})
const completedTasksByUser = computed(() => {
    let completed = allTickets.value.filter((ticket) => ticket.representative?.id === userId.value && ticket.status === 'closed').length
    return Math.floor(completed / assignedTasks.value) * 100;
})

const taskAssignedToUser = computed(() => {
    return allTickets.value.filter((ticket) => ticket.representative?.id === userId.value)
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
    data.value.total = allTickets.value.length
})



function createTicketFunction() {
    createSimpleTicket().then((r) => {
        const item = r.data.createTicket?.result ?? null
        if (item){
            allTickets.value = [...allTickets.value, item]
            data.value.total = allTickets.value.length
        }
    }).catch(err => { console.log(err)})
}

const { mutate: createSimpleTicket } = useMutation(gql`
    mutation CreateTicket($text: String!) {
        createTicket(input: { subject: $text }) {
            result {
                id
                representative {
                    id
                    name
                }
                status
                subject
            }
        }
    }
`, () => ({
  variables: {
    text: novoTicket.value,
  },
}))
</script>