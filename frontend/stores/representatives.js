import { defineStore } from 'pinia'
import { useQuery, useMutation } from '@vue/apollo-composable'
import gql from 'graphql-tag'
import { ref, computed, watch, reactive } from 'vue'
import { apolloClient } from '../src/apollo'
import { provideApolloClient } from "@vue/apollo-composable";


export const useRepresentativeStore = defineStore('representatives', () => {
    const _state = reactive({"value": {"listRepresentatives": {"results": ref([])}}})
    const userId = ref("")
    const deletedUsers = ref([])
    const names = computed(() => {
        return _state.value.listRepresentatives.
            results.filter((entry) => !deletedUsers.value.includes(entry.id)).
            map((entry) => { return entry.name
        })
    })
    const representativesData = computed(() => _state.value.listRepresentatives.results.filter((entry) => !deletedUsers.value.includes(entry.id)))
    function fetchRepresentatives() {
        const { result } = useQuery(gql`
            query ListRepresentatives {
                listRepresentatives {
                    results {
                        id
                        name
                    }
                }
            }
            `)
        watch(result, value => {
            this._state.value = value
        })
    }
    function createRepresentative(name) {
        const { mutate: createUser } = useMutation(gql`
            mutation AddRepresentative {
                addRepresentative(input: { name: "${name}" }) {
                    result {
                        id
                        name
                    }
                    errors {
                        code
                        fields
                        message
                        shortMessage
                        vars
                    }
                }
            }
            `)
        createUser().then((response) => {
            console.log("create user", response)
            const id = response.data.addRepresentative?.result.id
            if (id){
                userId.value = id
                _state.value.listRepresentatives.results.push(response.data.addRepresentative.result)
            }
        }).catch((err) => {
            console.log(err)
        })
        
    }
    function deleteRepresentative(representativeId){
        const query = provideApolloClient(apolloClient)(() => useMutation(gql`
            mutation RemoveRepresentative {
                removeRepresentative(id: "${representativeId}") {
                    result {
                        id
                    }
                }
            }
        `))
        query.mutate()
        query.onDone((r) =>{
            console.log("deleted",  r)
            deletedUsers.value = [...deletedUsers.value, r.data.removeRepresentative.result.id]
        })
    }
    function assingUserId(userName){
        userId.value = representativesData.value.find((item) => item.name === userName).id
    }
    function isUserAvailable(userName) {
        return names.value.includes(userName)
    }
    return { names, representativesData, _state, userId, assingUserId, fetchRepresentatives, isUserAvailable, createRepresentative, deleteRepresentative }
  })