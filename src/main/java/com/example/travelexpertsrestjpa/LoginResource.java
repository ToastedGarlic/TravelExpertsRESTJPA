package com.example.travelexpertsrestjpa;

import com.google.gson.Gson;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import model.Booking;
import model.Customer;

import java.util.List;
//http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/getallcustomers
// Retrieve selected customer details and return as JSON

//all code by jack
//get customer information if username and password submitted matched
@Path("/login")
public class LoginResource {
    // http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/login/getcustomer/enisonl/password
    @GET
    @Path("getcustomer/{ username }/{ password }")
    @Produces(MediaType.APPLICATION_JSON)
    public String getCustomer(@PathParam("username") String username, @PathParam("password") String password)  {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("SELECT c FROM Customer c WHERE c.username = '" + username + "' AND c.password = '" + password + "'");
        List<Customer> customer = query.getResultList();
        Gson gson = new Gson();

        return gson.toJson(customer);
    }

    // get specific customer booking detail by customerId
    @GET
    @Path("customerbooking/{ customerid }/")
    @Produces(MediaType.APPLICATION_JSON)
    public String getCustomer(@PathParam("customerid") int customerId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("SELECT b FROM Booking b WHERE b.customerId = '" + customerId + "'");
        List<Booking> booking = query.getResultList();
        Gson gson = new Gson();

        return gson.toJson(booking);
    }

}