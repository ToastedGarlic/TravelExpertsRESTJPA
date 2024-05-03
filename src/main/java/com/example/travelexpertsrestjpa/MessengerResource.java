package com.example.travelexpertsrestjpa;

import com.google.gson.Gson;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import model.Customer;
import model.MessageM;

import java.util.List;

//http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/message/getallmessages
// Retrieve selected customer details and return as JSON
@Path("/message")
public class MessengerResource {
    @GET
    @Path("getallmessages/{ customerId }")
    @Produces(MediaType.APPLICATION_JSON)
    public String getAllMessages(@PathParam("customerId") int customerId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("SELECT m FROM MessageM m WHERE m.customerId = " + customerId, MessageM.class);

        List<MessageM> messages = query.getResultList();
        Gson gson = new Gson();

        return gson.toJson(messages);
    }

    @GET
    @Path("new")
    @Produces(MediaType.APPLICATION_JSON)
    public String getAllMessages(@PathParam("customerId") int customerId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("SELECT m FROM MessageM m WHERE m.customerId = " + customerId, MessageM.class);

        List<MessageM> messages = query.getResultList();
        Gson gson = new Gson();

        return gson.toJson(messages);
    }

    // Update or insert a customer based on the provided JSON data and return a status message
    @POST
    @Path("postcustomer")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public String postCustomer(String jsonString)  {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Gson gson = new Gson();
        Customer customer = gson.fromJson(jsonString, Customer.class);
        em.getTransaction().begin();
        Customer savedCustomer = em.merge(customer);
        String message = null;
        if (savedCustomer != null)
        {
            em.getTransaction().commit();
            message = "{ \"message\": \"Customer updated successfully\" }";
        }
        else
        {
            em.getTransaction().rollback();
            message = "{ \"message\": \"Customer update failed\" }";
        }
        em.close();

        return message;
    }

}
