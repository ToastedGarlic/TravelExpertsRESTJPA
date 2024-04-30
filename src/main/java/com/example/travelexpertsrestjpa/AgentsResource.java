// Define the RESTful web service resource for managing agents
package com.example.travelexpertsrestjpa;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import model.Agent;
import java.lang.reflect.Type;
import java.util.List;

@Path("/agent")
public class AgentsResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getallagents")
    public String getAllAgents() {
        // Retrieve all agents from the database and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("SELECT a FROM Agent a");
        List<Agent> agents = query.getResultList();
        Gson gson = new Gson();
        Type type = new TypeToken<List<Agent>>(){}.getType();
        em.close();
        return gson.toJson(agents, type);
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getagent/{agentId}")
    public String getAgent(@PathParam("agentId") int agentId) {
        // Retrieve a specific agent based on the provided agent ID and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Agent agent = em.find(Agent.class, agentId);
        Gson gson = new Gson();
        em.close();
        return gson.toJson(agent);
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("postagent")
    public String postAgent(String jsonString) {
        // Create a new agent based on the provided JSON data and return a success message
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Gson gson = new Gson();
        Agent agent = gson.fromJson(jsonString, Agent.class);
        em.getTransaction().begin();
        em.persist(agent);
        em.getTransaction().commit();
        em.close();
        return "{ 'message':'Agent created successfully' }";
    }

    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("updateagent/{agentId}")
    public String updateAgent(@PathParam("agentId") int agentId, String jsonString) {
        // Update an existing agent with the provided JSON data and return a success message
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Gson gson = new Gson();
        Agent agent = gson.fromJson(jsonString, Agent.class);
        agent.setAgentId(agentId); // Ensure correct ID is set
        em.getTransaction().begin();
        em.merge(agent);
        em.getTransaction().commit();
        em.close();
        return "{ 'message':'Agent updated successfully' }";
    }

    @DELETE
    @Path("deleteagent/{agentId}")
    @Produces(MediaType.APPLICATION_JSON)
    public String deleteAgent(@PathParam("agentId") int agentId) {
        // Delete an existing agent based on the provided agent ID and return a success or not found message
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Agent agent = em.find(Agent.class, agentId);
        if (agent != null) {
            em.getTransaction().begin();
            em.remove(agent);
            em.getTransaction().commit();
            em.close();
            return "{ 'message':'Agent deleted successfully' }";
        } else {
            em.close();
            return "{ 'message':'Agent not found' }";
        }
    }
}
