---
title: firewall
keywords: documentation
layout: documentation
sidebar: ora_profile_sidebar
toc: false
---
## Overview

This class contains the definition of the firewall settings you need for Oracle.

When you are using a Redhat flavored version lower then release 7, this module uses the `puppetlabs-firewall` module to manage the `iptables` settings. When using a version 7 or higher, the puppet module `crayfishx-firewalld` to manage the `firewalld daemon`.

When these customizations aren't enough, you can replace the class with your own class. See [ora_profile::database](./database.html) for an explanation on how to do this.





## Attributes



Attribute Name                             | Short Description                                                                          |
------------------------------------------ | ------------------------------------------------------------------------------------------ |
[manage_service](#firewall_manage_service) | Using this setting you can specify if you want this module to manage the firewall service. |
[ports](#firewall_ports)                   | A list of TCP ports to open in the firewall.                                               |




### ports<a name='firewall_ports'>

A list of TCP ports to open in the firewall.

The default value is: `[1521]`


Type: `Hash`


[Back to overview of firewall](#attributes)

### manage_service<a name='firewall_manage_service'>

Using this setting you can specify if you want this module to manage the firewall service.

The default value is `true` and will make sure the firewall service is started and enabled.
Type: `Boolean`


[Back to overview of firewall](#attributes)
