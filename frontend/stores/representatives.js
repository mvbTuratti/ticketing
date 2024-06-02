import { defineStore } from 'pinia'
import { useQuery, useMutation } from '@vue/apollo-composable'
import gql from 'graphql-tag'
import { ref, computed, watch, reactive } from 'vue'


export const useRepresentativeStore = defineStore('representatives', () => {
    const _state = reactive({"value": {"listRepresentatives": {"results": ref([])}}})
    const userId = ref("")
    const names = computed(() => {
        return _state.value.listRepresentatives.results.map((entry) => {
            return entry.name
        })
    })
    const representativesData = computed(() => _state.value.listRepresentatives.results)
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
            const id = response.data.addRepresentative?.result.id
            if (id){
                userId.value = id
                _state.value.listRepresentatives.results.push(response.data.addRepresentative.result)
            }
        }).catch((err) => {
            console.log(err)
        })
        
    }
    function isUserAvailable(userName) {
        return names.value.includes(userName)
    }
    return { names, representativesData, _state, userId, fetchRepresentatives, isUserAvailable, createRepresentative }
  })