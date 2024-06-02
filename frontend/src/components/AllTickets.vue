<template>
<div class="overflow-x-auto text-black mt-14">
  <table class="table">
    <thead>
      <tr class="text-black">
        <th>Atendente</th>
        <th>Ticket</th>
        <th>Status</th>
        <th></th>
        <th></th>
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
          <button class="btn btn-ghost btn-xs" v-if="!ticket.representative">Assinalar</button>
          <span class=" btn-xs text-gray-500" v-else>Assinalar</span>
        </th>
        <th>
          <button class="btn btn-ghost btn-xs" v-if="ticket.status === 'open'">Fechar</button>
        </th>
        <th>
            <button class="btn btn-circle btn-outline">
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
        <th></th>
      </tr>
    </tfoot>
    
  </table>
</div>
</template>

<script setup>
const props = defineProps({
    tickets: Array,
    required: true
})
</script>