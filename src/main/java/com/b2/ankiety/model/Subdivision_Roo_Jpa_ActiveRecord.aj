// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.b2.ankiety.model;

import com.b2.ankiety.model.Subdivision;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Subdivision_Roo_Jpa_ActiveRecord {
    
    @PersistenceContext
    transient EntityManager Subdivision.entityManager;
    
    public static final EntityManager Subdivision.entityManager() {
        EntityManager em = new Subdivision().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Subdivision.countSubdivisions() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Subdivision o", Long.class).getSingleResult();
    }
    
    public static List<Subdivision> Subdivision.findAllSubdivisions() {
        return entityManager().createQuery("SELECT o FROM Subdivision o", Subdivision.class).getResultList();
    }
    
    public static Subdivision Subdivision.findSubdivision(Long id) {
        if (id == null) return null;
        return entityManager().find(Subdivision.class, id);
    }
    
    public static List<Subdivision> Subdivision.findSubdivisionEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Subdivision o", Subdivision.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public void Subdivision.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Subdivision.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Subdivision attached = Subdivision.findSubdivision(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Subdivision.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Subdivision.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public Subdivision Subdivision.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Subdivision merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}