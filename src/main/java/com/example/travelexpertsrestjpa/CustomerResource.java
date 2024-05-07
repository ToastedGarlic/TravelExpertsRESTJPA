//created by mohsen
package com.example.travelexpertsrestjpa;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import model.Customer;
import java.util.List;

// RESTful web service resource for managing customers
@Path("/customer")
public class CustomerResource {

    // Retrieve all customers and return as JSON
    @GET
    @Path("getallcustomers")
    @Produces(MediaType.APPLICATION_JSON)
    public String getAllCustomers() {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("SELECT c FROM Customer c");
        List<Customer> customers = query.getResultList();
        Gson gson = new Gson();
        return gson.toJson(customers);
    }

    // Retrieve selected customer details and return as JSON
    @GET
    @Path("getallselectcustomers")
    @Produces(MediaType.APPLICATION_JSON)
    public String getAllSelectCustomers() {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("SELECT c FROM Customer c");
        List<Customer> customers = query.getResultList();
        JsonArray jsonArray  = new JsonArray();
        for (Customer customer : customers) {
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("customerId", customer.getCustomerId());
            jsonObject.addProperty("custFirstName", customer.getCustFirstName());
            jsonObject.addProperty("custLastName", customer.getCustLastName());
            jsonArray.add(jsonObject);
        }
        return jsonArray.toString();
    }

    // Retrieve a specific customer based on the provided ID and return as JSON
    @GET
    @Path("getcustomer2/{customerId}")
    @Produces(MediaType.APPLICATION_JSON)
    public String getCustomer2(@PathParam("customerId") int customerId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            Customer customer = em.find(Customer.class, customerId);
            Gson gson = new Gson();
            return gson.toJson(customer);
        } finally {
            em.close();
        }
    }

    // Retrieve a specific customer based on the provided ID and return as JSON
    @GET
    @Path("getcustomer/{customerId}")
    @Produces(MediaType.APPLICATION_JSON)
    public String getCustomer(@PathParam("customerId") int customerId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            Customer customer = em.find(Customer.class, customerId);
            Gson gson = new Gson();
            return gson.toJson(customer);
        } finally {
            em.close();
        }
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

    // Insert a new customer based on the provided JSON data and return a status message
    @PUT
    @Path("putcustomer")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public String putCustomer(String jsonString)  {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("select c from Customer c");
        List<Customer> list = query.getResultList();
        int listSize = list.size();
        Gson gson = new Gson();
        Customer customer = gson.fromJson(jsonString, Customer.class);
        em.getTransaction().begin();
        em.persist(customer);
        query = em.createQuery("select c from Customer c");
        List<Customer> newList = query.getResultList();
        int newListSize = newList.size();
        String message = null;
        if (newListSize > listSize)
        {
            em.getTransaction().commit();
            message = "{ \"message\": \"Customer inserted successfully\" }";
        }
        else
        {
            em.getTransaction().rollback();
            message = "{ \"message\": \"Customer insert failed\" }";
        }
        em.close();
        return message;
    }

    // Delete a customer based on the provided ID and return a status message
    @DELETE
    @Path("deletecustomer/{customerId}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public String deleteCustomer(@PathParam("customerId") int customerId)  {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Customer customer = em.find(Customer.class, customerId);
        em.getTransaction().begin();
        em.remove(customer);
        String message = null;
        if (!em.contains(customer))
        {
            em.getTransaction().commit();
            message = "{ \"message\": \"Customer deleted successfully\" }";
        }
        else
        {
            em.getTransaction().rollback();
            message = "{ \"message\": \"Customer delete failed\" }";
        }
        em.close();
        return message;
    }

    // Register a new customer and return a status message
    @POST
    @Path("/register")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response registerCustomer(String customerJson) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            Customer customer = new Gson().fromJson(customerJson, Customer.class);
            em.persist(customer);
            em.getTransaction().commit();
            return Response.status(Response.Status.CREATED).entity(new Gson().toJson(customer)).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("{\"message\":\"Error during registration: " + e.getMessage() + "\"}").build();
        } finally {
            em.close();
        }
    }

    // Retrieve a specific customer based on the provided username and return as JSON
    @GET
    @Path("getcustomer/{username}")
    @Produces(MediaType.APPLICATION_JSON)
    public String getCustomer(@PathParam("username") String username)  {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Customer customer = em.find(Customer.class, username);
        Gson gson = new Gson();
        return gson.toJson(customer);
    }
}// http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/login/enisonl/password