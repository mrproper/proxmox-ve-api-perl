proxmox-ve-api-perl
===================
NAME
       Net::Proxmox::VE - Pure perl API for Proxmox virtualisation

SYNOPSIS
           use Net::Proxmox::VE;

           %args = (
               host     => 'proxmox.local.domain',
               password => 'barpassword',
               user     => 'root', # optional
               port     => 8006,   # optional
               realm    => 'pam',  # optional


           );

           $host = Net::Proxmox::VE->new(%args);

           $host->login() or die ('Couldnt log in to proxmox host');

DESCRIPTION
       This Class provides the framework for talking to Proxmox VE 2.0 API instances.  This just
       provides a get/delete/put/post abstraction layer as methods on Proxmox VE REST API This also
       handles the ticket headers required for authentication

       More details on the API can be found here: http://pve.proxmox.com/wiki/Proxmox_VE_API
       http://pve.proxmox.com/pve2-api-doc/

       This class provides the building blocks for someone wanting to use PHP to talk to Proxmox
       2.0. Relatively simple piece of code, just provides a get/put/post/delete abstraction layer
       as methods on top of Proxmox's REST API, while also handling the Login Ticket headers
       required for authentication.

METHODS
   api_version_check
       Checks that the api we are talking to is at least version 2.0

       Returns true if the api version is at least 2.0 (perl style true or false)

   check_login_ticket
       Verifies if the objects login ticket is valid and not expired

       Returns true if valid Returns false and undefines the login ticket if invalid

   debug
       Has a single optional argument of 1 or 0 representing enable or disable debugging.

       Undef (ie no argument) leaves the debug status untouched, making this method call simply a
       query.

       Returns the resultant debug status (perl style true or false)

   delete
       An action helper method that just takes a path as an argument and returns the value of action
       with the DELETE method

   get
       An action helper method that just takes a path as an argument and returns the value of action
       with the GET method

   get_node_list
       Returns the clusters node list from the object, if thats not defined it calls
       reload_node_list and returns the node_list

   login
       Initiates the log in to the PVE Server using JSON API, and potentially obtains an Access
       Ticket.

       Returns true if success

   new
       Creates the Net::Proxmox::VE object and returns it.

       Examples...

         my $obj = Net::Proxmox::VE->new(%args);
         my $obj = Net::Proxmox::VE->new(\%args);

       Valid arguments are...

       host
           Proxmox host instance to interact with. Required so no default.

       username
           User name used for authentication. Defaults to 'root', optional.

       password
           Pass word user for authentication. Required so no default.

       port
           TCP port number used to by the Proxmox host instance. Defaults to 8006, optional.

       realm
           Authentication realm to request against. Defaults to 'pam' (local auth), optional.

       debug
           Enabling debugging of this API (not related to proxmox debugging in any way). Defaults to
           false, optional.

   post
       An action helper method that takes two parameters: path hash ref to post data your returned
       what action with the POST method returns

   put
       An action helper method that takes two parameters: path hash ref to post data your returned
       what post returns

   reload_node_list
       gets and sets the list of nodes in the cluster into $self->{node_list} returns false if there
       is no nodes listed or an arrayref is not returns from action

   url_prefix
       returns the url prefix used in the rest api calls

SEE ALSO
SUPPORT
AUTHORS
       Brendan Beveridge <brendan@nodeintegration.com.au>, Dean Hamstead <dean@fragfest.com.au>



