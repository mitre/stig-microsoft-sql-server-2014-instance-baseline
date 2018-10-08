AUTHORIZED_SQL_USERS= attribute(
  'authorized_sql_users',
  description: 'List of authorized users for the SQL server',
  default: ["public",
            "sysadmin",
            "securityadmin",
            "serveradmin",
            "setupadmin",
            "processadmin",
            "diskadmin",
            "dbcreator",
            "bulkadmin",
            "##MS_SQLResourceSigningCertificate##",
            "##MS_SQLReplicationSigningCertificate##",
            "##MS_SQLAuthenticatorCertificate##",
            "##MS_PolicySigningCertificate##",
            "##MS_SmoExtendedSigningCertificate##",
            "WIN-FC4ANINFUFP\\Administrator",
            "NT SERVICE\\SQLWriter",
            "NT SERVICE\\Winmgmt",
            "NT Service\\MSSQLSERVER",
            "NT AUTHORITY\\SYSTEM",
            "NT SERVICE\\SQLSERVERAGENT",
            "##MS_AgentSigningCertificate##"]                            
)
control "V-67863" do
  title "SQL Server must uniquely identify and authenticate organizational
  users (or processes acting on behalf of organizational users)."
  desc  "To ensure accountability and prevent unauthorized SQL Server access,
  organizational users shall be identified and authenticated.

      Organizational users include organizational employees and individuals the
  organization deems to have equivalent status of employees (e.g., contractors,
  guest researchers, individuals from allied nations).

      Users (and any processes acting on behalf of users) must be uniquely
  identified and authenticated for all accesses other than those accesses
  explicitly identified and documented by the organization, which must outline
  specific user actions that can be performed on SQL Server without
  identification or authentication.
  "
  impact 0.7
  tag "gtitle": "SRG-APP-000148-DB-000103"
  tag "gid": "V-67863"
  tag "rid": "SV-82353r1_rule"
  tag "stig_id": "SQL4-00-018400"
  tag "fix_id": "F-73979r1_fix"
  tag "cci": ["CCI-000764"]
  tag "nist": ["IA-2", "Rev_4"]
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
  tag "check": "Review SQL Server users to determine whether shared accounts
  exist. (This does not include the case where SQL Server has a guest or public
  account that is providing access to publicly available information.)

  If accounts are determined to be shared, determine if individuals are first
  individually authenticated.

  If individuals are not individually authenticated before using the shared
  account (e.g., by the operating system or possibly by an application making
  calls to the database), this is a finding.

  If accounts are determined to be shared, determine if they are directly
  accessible to end users.  If so, this is a finding."
  tag "fix": "Remove user-accessible shared accounts and use individual userids.

  Build/configure applications to ensure successful individual authentication
  prior to shared account access.

  Ensure each user's identity is received and used in audit data in all relevant
  circumstances."
  get_users = command("Invoke-Sqlcmd -Query \"select name from master.sys.server_principals where is_disabled = 0;\" -ServerInstance 'WIN-FC4ANINFUFP' | Findstr /v 'name ---'").stdout.strip.split("\r\n")
  get_users.each do | user|  
    a = user.strip
    describe "#{a}" do
      it { should be_in AUTHORIZED_SQL_USERS }
    end  
  end 
end

