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
      <template v-for="ticket in props.tickets">
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
import { ref, reactive, watch } from 'vue'
import { useQuery, useMutation, provideApolloClient } from '@vue/apollo-composable'
import gql from 'graphql-tag'
import { useTicketStore } from '../../stores/tickets'
import { useRepresentativeStore } from '../../stores/representatives'
import { storeToRefs } from 'pinia'

const store = useTicketStore()
const representativeStore = useRepresentativeStore()
const { ticketsClosed } = storeToRefs(store)
const { userId } = storeToRefs(representativeStore)
const { closeUserTicket } = store

const props = defineProps({
    tickets: Array,
    required: true
})

function close(ticketId) {
    closeUserTicket(ticketId)
}

// watch(ticketsClosed, (value) => {
//     tickets.value = props.tickets.map((ticket) => {
//         if (ticket.id !== value.id){ return ticket }
//         return value
//     })
// })
</script>