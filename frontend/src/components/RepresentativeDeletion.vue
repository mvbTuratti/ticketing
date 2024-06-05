<template>
<div class="overflow-x-auto text-black mt-14">
  <table class="table">
    <thead>
      <tr class="text-black">
        <th>Representante</th>
        <th>ID</th>
        <th></th>
      </tr>
    </thead>
    <tbody>
      <!-- row 1 -->
      <template v-for="representative in representativesData">
      <tr :id="representative.id">
        <td>
          {{ representative.name }}
        </td>
        <th>
            <button class="btn btn-circle btn-outline" @click="() => deleteRepresentative(representative.id)">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
            </button>
        </th>
      </tr>
        </template>
    </tbody>
    <!-- foot -->
    <tfoot>
      <tr class="text-black">
        <th>Representante</th>
        <th>ID</th>
        <th></th>
      </tr>
    </tfoot>
    
  </table>
</div>
</template>

<script setup>
import { useRepresentativeStore } from '../../stores/representatives'
import { storeToRefs } from 'pinia'

const representativeStore = useRepresentativeStore()

const { representativesData } = storeToRefs(representativeStore)
const { deleteRepresentative } = representativeStore

</script>