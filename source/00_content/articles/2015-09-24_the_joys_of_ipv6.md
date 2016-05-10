# The joys of IPv6

A couple of weeks ago I moved to Karlsruhe where I will study Mathematics starting this fall. Among other things this meant that I had to search for an Internet provider for my new appartment. Previously I used a _DSL_ connection by _Telekom_ which offered nothing to complain about if one disregards the abysmal bandwidth available in my small home village in southern Germany. Luckily my new appartment offers the option of accessing the Internet via _TV-cable_ instead of _POTS_ which promises a better connection bandwidth than _DSL_ even in the city. As my new provider uses a special kind of dual stack system I was finally confronted with _IPv6_ and want to summarize my experiences in this article.

Besides the promise of a better bandwidth and despite my good experiences with their connection over many years the main reason for considering alternatives to _Telekom_ was that they don't offer the kind of Internet-only package I wanted. At first I also considered a _O2_ _DSL_ connection because I already use their mobile offerings but as I recently suffered problems with their contract management when they mixed up my contract with the contracts of my family members I opted to disregard them in favor of _Unitymedia_[^0].

After some initial confusion when I received the router days before my connection was installed without any communication[^1] concerning this waiting period, my new Internet connection works as well as expected with stable response times and ~ 6 MiB per second downstream.

## Remaining problems with _Unitymedia_

As I still work as a part time software developer at my former training company but live in Karlsruhe I do most of my work remotely. While the bandwidth requirements for this task are negligible some of our customers require _IPSec_ based VPNs in order to access their _SAP_ systems. Sadly the special IP-packets required for this kind of VPN seem to be dropped by _Unitymedia_ which means that I require an additional _Level-2_ VPN to a non-dropping connection in order to use these VPNs. But all things considered this is still an acceptable tradeoff.

If one reads forum and blog posts concerning _Unitymedia_'s service one will find lots of whining about their _DSlite_ technology for providing a dual stack _IPv4_ and _IPv6_ connection. This is mostly because they don't seem to have enough _IPv4_ addresses to offer each customer their own address. This means that _IPv4_ addresses of _DSlite_ connections are shared between multiple customers[^2]. The only globally accessible address each customer gets is a _IPv6_ address - for each device connected to the router.

This brings me to the main point of this article: _IPv6_ instantly enables all my devices to be globally accessible without any hindrances such as _NAT_ hopping. With _IPv6_ the network address translation system of _IPv4_ is not required anymore - there are enough addresses for everyone. This also defeats many of the complaints about _DSlite_ as one simply doesn't need _IPv4_ _natting_, port forwarding and dynamic _DNS_ providers anymore.

## The vision

	2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
		link/ether 00:50:##:##:##:## brd ff:ff:ff:ff:ff:ff
		inet 192.168.178.2/24 brd 192.168.178.255 scope global eth0
		   valid_lft forever preferred_lft forever
		inet6 2a02:8071:####:####:###:####:####:####/64 scope global mngtmpaddr dynamic 
		   valid_lft 604799sec preferred_lft 302399sec
		inet6 fe80::250:43ff:fe01:6d36/64 scope link 
		   valid_lft forever preferred_lft forever

As we can see my examplary device connected to my new provider's router not only gets the normal _IPv4_ and _IPv6_ subnet addresses but also a `scope global` _IPv6_ address which is accessible from any _IPv6_ enabled host on the Internet using e.g. `ping6`.

This does away with the smokescreen that is _NAT_ in _IPv4_ and forces one to consider that all devices connected to the Internet are a potential target and act accordingly by e.g. setting up _iptable_ firewalls on each and every device.

_IPv6_ opens the Internet up in a sense as I now don't have to forward any ports in my router anymore and can access my personal mail server from everywhere without any further setup on the clientside. Furthermore I can _ssh_ into every one of my devices from every other device without thinking on how to circumvent the given _NAT_ hiding the devices from each other. I look forward to the time where _IPv4_ is replaced by _IPv6_ accross the board and the Internet looks more like a decentral mesh of all participating devices again.

The only challenge standing in the way of actually being able to do all the nice things mentioned above is that not all Internet providers are already assigning _IPv6_ addresses to all their customers. This means that I currently can not directly access _IPv6_ hosts from both my home village and mobile connections. Luckily this issue is easily circumvented by tunneling those connections through a _Layer-3_ _OpenVPN_ setup.

