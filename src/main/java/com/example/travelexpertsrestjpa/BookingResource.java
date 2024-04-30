// Define the RESTful web service resource for managing bookings
package com.example.travelexpertsrestjpa;

import com.google.gson.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import model.Booking;

import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.util.List;

@Path("/booking")
public class BookingResource {

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
            })
            .create();

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getallbookings")
    public Response getAllBookings() {
        // Retrieve all bookings from the database and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            Query query = em.createQuery("SELECT b FROM Booking b", Booking.class);
            List<Booking> bookings = query.getResultList();
            return Response.ok(gson.toJson(bookings)).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("{\"message\":\"Error retrieving bookings: " + e.getMessage() + "\"}").build();
        } finally {
            em.close();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getbooking/{bookingId}")
    public Response getBooking(@PathParam("bookingId") int bookingId) {
        // Retrieve a specific booking based on the provided ID and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            Booking booking = em.find(Booking.class, bookingId);
            if (booking != null) {
                return Response.ok(gson.toJson(booking)).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND).entity("{\"message\":\"Booking not found\"}").build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("{\"message\":\"Error retrieving booking: " + e.getMessage() + "\"}").build();
        } finally {
            em.close();
        }
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("postbooking")
    public String postBooking(String jsonString) {
        // Create a new booking based on the provided JSON data and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            Booking booking = gson.fromJson(jsonString, Booking.class);
            Booking savedBooking = em.merge(booking);
            em.getTransaction().commit();
            return gson.toJson(savedBooking);
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return "{\"message\":\"Error processing booking: " + e.getMessage() + "\"}";
        } finally {
            em.close();
        }
    }

    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("putbooking")
    public String putBooking(String jsonString) {
        // Insert a new booking based on the provided JSON data and return as JSON
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            Booking booking = gson.fromJson(jsonString, Booking.class);
            em.persist(booking);
            em.getTransaction().commit();
            return gson.toJson(booking);
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return "{\"message\":\"Error inserting booking: " + e.getMessage() + "\"}";
        } finally {
            em.close();
        }
    }

    @DELETE
    @Path("deletebooking/{bookingId}")
    @Produces(MediaType.APPLICATION_JSON)
    public String deleteBooking(@PathParam("bookingId") int bookingId) {
        // Delete an existing booking based on the provided ID and return a success or not found message
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            Booking booking = em.find(Booking.class, bookingId);
            if (booking != null) {
                em.getTransaction().begin();
                em.remove(booking);
                em.getTransaction().commit();
                return "{\"message\":\"Booking deleted successfully\"}";
            } else {
                return "{\"message\":\"Booking not found\"}";
            }
        } finally {
            em.close();
        }
    }
}
