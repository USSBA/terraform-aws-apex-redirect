# IPV6

## apex-redirect

This example provides a simple redirect from the apex, or root, of the domain to the appropriate subdomain using a dual stack configuration. If you are moving from an IPv4 to dualstack configuration please note that Terraform, at one point, has/had an issue tracking subnet mapping state correctly and as a result may require the entire NLB to be destroyed and recreated for the dualstack setting to be retained in state.