## Bringing the joys to all devices via _OpenVPN_

While I already had various _OpenVPN_ instances set up on both my virtual server hosting this website as well as the _SheevaPlug_, neither of them were _IPv6_ enabled. This required some trickery to change - especially in combination with my chosen _iptable_ manager _[UFW]_ and some _systemd_ details previously unknown to me.

	proto udp
	proto udp6
	
	dev tun
	tun-ipv6
	
	# [...] certificates
	
	server      10.8.0.0 255.255.255.0
	server-ipv6 2a01:4f8:c17:77a:4000::/66
	
	# [...] further unrelated settings
	
	push "redirect-gateway def1"
	push "redirect-gateway-ipv6 def1"
	push "route-ipv6 ::/0 fe80::1 100"

These are the relevant sections of the server configuration of my _IPv6_ proxy VPN. The `proto udp6` flag enables access to the VPN via _IPv6_. `tun-ipv6` enables _IPv6_ support on the _TUN_ interface created by _OpenVPN_ while the `server-ipv6` statement declares the global _IPv6_ subnet designated for clients of the VPN[^3]. Finally the `push` directives tell the clients that they should route all their _IPv6_ traffic through the VPN.

To make this configuration work one also has to add the following statements to the head of `/etc/ufw/before.rules`[^4]:

	# nat Table rules
	*nat
	:POSTROUTING ACCEPT [0:0]

	# Allow traffic from clients to ens3
	-F
	-A POSTROUTING -s 10.8.0.0/24 -o ens3 -j MASQUERADE

Additionally the `net.ipv6.conf.all.forwarding` parameter has to be set to `1` using e.g. `sysctl`. If you also use _systemd-networkd_ as your network manager, make sure that the parameter `IPv6Forward` is set to `yes` for your external interface.  
Note that these are all the settings I changed while playing around in order to make the VPN work - it very well may be that not all of them are strictly required.

If you don't access the VPN server via _IPv6_ which is obviously the case if you require it to gain _IPv6_ connectivity in the first place, no changes to the client configuration should be necessary.

## Remaining problems with _IPv6_

One disadvantage of _IPv6_ in comparison to _IPv4_ is that the addresses are not as easily remembered anymore which is sadly an inherent issue if one wants to increase the available address space from only 32 to 128 bits[^5].

One possible solution for this is to build some kind of private _DNS_ that announces the _IPv6_ addresses of all my devices so they can more easily find each other. But before doing that I will first wait until the _SheevaPlug_ gets assigned a new _IPv6_ address by my provider - in the best case that will never happen.

There are some privacy concerns around this property of _IPv6_ as never changing addresses allow for even easier long-term tracking of individual Internet usage. These concerns are addressed by its [privacy extensions]. While these extensions may be a good idea for devices used to consume the Internet[^6] I have disabled them on my dynamically addressed servers by setting `net.ipv6.conf.all.use_tempaddr` to zero.

[^0]: Previously called _KabelBW_ in southern Germany
[^1]: I received the shipment confirmation and tracking code days after I had already received the package and _Unitymedia_ knew nothing about this. It seems they mixed up my package and sent it way to soon.
[^2]: Which seemingly leads to captchas on Google for some customers as they receive to many requests from a single _IPv4_ address.
[^3]: Contrary to _IPv4_ VPNs it is not a recommended practice to hide the _IPv6_ clients behind a _NAT_. They are instead directly exposed to the whole Internet which has the nice effect of enabling me to connect to clients of the VPN as if they were normal _IPv6_ hosts.
[^4]: Note that these don't differ from what is required for the _IPv4_ natting to work.
[^5]: To comprehend the size of this number keep in mind that the default _IPv6_ subnet size is the 64th power of 2 meaning that most _IPv6_ hosts out there get assigned more potential subnet addresses then there are _IPv4_ addresses. There are no reasons for ever reassigning _IPv6_ addresses besides privacy concerns.
[^6]: Although I don't think that it is the responsibility of the addressing system to provide anonymity. If one requires strong privacy guarantees one should use some kind of throw away _TOR_ setup anyway.

[UFW]: https://launchpad.net/ufw
[privacy extensions]: https://wiki.archlinux.org/index.php/IPv6#Privacy_extensions
