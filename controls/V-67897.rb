control 'V-67897' do
  title "SQL Server must produce time stamps that can be mapped to Coordinated
  Universal Time (UTC, formerly GMT)."
  desc "If time stamps are not consistently applied and there is no common
  time reference, it is difficult to perform forensic analysis, in audit files,
  trace files/tables, and application data tables.

      Time is commonly expressed in Coordinated Universal Time (UTC), a modern
  continuation of Greenwich Mean Time (GMT), or local time with an offset from
  UTC.  SQL Server obtains the date and time from the Windows operating system.
  In a normal configuration, the OS obtains them from an official time server,
  using Network Time Protocol (NTP).  The ultimate source is the United States
  Naval Observatory Master Clock.

      SQL Server built-in functions for retrieving current timestamps are:  (high
  precision) sysdatetime(), sysdatetimeoffset(), sysutcdatetime();  (lower
  precision) CURRENT_TIMESTAMP or getdate(), getutcdate().

      Provided the operating system is synchronized with an official time server,
  these timestamp-retrieval functions are automatically compliant with this
  requirement, as are SQL Server's audit and trace capabilities.
  "
  impact 0.5
  tag "gtitle": 'SRG-APP-000374-DB-000322'
  tag "gid": 'V-67897'
  tag "rid": 'SV-82387r1_rule'
  tag "stig_id": 'SQL4-00-033600'
  tag "fix_id": 'F-74013r1_fix'
  tag "cci": ['CCI-001890']
  tag "nist": ['AU-8 b', 'Rev_4']
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
  tag "check": "Verify that the Windows operating system is configured to
  synchronize with an official time server, using Network Time Protocol (NTP).

  If it is not, and this is not documented, with justification and AO
  authorization, this is a finding.

  If the OS does not synchronize with a time server, review the procedure for
  maintaining accurate time on the system.

  If such a procedure does not exist, this is a finding.

  If the procedure exists, review evidence that the correct time is actually
  maintained.

  If the evidence indicates otherwise, this is a finding."
  tag "fix": "Where possible, configure the operating system to automatic
  synchronize with an official time server, using NTP.

  Where there is reason not to implement automatic synchronization with an
  official time server, using NTP, document the reason, and the procedure for
  maintaining the correct time, and obtain AO approval.  Enforce the procedure."
  describe registry_key('HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\W32time\Parameters') do
    its('Type') { should_not cmp == 'NTP' }
    its('Type') { should_not cmp == 'AllSync' }
  end
  describe registry_key('HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\W32time\Parameters') do
    its('NTPServer') { should_not cmp == 'time.windows.com' }
  end
end
