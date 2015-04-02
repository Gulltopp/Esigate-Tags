package org.jahia.modules.esigate.services;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import javax.jcr.RepositoryException;

import org.apache.commons.lang.StringUtils;
import org.jahia.exceptions.JahiaException;
import org.jahia.exceptions.JahiaInitializationException;
import org.jahia.modules.esigate.services.content.DeleteJob;
import org.jahia.registries.ServicesRegistry;
import org.jahia.services.JahiaService;
import org.jahia.services.content.rules.AbstractNodeFact;
import org.jahia.services.content.rules.NodeFact;
import org.jahia.services.content.rules.User;
import org.jahia.services.scheduler.BackgroundJob;
import org.jahia.services.usermanager.JahiaGroupManagerService;
import org.jahia.services.usermanager.JahiaUser;
import org.jahia.services.usermanager.JahiaUserManagerService;
import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.SchedulerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EsiServices extends JahiaService {

    public final static String EDIT_ESIGATE_ROLE = "esigateEditor";

    private static Logger logger = LoggerFactory.getLogger(EsiServices.class);

    private JahiaUserManagerService userManagerService;
    private JahiaGroupManagerService groupManagerService;
    private List<String> authorizedGroups;
    private List<String> authorizedUsers;

    private static EsiServices instance;

    public static EsiServices getInstance() {
        if (instance == null) {
            instance = new EsiServices();
        }
        return instance;
    }

    public void deleteNode(final NodeFact node) throws RepositoryException, SchedulerException {
        if (node instanceof AbstractNodeFact) {
            JobDetail jobDetail = BackgroundJob.createJahiaJob("Unpublish", DeleteJob.class);
            JobDataMap jobDataMap = jobDetail.getJobDataMap();
            jobDataMap.put(DeleteJob.DELETE_UUID, ((AbstractNodeFact) node).getNode().getIdentifier());

            ServicesRegistry.getInstance().getSchedulerService().scheduleJobAtEndOfRequest(jobDetail);
        }
    }

    public void handleNodeCreation(final NodeFact node, final User user) throws RepositoryException,
            SchedulerException, JahiaException {
        if (node instanceof AbstractNodeFact) {
            int siteId = Integer.parseInt(((AbstractNodeFact) node).getNode().getResolveSite()
                    .getPropertyAsString("j:siteId"));
            boolean authorized = authorizedUsers.contains(user.getName());
            if (!authorized) {
                JahiaUser jahiaUser = userManagerService.lookupUser(user.getName());

                List<String> groups = groupManagerService.getUserMembership(jahiaUser);
                for (String group : groups) {
                    logger.info("{} belongs to {}", jahiaUser.getName(), group);
                    if (StringUtils.endsWith(group, ":n")) {
                        group = StringUtils.removeEnd(group, ":n");
                    }
                    if (authorizedGroups.contains(group)) {
                        logger.info("{} belongs to authorized group {}", jahiaUser.getName(), group);
                        authorized = true;
                        break;
                    }
                }

            }
            if (!authorized) {
                logger.info("{} doesn't belong to any authorized group", user.getName());
                JobDetail jobDetail = BackgroundJob.createJahiaJob("Deleted non authorized node", DeleteJob.class);
                JobDataMap jobDataMap = jobDetail.getJobDataMap();
                jobDataMap.put(DeleteJob.DELETE_UUID, ((AbstractNodeFact) node).getNode().getIdentifier());

                ServicesRegistry.getInstance().getSchedulerService().scheduleJobAtEndOfRequest(jobDetail);
            } else {
                //((AbstractNodeFact) node).getNode().setAclInheritanceBreak(true);
                for (String userName : authorizedUsers) {
                    ((AbstractNodeFact) node).getNode().grantRoles("u:" + userName,
                            Collections.singleton(EDIT_ESIGATE_ROLE));
                    // ((AbstractNodeFact) node).getNode().getSession().save();
                }
                for (String groupName : authorizedGroups) {
                    if (StringUtils.endsWith(groupName, ":n")) {
                        groupName = StringUtils.removeEnd(groupName, ":n");
                        // groupName = shortGroupName + ":" + siteId;
                    } else if (StringUtils.contains(groupName, ':')) {
                        String[] groupArray = StringUtils.split(groupName, ":");
                        if (Integer.parseInt(groupArray[1]) == siteId) {
                            groupName = groupArray[0];
                        } else {
                            continue;
                        }
                    }

                    if (groupName != null && groupManagerService.lookupGroup(siteId, groupName) != null) {
                        ((AbstractNodeFact) node).getNode().grantRoles("g:" + groupName,
                                Collections.singleton(EDIT_ESIGATE_ROLE));
                    }
                    // ((AbstractNodeFact) node).getNode().getSession().save();
                    // }
                }
                ((AbstractNodeFact) node).getNode().getSession().save();
            }
            // /JahiaSitesBaseService.getInstance().

        }

    }

    @Override
    public void start() throws JahiaInitializationException {
        // do nothing
    }

    @Override
    public void stop() throws JahiaException {
        // do nothing
    }

    public JahiaUserManagerService getUserManagerService() {
        return userManagerService;
    }

    public void setUserManagerService(JahiaUserManagerService userManagerService) {
        this.userManagerService = userManagerService;
    }

    public JahiaGroupManagerService getGroupManagerService() {
        return groupManagerService;
    }

    public void setGroupManagerService(JahiaGroupManagerService groupManagerService) {
        this.groupManagerService = groupManagerService;
    }

    public String getAuthorizedGroups() {
        return StringUtils.join(authorizedGroups, ',');
    }

    public String getAuthorizedUsers() {
        return StringUtils.join(authorizedUsers, ',');
    }

    public void setAuthorizedGroups(String authorizedGroups) {

        this.authorizedGroups = Arrays.asList(StringUtils.split(authorizedGroups, ','));
    }

    public void setAuthorizedUsers(String authorizedUsers) {
        this.authorizedUsers = Arrays.asList(StringUtils.split(authorizedUsers, ','));
    }

}
