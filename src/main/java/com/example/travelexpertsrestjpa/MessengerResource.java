package com.example.travelexpertsrestjpa;

import com.google.gson.Gson;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
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


}
