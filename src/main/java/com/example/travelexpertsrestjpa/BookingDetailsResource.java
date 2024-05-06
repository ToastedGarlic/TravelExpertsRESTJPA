package com.example.travelexpertsrestjpa;

import com.google.gson.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import model.Bookingdetail;
import java.lang.reflect.Type;
import java.sql.Timestamp;
import java.util.List;

@Path("/bookingdetail")
public class BookingDetailsResource {

    // Gson instance with custom deserializer for Timestamp
    private static final Gson gson = new GsonBuilder()
            .registerTypeAdapter(Timestamp.class, (JsonDeserializer<Timestamp>) (json, typeOfT, context) -> {
                try {
                    return Timestamp.valueOf(json.getAsString());
                } catch (IllegalArgumentException e) {
                    throw new JsonParseException("Invalid date format.");
                }
            })
            .create();

    // EntityManagerFactory for creating EntityManager instances
    private static final EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");

    // Method to get EntityManager instance
    private EntityManager getEntityManager() {
        return factory.createEntityManager();
    }

    // Get all booking details and return as JSON
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getallbookingdetails")
    public Response getAllBookingDetails() {
        EntityManager em = getEntityManager();
        try {
            List<Bookingdetail> details = em.createQuery("SELECT b FROM Bookingdetail b", Bookingdetail.class).getResultList();
            return Response.ok(gson.toJson(details)).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(gson.toJson("Error retrieving booking details: " + e.toString())).build();
        } finally {
            em.close();
        }
    }

    // Get a specific booking detail based on ID and return as JSON
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getbookingdetail/{bookingDetailId}")
    public Response getBookingDetail(@PathParam("bookingDetailId") int bookingDetailId) {
        EntityManager em = getEntityManager();
        try {
            Bookingdetail detail = em.find(Bookingdetail.class, bookingDetailId);
            if (detail != null) {
                return Response.ok(gson.toJson(detail)).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND).entity(gson.toJson("Booking detail not found")).build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(gson.toJson("Error retrieving booking detail: " + e.toString())).build();
        } finally {
            em.close();
        }
    }

    // Add a new booking detail
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("addbookingdetail")
    public Response addBookingDetail(String jsonString) {
        EntityManager em = getEntityManager();
        try {
            Bookingdetail detail = gson.fromJson(jsonString, Bookingdetail.class);
            em.getTransaction().begin();
            em.persist(detail);
            em.getTransaction().commit();
            return Response.ok(gson.toJson(detail)).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(gson.toJson("Error creating booking detail: " + e.toString())).build();
        } finally {
            em.close();
        }
    }

    // Update an existing booking detail
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("updatebookingdetail/{bookingDetailId}")
    public Response updateBookingDetail(@PathParam("bookingDetailId") int bookingDetailId, String jsonString) {
        EntityManager em = getEntityManager();
        try {
            Bookingdetail detail = gson.fromJson(jsonString, Bookingdetail.class);
            detail.setId(bookingDetailId); // Ensure the ID is set correctly for the update
            em.getTransaction().begin();
            em.merge(detail);
            em.getTransaction().commit();
            return Response.ok(gson.toJson(detail)).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity(gson.toJson("Error updating booking detail: " + e.toString())).build();
        } finally {
            em.close();
        }
    }

    // Delete a booking detail based on ID
    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    @Path("deletebookingdetail/{bookingDetailId}")
    public Response deleteBookingDetail(@PathParam("bookingDetailId") int bookingDetailId) {
        EntityManager em = getEntityManager();
        try {
            Bookingdetail detail = em.find(Bookingdetail.class, bookingDetailId);
            if (detail != null) {
                em.getTransaction().begin();
                em.remove(detail);
                em.getTransaction().commit();
                return Response.ok("{\"message\":\"Booking detail deleted successfully\"}").build();
            } else {
                return Response.status(Response.Status.NOT_FOUND).entity("{\"message\":\"Booking detail not found\"}").build();
            }
        } finally {
            em.close();
        }
    }
}
