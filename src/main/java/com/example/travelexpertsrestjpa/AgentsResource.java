//created by mohsen

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

    // Retrieve all agents from the database and return as JSON
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getallagents")
    public String getAllAgents() {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("SELECT a FROM Agent a");
        List<Agent> agents = query.getResultList();
        Gson gson = new Gson();
        Type type = new TypeToken<List<Agent>>(){}.getType();
        em.close();
        return gson.toJson(agents, type);
    }

    // Retrieve a specific agent based on the provided agent ID and return as JSON
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getagent/{agentId}")
    public String getAgent(@PathParam("agentId") int agentId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Agent agent = em.find(Agent.class, agentId);
        Gson gson = new Gson();
        em.close();
        return gson.toJson(agent);
    }

    // Create a new agent based on the provided JSON data
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("createagent")
    public String createAgent(String jsonString) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Gson gson = new Gson();
        Agent agent = gson.fromJson(jsonString, Agent.class);
        em.getTransaction().begin();
        em.persist(agent);
        em.getTransaction().commit();
        em.close();
        return gson.toJson("{ 'message':'Agent created successfully' }");
    }

    // Update an existing agent based on the provided agent ID and JSON data
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("updateagent/{agentId}")
    public String updateAgent(@PathParam("agentId") int agentId, String jsonString) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Gson gson = new Gson();
        Agent agent = gson.fromJson(jsonString, Agent.class);
        agent.setAgentId(agentId);  // Ensure correct ID is set
        em.getTransaction().begin();
        em.merge(agent);
        em.getTransaction().commit();
        em.close();
        return gson.toJson("{ 'message':'Agent updated successfully' }");
    }

    // Delete an agent based on the provided agent ID
    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    @Path("deleteagent/{agentId}")
    public String deleteAgent(@PathParam("agentId") int agentId) {
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
