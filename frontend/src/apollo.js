import { ApolloClient, createHttpLink, InMemoryCache } from '@apollo/client/core'


// HTTP connection to the API

const httpLink = createHttpLink({
  // You should use an absolute URL here
  uri: '/gql',
})



// Cache implementation
const cache = new InMemoryCache()

// Create the apollo client
const apolloClient = new ApolloClient({
  link: httpLink,
  cache,
})

const apolloClientTickets = new ApolloClient({
  link: httpLink,
  cache,
})

export { apolloClient , apolloClientTickets }