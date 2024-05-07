//created by Mohsen
package com.example.travelexpertsrestjpa;

import com.google.gson.Gson;
import jakarta.persistence.*;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import model.Package;

import java.util.List;

@Path("/package")
public class PackageResource {
    private static final Gson gson = new Gson();
    private static final EntityManagerFactory factory = Persistence.createEntityManagerFactory("default");

    // Retrieve all packages and return as JSON
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("getallpackages")
    public Response getAllPackages() {
        EntityManager em = factory.createEntityManager();
        try {
            List<Package> packages = em.createQuery("SELECT p FROM Package p", Package.class).getResultList();
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

    // Update a package based on the provided JSON data and package ID
    @PUT
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("updatepackage/{packageId}")
    public Response updatePackage(@PathParam("packageId") int packageId, String jsonString) {
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            Package existingPackage = em.find(Package.class, packageId);
            if (existingPackage == null) {
                return Response.status(Response.Status.NOT_FOUND).entity("{\"message\":\"Package not found\"}").build();
            }
            Package updatedPackage = gson.fromJson(jsonString, Package.class);
            updatedPackage.setId(packageId); // Ensure ID is set correctly
            em.merge(updatedPackage);
            em.getTransaction().commit();
            return Response.ok(gson.toJson(updatedPackage)).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("{\"message\":\"Error updating package: " + e.getMessage() + "\"}").build();
        } finally {
            em.close();
        }
    }

    // Create a new package based on the provided JSON data
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("createpackage")
    public Response createPackage(String jsonString) {
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            Package newPackage = gson.fromJson(jsonString, Package.class);
            em.persist(newPackage);
            em.getTransaction().commit();
            return Response.status(Response.Status.CREATED).entity(gson.toJson(newPackage)).build();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("{\"message\":\"Error creating package: " + e.getMessage() + "\"}").build();
        } finally {
            em.close();
        }
    }

    // Delete a package based on the provided ID
    @DELETE
    @Path("deletepackage/{packageId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response deletePackage(@PathParam("packageId") int packageId) {
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            Package packageEntity = em.find(Package.class, packageId);
            if (packageEntity != null) {
                em.remove(packageEntity);
                em.getTransaction().commit();
                return Response.ok("{\"message\":\"Package deleted successfully\"}").build();
            } else {
                return Response.status(Response.Status.NOT_FOUND).entity("{\"message\":\"Package not found\"}").build();
            }
        } finally {
            em.close();
        }
    }
}