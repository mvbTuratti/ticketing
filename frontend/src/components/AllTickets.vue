<template>
<div class="overflow-x-auto text-black mt-14">
  <dialog id="ticketModal" class="modal">
    <div class="modal-box bg-gray-300">
      <form method="dialog">
        <button id="closeModal" class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2">✕</button>
      </form>
      <h3 class="font-bold text-lg">Hello!</h3>
      <ul class="max-h-96 overflow-y-scroll">
        <template v-for="representative in representativeOptions.representatives" class="mt-8">
          <li @click="() => assingUser(representativeOptions.user, representative.id)" class="p-2 border-2 border-black rounded-md my-1 w-5/6 hover:bg-slate-100"><a>{{ representative.name }}</a></li>
        </template>
      </ul>
    </div>
  </dialog>
  <table class="table">
    <thead>
      <tr class="text-black">
        <th>Atendente</th>
        <th>Ticket</th>
        <th>Status</th>
        <th></th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <!-- row 1 -->
      <template v-for="ticket in props.tickets">
      <tr :id="ticket.id">
        <td :userid="ticket.representative ? ticket.representative.id : ''">
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
          <button class="btn" @click="() => showModal(ticket.id)" v-if="!ticket.representative">Assinalar</button>
          <span class=" btn-xs text-gray-500" v-if="ticket.representative">Assinalar</span>
        </th>
        <th>
            <button class="btn btn-circle btn-outline" @click="() => deleteEntry(ticket.id)">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
            </button>
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
        <th></th>
      </tr>
    </tfoot>
    
  </table>
</div>
</template>

<script setup>
import { computed, ref, reactive } from 'vue'
import { useTicketStore } from '../../stores/tickets'
import { useRepresentativeStore } from '../../stores/representatives'


const store = useTicketStore()
const representativeStore = useRepresentativeStore()
const { representativesData } = representativeStore
const { deleteTicket, assignTicket } = store

const representativeOptions = reactive({user: ref(""), representatives: representativesData})

const props = defineProps({
    tickets: Array,
    required: true
})

function deleteEntry(ticketId) {
  deleteTicket(ticketId)
}

function assingUser(ticketId, userId) {
  assignTicket(ticketId, userId)
  document.getElementById("closeModal").click()
}

function showModal(ticketId) {
  representativeOptions.user = ticketId
  document.getElementById("ticketModal").showModal()
}

</script>