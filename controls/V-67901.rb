ALLOWED_SERVER_PERMISSIONS = attribute(
  'allowed_server_permissions',
  description: 'List of allowed server permissions',
  default: ["NT AUTHORITY\\SYSTEM                                         ALTER ANY AVAILABILITY GROUP",
            "##MS_SQLAuthenticatorCertificate##                          AUTHENTICATE SERVER",
            "##MS_SQLReplicationSigningCertificate##                     AUTHENTICATE SERVER",
            "public                                                      CONNECT",
            "##MS_PolicySigningCertificate##                             CONTROL SERVER",
            "public                                                      VIEW ANY DATABASE",
            "##MS_PolicySigningCertificate##                             VIEW ANY DEFINITION",
            "##MS_PolicyTsqlExecutionLogin##                             VIEW ANY DEFINITION",
            "##MS_SmoExtendedSigningCertificate##                        VIEW ANY DEFINITION",
            "##MS_SQLReplicationSigningCertificate##                     VIEW ANY DEFINITION",
            "##MS_SQLResourceSigningCertificate##                        VIEW ANY DEFINITION",
            "##MS_PolicyTsqlExecutionLogin##                             VIEW SERVER STATE",
            "##MS_SQLReplicationSigningCertificate##                     VIEW SERVER STATE",
            "NT AUTHORITY\\SYSTEM                                         VIEW SERVER STATE"]
) 
ALLOWED_DATABASE_PERMISSIONS = attribute(
  'allowed_database_permissions',
  description: 'List of allowed database permissions',
  default: ["guest                                                       ALTER",
            "##MS_AgentSigningCertificate##                              EXECUTE",
            "##MS_PolicyEventProcessingLogin##                           EXECUTE",
            "public                                                      EXECUTE"]
) 
control "V-67901" do
  title "SQL Server and Windows must enforce access restrictions associated
  with changes to the configuration of the SQL Server instance or database(s)."
  desc  "Failure to provide logical access restrictions associated with changes
  to configuration may have significant effects on the overall security of the
  system.

      When dealing with access restrictions pertaining to change control, it
  should be noted that any changes to the hardware, software, and/or firmware
  components of the information system can potentially have significant effects
  on the overall security of the system.

      Accordingly, SQL Server and Windows must allow only qualified and
  authorized individuals to obtain access to system components for the purposes
  of initiating changes, including upgrades and modifications.
  "
  impact 0.7
  tag "gtitle": "SRG-APP-000380-DB-000360"
  tag "gid": "V-67901"
  tag "rid": "SV-82391r1_rule"
  tag "stig_id": "SQL4-00-033900"
  tag "fix_id": "F-74017r1_fix"
  tag "cci": ["CCI-001813"]
  tag "nist": ["CM-5 (1)", "Rev_4"]
  tag "false_negatives": nil
  tag "false_positives": nil
  tag "documentable": false
  tag "mitigations": nil
  tag "severity_override_guidance": false
  tag "potential_impacts": nil
  tag "third_party_tools": nil
  tag "mitigation_controls": nil
  tag "responsibility": nil
  tag "ia_controls": nil
  tag "check": "Review the security configuration of the SQL Server instance
  and database(s).

  If unauthorized Windows users can start the SQL Server Configuration Manager or
  SQL Server Management Studio, this is a finding.

  If SQL Server does not enforce access restrictions associated with changes to
  the configuration of the SQL Server instance or database(s), this is a finding.

  - - - - -

  To assist in conducting reviews of permissions, the following views and
  permissions are defined in the supplemental file Permissions.sql, provided with
  this STIG:
  database_permissions
  database_role_members
  server_permissions
  server_role_members
  database_effective_permissions('<database user/role name>')
  database_roles_of('<database user/role name>')
  members_of_db_role('<database role name>')
  members_of_server_role('<server role name>')
  server_effective_permissions('<server login/role name>')
  server_roles_of('<server login/role name>')

  Permissions of concern in this respect include the following, and possibly
  others:
  - any server permission except CONNECT SQL, but including CONNECT ANY DATABASE
  - any database permission beginning with \"CREATE\" or \"ALTER\"
  - CONTROL
  - INSERT, UPDATE, DELETE, EXECUTE on locally-defined tables and procedures
  designed for supplemental configuration and security purposes."
  tag "fix": "Configure SQL Server to enforce access restrictions associated
  with changes to the configuration of the SQL Server instance and database(s)."
  get_server_permissions = command("Invoke-Sqlcmd -Query \"SELECT DISTINCT Grantee, Permission FROM STIG.server_permissions WHERE Permission != 'CONNECT SQL';\" -ServerInstance 'WIN-FC4ANINFUFP' | Findstr /v 'Grantee ---'").stdout.strip.split("\n")
  get_server_permissions.each do | server_perms|  
    a = server_perms.strip
    describe "#{a}" do
      it { should be_in ALLOWED_SERVER_PERMISSIONS }
    end  
  end 
  
  get_database_permissions = command("Invoke-Sqlcmd -Query \"SELECT DISTINCT Grantee, Permission FROM STIG.database_permissions WHERE Permission LIKE '%CREATE%' OR Permission LIKE '%ALTER%' OR Permission IN ('CONTROL', 'INSERT', 'UPDATE', 'DELETE', 'EXECUTE');\" -ServerInstance 'WIN-FC4ANINFUFP' | Findstr /v 'Grantee ---'").stdout.strip.split("\n")
  get_database_permissions.each do | database_perms|  
    a = database_perms.strip
    puts a 
    describe "#{a}" do
      it { should be_in ALLOWED_DATABASE_PERMISSIONS }
    end  
  end 

end

