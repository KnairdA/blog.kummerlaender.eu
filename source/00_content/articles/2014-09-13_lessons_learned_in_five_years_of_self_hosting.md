# Lessons learned in five years of self-hosting

Nearly five years ago I started self-hosting this website on a [SheevaPlug]. Two days ago I reassigned the DNS records to point to a virtual server that now hosts the newly developed [statically generated] version of this website you are currently viewing. I want to use this article to document some of the lessons I learned during this time.

One thing that became clear during those five years is that the [Marvell SheevaPlug] really is a great and durable platform for hosting web applications from a home connection. It combines more than enough processing power with a energy efficient, compact and fan-less design which is all that is needed to host a full web stack consisting of a preferred database, language and web server. For my use case this meant _MariaDB_ in combination with _PHP_ and _Lighttpd_ as a foundation for a _Symphony CMS_ instance. And even this didn't bring the SheevaPlug to its limits as it was no problem to host additional applications such as _Dovecot_ and _OpenVPN_ on the same device. The only reason why I moved this website to a virtual server is that the unacceptably slow _DSL_ connection available in my home village could not keep up with growing visitor counts and growing expectations on availabilty on my part. If it weren't for this issue and the absence of hope that this situation will get better in the near future I would still host this website from home - both the hardware and software configuration would be more than up to the task.

This also means that I did not shut down the SheevaPlug but it _happily_ continues to host my _IMAP_ Server and various other private applications that I will certainly not move into the _Cloud_. In my opinion self-hosting these sort of applications really pays off as one doesn't have to worry about the privacy implications of centralized services nearly as much. In fact the only way private data leaves my personal networks is as a encrypted backup on [Tarsnap]. Additionally it is in a sense _fun_ to have a server running at home as in certain situations[^1] it really brings home what an amazing thing the Internet actually is.

## Requirements

While one could use any computer equipped with a network connection as a personal server it pays off to invest in a _Plug Computer_ like the SheevaPlug[^2] or any other low-power [single board computer]. Most of these devices combine a small form factor with low power usage, passive cooling and enough performance to run web applications.

Besides a viable computing platform one also requires a Internet connection that offers a public IP address and is not hidden behind a provider subnet. A static IP address on the other hand is not required as a dynamic DNS setup based on [NoIP] or [DynDNS] works really well in my experience. The IP address assigned to my home connection doesn't change more than once a day and downtimes due to DNS related problems were minimal.

In my case I use [NoIP] as a dynamic DNS provider since the beginning of my self-hosting project and I can not complain - especially since the free offering was always enough for my use cases. While one can not directly use a own domain with their free offering this problem is easily solved via _CNAME_ DNS entries.

## Summary

All in all the only hurdle towards self-hosting at least privacy-sensitive applications is the technical knowhow required to set up a public server and secure it enough as to not create more problems than one solves. Projects that aim to remove that obstacle include the [FreedomBox] and [ArkOS].

There are reasons enough why self-hosting more services is a good idea. These reasons include opposing the transformation of a more or less decentral network into a network dependent on a few central software services in addition to increasing the distribution of the attack surface of private data. A central service hosting the private eMails and chat conversations of millions of people is a much more attractive target for attackers[^3] than thousands of self-hosted devices running a myriad of different configurations.

After five years of self-hosting I can say that while the viability of hosting public websites largely depends on the quality of ones Internet connection, even a slow connection like mine[^4] is enough to host a private eMail and communication infrastructure. This is also the use-case that makes the most sense as the dangers of centralization mostly apply to private data and not to a public website.

As a conclusion I want to say that self-hosting is not only feasible but works much better than one would expect and while I cannot without a doubt recommend self-hosting a public website with more than a small number of visitors, it is certainly a good solution to further protect ones private information.

If you should have further questions on my experience with self-hosting feel free to comment or to [contact] me personally.

[SheevaPlug]: /tag/sheevaplug/
[Marvell SheevaPlug]: https://www.globalscaletechnologies.com/t-sheevaplugdetails.aspx
[statically generated]: /page/this_website/
[Tarsnap]: http://tarsnap.com
[single board computer]: http://linuxgizmos.com/top-10-hacker-sbcs-survey-results/ 
[NoIP]: http://noip.com
[DynDNS]: http://dyndns.com
[FreedomBox]: http://freedomboxfoundation.org/
[ArkOS]: https://arkos.io/
[contact]: /page/contact/

[^1]: e.g. when one is able to access ones eMail and personal data repository in addition to the full private subnet from thousands of kilometers away
[^2]: respectively a successor such as e.g. a _GuruPlug_
[^3]: Government supported or otherwise
[^4]: Currently and probably for at least the next couple of years a 2 Mbit DSL connection
