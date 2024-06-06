<template>
    <div class="text-black">
        <!-- Hi {{ $route.params.name }} -->
        <div class="drawer lg:drawer-open">
            <input id="my-drawer-2" type="checkbox" class="drawer-toggle" />
            <div class="drawer-content flex flex-col items-center justify-center mt-2 mb-2">
                <!-- Page content here -->
                <Tickets v-if="content"></Tickets>
                <RepresentativeDeletion v-else></RepresentativeDeletion>
                <label for="my-drawer-2" class="btn btn-primary drawer-button lg:hidden">Open drawer</label>
            
            </div> 
            <div class="drawer-side">
                <label for="my-drawer-2" aria-label="close sidebar" class="drawer-overlay"></label> 
                <ul class="menu p-4 w-80 min-h-full bg-base-200 text-base-content">
                <!-- Sidebar content here -->
                <li class="my-4 text-lg font-bold">Olá, {{ $route.params.name }}</li>
                <li><a @click="() => content = true">Tickets</a></li>
                <li><a @click="() => content = false">Representatives</a></li>
                </ul>
                
            </div>
        </div>
    </div>
</template>

<script setup>
import { useRoute, useRouter } from 'vue-router'
import { onMounted, ref } from 'vue';
import { useRepresentativeStore } from '../../stores/representatives'
import Tickets from "./Tickets.vue"
import { storeToRefs } from 'pinia'
import RepresentativeDeletion from './RepresentativeDeletion.vue';

const route = useRoute()
const router = useRouter()
const store = useRepresentativeStore()
const { isUserAvailable, createRepresentative, assingUserId } = store
const { representativesData, userId } = storeToRefs(store)

const content = ref(true)

const name = route.params.name
if (!name){ 
    router.back()
}

onMounted(() => {
    if (!isUserAvailable(name)){
        createRepresentative(name)
    } else {
        assingUserId(name)
    }
})


</script>