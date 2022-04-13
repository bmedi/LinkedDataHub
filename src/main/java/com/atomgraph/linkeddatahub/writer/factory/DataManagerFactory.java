/**
 *  Copyright 2019 Martynas Jusevičius <martynas@atomgraph.com>
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package com.atomgraph.linkeddatahub.writer.factory;

import org.apache.jena.util.LocationMapper;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.SecurityContext;
import javax.ws.rs.ext.Provider;
import com.atomgraph.client.util.DataManager;
import com.atomgraph.linkeddatahub.apps.model.Application;
import com.atomgraph.linkeddatahub.apps.model.EndUserApplication;
import com.atomgraph.linkeddatahub.server.security.AgentContext;
import com.atomgraph.linkeddatahub.vocabulary.LAPP;
import com.atomgraph.linkeddatahub.writer.impl.DataManagerImpl;
import java.net.URI;
import java.util.HashMap;
import java.util.Optional;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ResourceContext;
import javax.ws.rs.core.UriInfo;
import javax.ws.rs.ext.Providers;
import org.glassfish.hk2.api.Factory;
import org.glassfish.hk2.api.ServiceLocator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * JAX-RS provider for <code>DataManager</code>.
 * 
 * @author Martynas Jusevičius {@literal <martynas@atomgraph.com>}
 * @see com.atomgraph.client.util.DataManager
 */
@Provider
public class DataManagerFactory implements Factory<DataManager>
{
    private static final Logger log = LoggerFactory.getLogger(DataManagerFactory.class);

    @Context UriInfo uriInfo;
    @Context SecurityContext securityContext;
    @Context ResourceContext resourceContext;
    @Context HttpServletRequest httpServletRequest;
    @Context Providers providers;
    @Context ServiceLocator serviceLocator;
    
    @Inject Optional<AgentContext> agentContext;

    @Inject com.atomgraph.linkeddatahub.Application system;
    
    @Override
    public DataManager provide()
    {
        return getDataManager(getApplication(getContainerRequestContext()));
    }

    @Override
    public void dispose(DataManager t)
    {
    }
    
    /**
     * Returns RDF data manager.
     * 
     * @param app end-user application
     * @return data manager
     */
    public DataManager getDataManager(Application app)
    {
        final com.atomgraph.core.util.jena.DataManager baseManager;
        
        if (app.canAs(EndUserApplication.class))
            baseManager = (com.atomgraph.core.util.jena.DataManager)getSystem().getOntModelSpec(app.as(EndUserApplication.class)).getDocumentManager().getFileManager();
        else
            baseManager = getSystem().getDataManager();
            
        // copy cached models over from the app's FileManager
        return new DataManagerImpl(LocationMapper.get(), new HashMap<>(baseManager.getModelCache()),
            getSystem().getClient(), getSystem().getMediaTypes(),
            true, getSystem().isPreemptiveAuth(), getSystem().isResolvingUncached(),
            URI.create(getHttpServletRequest().getRequestURL().toString()).resolve(getHttpServletRequest().getContextPath() + "/"), getUriInfo(),
                getSecurityContext(), getAgentContext());
    }
    
    /**
     * Returns system application.
     * 
     * @return JAX-RS application
     */
    public com.atomgraph.linkeddatahub.Application getSystem()
    {
        return system;
    }
    
    /**
     * Returns the request URI information.
     * 
     * @return URI info
     */
    public UriInfo getUriInfo()
    {
        return uriInfo;
    }
    
    /**
     * Returns the JAX-RS security context.
     * 
     * @return security context
     */
    public SecurityContext getSecurityContext()
    {
        return securityContext;
    }
    
    /**
     * Returns agent context with additional metadata.
     * @return optional agent context
     */
    public Optional<AgentContext> getAgentContext()
    {
        return agentContext;
    }
    
    /**
     * Returns the servlet request.
     * <code>HttpServletRequest</code> is not part of the JAX-RS API.
     * 
     * @return request
     */
    public HttpServletRequest getHttpServletRequest()
    {
        return httpServletRequest;
    }
    
    /**
     * Returns JAX-RS providers.
     * 
     * @return provider registry
     */
    public Providers getProviders()
    {
        return providers;
    }
    
    /**
     * Returns the container request context.
     * 
     * @return request context
     */
    public ContainerRequestContext getContainerRequestContext()
    {
        return serviceLocator.getService(ContainerRequestContext.class);
    }
    
    public Application getApplication(ContainerRequestContext crc)
    {
        return (Application)crc.getProperty(LAPP.Application.getURI());
    }
    
}