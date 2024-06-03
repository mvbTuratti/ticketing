<template>
 <div class="overflow-x-auto text-black mt-14">
  <table class="table">
    <thead>
      <tr class="text-black">
        <th>Atendente</th>
        <th>Ticket</th>
        <th>Status</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <!-- row 1 -->
      <template v-for="ticket in tickets">
      <tr>
        <td>
          <div class="flex items-center gap-3">
            <div>
              <div class="font-bold" :class="!ticket.representative && `font-light`">{{ ticket.representative?.name ?? `unassigned` }}</div>
            </div>
          </div>
        </td>
        <td>
          {{ ticket.subject }}
        </td>
        <td>{{ ticket.status }}</td>
        <th>
          <button class="btn btn-ghost btn-xs" @click="() => close(ticket.id)" v-if="ticket.status === 'open'">Fechar</button>
        </th>
      </tr>
        </template>
    </tbody>
    <!-- foot -->
    <tfoot>
      <tr class="text-black">
        <th>Atendente</th>
        <th>Ticket</th>
        <th>Status</th>
        <th></th>
      </tr>
    </tfoot>
    
  </table>
</div>
</template>

<script setup>
import { Socket as PhoenixSocket } from 'phoenix'
import { onUnmounted, ref, reactive, watch } from 'vue'
import { useQuery, useMutation, provideApolloClient } from '@vue/apollo-composable'
import gql from 'graphql-tag'
import { useTicketStore } from '../../stores/tickets'
import { storeToRefs } from 'pinia'

const store = useTicketStore()
const { ticketsClosed } = storeToRefs(store)
const { closeUserTicket } = store

const props = defineProps({
    tickets: Array,
    required: true
})
const tickets = ref(props.tickets)

const socket = new PhoenixSocket("/socket", {params: {token: window.userToken}})
socket.connect()
const channel = socket.channel("representative:some_id", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
onUnmounted(() => {
    channel.off("leaving")
    socket.disconnect()
})

function close(ticketId) {
    closeUserTicket(ticketId)
}

watch(ticketsClosed, (value) => {
    console.log(value)
    console.log(value.value)
    console.log(tickets)
    tickets.value = tickets.value.map((ticket) => {
        if (ticket.id !== value.id){ return ticket }
        return value
    })
    console.log(tickets)
})
</script>