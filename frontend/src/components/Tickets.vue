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
    <div class="stat-value text-secondary">{{ totalTasks }}</div>
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
<AllTickets :tickets="tickets" v-if="checked" ></AllTickets>
<UserTickets :tickets="taskAssignedToUser" v-else></UserTickets>
</template>

<script setup>
import { ref, watch, computed } from 'vue'
import { useQuery, useMutation } from '@vue/apollo-composable'
import gql from 'graphql-tag'
import AllTickets from './AllTickets.vue'
import UserTickets from './UserTickets.vue'
import { storeToRefs } from 'pinia'
import { useRepresentativeStore } from '../../stores/representatives'
import { useTicketStore } from '../../stores/tickets'
import { Socket as PhoenixSocket } from 'phoenix'

const store = useRepresentativeStore()
const ticketStore = useTicketStore()
const { userId } = storeToRefs(store)

const { fetchTickets } = ticketStore
const { tickets } = storeToRefs(ticketStore)


const checked = ref(true)
const novoTicket = ref("")

const assignedTasks = computed(() => {
    return tickets.value.filter((ticket) => ticket.representative?.id === userId.value).length
})

const totalTasks = computed(() => {
    return tickets.value.length
})

const openAssignedTasks = computed(() => {
    return tickets.value.filter((ticket) => ticket.representative?.id === userId.value && ticket.status === 'open').length
})
const completedTasksByUser = computed(() => {
    let completed = tickets.value.filter((ticket) => ticket.representative?.id === userId.value && ticket.status === 'closed').length
    return Math.floor((completed / assignedTasks.value) * 100 ) || 0;
})

const taskAssignedToUser = computed(() => {
    return tickets.value.filter((ticket) => ticket.representative?.id === userId.value)
})


function createTicketFunction() {
    createSimpleTicket().then((r) => {
        //
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


const socket = new PhoenixSocket("/socket", {params: {token: window.userToken}})
socket.connect()
const channel = socket.channel(`tickets:updates`, {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("assigned", payload => {
    tickets.value = tickets.value.map(ticket => ticket.id === payload.id ? payload : ticket)
})

channel.on("created", payload => {
    tickets.value = [ ...tickets.value, payload ]
})

channel.on("deleted", payload => {
    tickets.value = tickets.value.filter((ticket) => ticket.id !== payload.id)
})

fetchTickets()


</script>