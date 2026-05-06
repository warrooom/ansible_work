# ansible_work
My ansible playbooks from work

This collection of playbooks will be the new standard moving forward. All playbook contained will be idempotent and managed using inherited variables. 
  - rhel9STIG - Covers the auditd STIG items for RHEl9 specifically. Also the first book to handle the namespaces setting using inherited values.
  - harden_rhel9 - Addresses many leftover findings for Red Hat 9 found. Meant to replace the original harden playbook
  - harden_rhel8 - Addresses many leftover findings for Red Hat 8 found. Meant to replace the original harden playbook
  - trellix_agent - Designed to install the Trellix Agent (Can also be used to uninstall the agent using the uninstall tag)
  - commvault_fileagent - - Designed to install the Commvault file Agent (Can also be used to uninstall the agent using the uninstall tag)
  - dns_named_config - Manages the Bind dns forwarders named.conf file by variables.
  - user_management - Manages users in the environment through variable inheritance. Will also remove users.
  - csr_gen - Generates certificate requests and copies back to the ansible server for easy collection
  - eval_stig - Runs EvalStig against desired assets and returns results to the ans01, /home/aap/ansible directory.
