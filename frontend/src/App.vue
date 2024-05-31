<template class="text-black ">
  <main>
    <RouterView />
  </main>
</template>

<style scoped>
</style>

<script setup>
import { onMounted } from 'vue'
import { useRepresentativeStore } from '../stores/representatives'

const store = useRepresentativeStore()
const { fetchRepresentatives } = store
onMounted(() => {
  const r = fetchRepresentatives()
})

</script>
