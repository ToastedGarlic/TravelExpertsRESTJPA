// Define the RESTful web service resource for managing booking details
package com.example.travelexpertsrestjpa;

import com.google.gson.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import model.Bookingdetail;
import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.util.List;

@Path("/bookingdetail")
public class BookingDetailsResource {

    // Gson instance with custom deserializer for handling Timestamp
    private static final Gson gson = new GsonBuilder()
            .registerTypeAdapter(Timestamp.class, new JsonDeserializer<Timestamp>() {
                @Override
                public Timestamp deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
                    String dateTimeString = json.getAsJsonPrimitive().getAsString();
                    try {
                        return Timestamp.valueOf(dateTimeString);
                    } catch (Exception e) {
                        throw new JsonParseException("Unparseable date: \"" + dateTimeString + "\". Supported format: yyyy-MM-dd'T'HH:mm:ss");
                    }
                }
            }).create();


    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getallbookingdetails")
    public String getAllBookingDetails() {
        // Retrieve all booking details from the database and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Query query = em.createQuery("SELECT b FROM Bookingdetail b");
        List<Bookingdetail> details = query.getResultList();
        em.close();
        return gson.toJson(details);
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getbookingdetail/{bookingDetailId}")
    public String getBookingDetail(@PathParam("bookingDetailId") int bookingDetailId) {
        // Retrieve a specific booking detail based on the provided ID and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Bookingdetail detail = em.find(Bookingdetail.class, bookingDetailId);
        em.close();
        return gson.toJson(detail);
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("addbookingdetail")
    public String addBookingDetail(String jsonString) {
        // Create a new booking detail based on the provided JSON data and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Bookingdetail detail = gson.fromJson(jsonString, Bookingdetail.class);
        em.getTransaction().begin();
        em.persist(detail);
        em.getTransaction().commit();
        em.close();
        return gson.toJson(detail);
    }

    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("updatebookingdetail/{bookingDetailId}")
    public String updateBookingDetail(@PathParam("bookingDetailId") int bookingDetailId, String jsonString) {
        // Update an existing booking detail with the provided JSON data and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Bookingdetail detail = gson.fromJson(jsonString, Bookingdetail.class);
        detail.setId(bookingDetailId);
        em.getTransaction().begin();
        em.merge(detail);
        em.getTransaction().commit();
        em.close();
        return gson.toJson(detail);
    }

    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    @Path("deletebookingdetail/{bookingDetailId}")
    public String deleteBookingDetail(@PathParam("bookingDetailId") int bookingDetailId) {
        // Delete an existing booking detail based on the provided ID and return a success or not found message
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        Bookingdetail detail = em.find(Bookingdetail.class, bookingDetailId);
        if (detail != null) {
            em.getTransaction().begin();
            em.remove(detail);
            em.getTransaction().commit();
            em.close();
            return "{\"message\":\"Booking Detail deleted successfully\"}";
        } else {
            em.close();
            return "{\"message\":\"Booking Detail not found\"}";
        }
    }
}
