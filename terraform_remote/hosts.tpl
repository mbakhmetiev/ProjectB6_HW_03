[database]
localhost

[web]
localhost

[app]
%{ for ip in hosts ~}
${ip}
%{ endfor ~}