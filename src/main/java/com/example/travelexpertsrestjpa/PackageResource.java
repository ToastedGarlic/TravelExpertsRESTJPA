package com.example.travelexpertsrestjpa;

import com.google.gson.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import model.Package;

import java.lang.reflect.Type;
import java.time.Instant;
import java.util.List;

@Path("/package")
public class PackageResource {
    // Gson instance with a custom deserializer for handling Instant objects
    private static final Gson gson = new GsonBuilder()
            .registerTypeAdapter(Instant.class, new JsonDeserializer<Instant>() {
                @Override
                public Instant deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
                    String dateTimeString = json.getAsJsonPrimitive().getAsString();
                    try {
                        return Instant.parse(dateTimeString);
                    } catch (Exception e) {
                        throw new JsonParseException("Unparseable date: \"" + dateTimeString + "\". Supported format: yyyy-MM-dd'T'HH:mm:ssZ");
                    }
                }
            })
            .create();

    // Retrieve all packages and return as JSON
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getallpackages")
    public Response getAllPackages() {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            Query query = em.createQuery("SELECT p FROM Package p", Package.class);
            List<Package> packages = query.getResultList();
            return Response.ok(gson.toJson(packages)).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("{\"message\":\"Error retrieving packages: " + e.getMessage() + "\"}").build();
        } finally {
            em.close();
        }
    }

    // Retrieve a specific package based on the provided ID and return as JSON
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getpackage/{packageId}")
    public Response getPackage(@PathParam("packageId") int packageId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            Package packageEntity = em.find(Package.class, packageId);
            if (packageEntity != null) {
                return Response.ok(gson.toJson(packageEntity)).build();
            } else {
                return Response.status(Response.Status.NOT_FOUND).entity("{\"message\":\"Package not found\"}").build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("{\"message\":\"Error retrieving package: " + e.getMessage() + "\"}").build();
        } finally {
            em.close();
        }
    }

    // Update or insert a package based on the provided JSON data and return a status message
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("postpackage")
    public String postPackage(String jsonString) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            Package packageEntity = gson.fromJson(jsonString, Package.class);
            Package savedPackage = em.merge(packageEntity);
            em.getTransaction().commit();
            return gson.toJson(savedPackage);
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return "{\"message\":\"Error updating package: " + e.getMessage() + "\"}";
        } finally {
            em.close();
        }
    }

    // Insert a new package based on the provided JSON data and return a status message
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("putpackage")
    public String putPackage(String jsonString) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            Package packageEntity = gson.fromJson(jsonString, Package.class);
            em.persist(packageEntity);
            em.getTransaction().commit();
            return gson.toJson(packageEntity);
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return "{\"message\":\"Error inserting package: " + e.getMessage() + "\"}";
        } finally {
            em.close();
        }
    }

    // Delete a package based on the provided ID and return a status message
    @DELETE
    @Path("deletepackage/{packageId}")
    @Produces(MediaType.APPLICATION_JSON)
    public String deletePackage(@PathParam("packageId") int packageId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");
        EntityManager em = factory.createEntityManager();
        try {
            Package packageEntity = em.find(Package.class, packageId);
            if (packageEntity != null) {
                em.getTransaction().begin();
                em.remove(packageEntity);
                em.getTransaction().commit();
                return "{\"message\":\"Package deleted successfully\"}";
            } else {
                return "{\"message\":\"Package not found\"}";
            }
        } finally {
            em.close();
        }
    }
}
