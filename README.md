# Microsoft Defender demo - apps and DevOps
This repository contains the code and instructions for the Microsoft Defender demo - apps and DevOps.

Demo script:
- In recommendations show DB related studd such as **SQL servers should have an Azure Active Directory administrator provisioned** or **Azure Cosmos DB accounts should have firewall rules**. See Prevention with **Deny** button that can generate preventive policy.
- But what about catching those even before infrastructure is even created? Check Informational recommendation **GitHub repositories should have infrastructure as code scanning findings resolved**
- Mention correlation between Infrastructure as code and actual resource i Azure eg. via Cloud Security Explorer (resources -> Provisioned by -> Code repositories)
- In recommendations see Kubernetes recommendations such as **Immutable (read-only) root filesystem should be enforced for containers** and again show Prevention action to enforce on all hybrid Kubernetes clusters (AKS or Arc for Kubernetes)
- Show detections on Kubernetes such as **A drift binary detected executing in the container** and others including Informational anomalies such as **SSH server is running inside a container**, **New container in the kube-system namespace detected** or **Role binding to the cluster-admin role detected**
- In recommendations show **Container images in Azure registry should have vulnerability findings resolved**
- Note eg. in Cloud Security Explorer mention that we know more about containers - is it running? Is it exposed to Internet? What Kubernetes service exposes it? What are labels?
- In recommendations show **GitHub repositories should have dependency vulnerability scanning findings resolved** and look for example at SQLAlchemy vulnerability. Click on view affected repo and see Pull Request where Dependabot already proposed changes to fix the vulnerability.
- In recommendations show **GitHub repositories should have code scanning findings resolved**, see few findings and click on View in GitHub. There show how GitHub Advanced Security provides clear guaidance on how to resolve the finding and use Fix with Copilot button to generate a code fix and submit as Pull Request.
- In recommendations show **GitHub repositories should have code scanning findings resolved** and that click on see in GitHub so see quide how to fix it.
- In recommendations show **API Management calls to API backends should be authenticated**
- Discuss detection capabilities on APIs - catch unusual activity

TODO:
- Cloud Security Explorer: IaC to actual resources correlation
- Cloud Security Explorer: Pod -> image -> vulnerability demo
- API anomalies
- PR annotations
- IaC scanning