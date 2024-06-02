<template>
    <div class="flex min-h-full flex-col justify-center px-6 py-12 lg:px-8">
        <div class="sm:mx-auto sm:w-full sm:max-w-sm">
            <img class="mx-auto h-10 w-auto" src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600" alt="Your Company">
            <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">Entre com seu nome</h2>
        </div>
        <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
            <div class="space-y-6">
            <div>
                <div class="mt-2 flex">
                <label class="input input-bordered flex items-center gap-2 bg-white text-black w-[80%]">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="w-4 h-4 opacity-70"><path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM12.735 14c.618 0 1.093-.561.872-1.139a6.002 6.002 0 0 0-11.215 0c-.22.578.254 1.139.872 1.139h9.47Z" /></svg>
                    <input id="name" v-model="userName" name="name" required type="text" placeholder="Nome" class="grow " />
                </label>
                <div class="dropdown dropdown-left w-[20%]">
                    <div tabindex="0" role="button" class="btn m-1 bg-inherit border-0 shadow-none hover:shadow-none hover:border-0 hover:bg-inherit hover:text-black">Personify</div>
                        <ul tabindex="0" class="dropdown-content z-[1] menu p-2 shadow bg-base-100 rounded-box w-52">
                            <li v-for="name in names">
                                <span @click="() => setName(name)">{{ name }}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div>
                <button :class="{'btn-disabled bg-slate-400': !userName, 'btn bg-indigo-600': userName }" 
                    @click="goToRepresentative" 
                    class="flex w-full justify-center rounded-md px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"> 
                    Sing in
                </button>
            </div>
        </div>
        </div>
    </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { ref } from 'vue'
import { useRepresentativeStore } from '../../stores/representatives'
import { storeToRefs } from 'pinia'


const userName = ref("")
const router = useRouter()
const store = useRepresentativeStore()
const { names, representativesData } = storeToRefs(store)


function goToRepresentative(){
    if (userName.value){
        router.push('/representative/' + userName.value)
    }
}

function setName(name) {
    userName.value = name
    const elem = document.activeElement
    if (elem) {
      elem?.blur();
    }
}
</script>