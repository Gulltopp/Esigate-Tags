package org.jahia.modules.esigate.services.content;

import javax.jcr.RepositoryException;

import org.jahia.services.content.JCRCallback;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.JCRTemplate;
import org.jahia.services.scheduler.BackgroundJob;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;

public class DeleteJob extends BackgroundJob {
    
    public static final String DELETE_UUID = "uuidToDelete";

    @Override
    public void executeJahiaJob(JobExecutionContext jobExecutionContext) throws Exception {
        JobDataMap jobDataMap = jobExecutionContext.getJobDetail().getJobDataMap();
        final String nodeId = jobDataMap.getString(DELETE_UUID);
        JCRTemplate.getInstance().doExecuteWithSystemSession(new JCRCallback<Object>() {
            public Boolean doInJCR(JCRSessionWrapper session) throws RepositoryException {
                return doExecute(nodeId, session);

            }
        });
    }

    private Boolean doExecute(final String nodeId, JCRSessionWrapper session) throws RepositoryException {
        try {
            JCRNodeWrapper node = session.getNodeByIdentifier(nodeId);
            if (node != null) {
                node.remove();
                session.save();
            }
        } catch (Exception e) {
            throw new RepositoryException(e);
        }
        return Boolean.TRUE;
    }

}
