# Apex Redirect module for Terraform AWS

## Purpose

If the root of your DNS is serviced by another DNS provider, i.e. an external DNS or AWS account outside of your application environment, you might run into an obscure quirk with DNS.

* The Apex domain, such as `example.com`, by DNS specification _must_ be an `A` record.
* `A` records _must_ be IP addresses (not hostnames)
* If DNS for `example.com` is managed outside of your AWS account, you must provide them with an IP address to populate the `A` record
* If you're using a Load Balancer, CloudFront, or anything else without static IPs on AWS, **this is a problem**.
  * Typically, this issue would be resolved by `Alias` records in Route53, but that's not an option if your DNS is handled externally

The solution for this is to create a small service at your Apex domain `example.com` that does nothing but redirect viewers to a subdomain `www.example.com`

* Your service would have a small set of Static IPs
* The service issues 301 Redirects to send viewers to the subdomain
* This takes very little processing power, but can be a hassle to configure
* If your application operates over TLS (HTTPS), there are additional configurations to maintain [cert rotation, tls configuration]

We historically have done this with a single EC2 instance with an Elastic IP, but...

* This means our EC2 instance is a single point of failure
* Managing the AMI lifecycle (Creation, Updating, Rebuilding) was tedious
* Doing this for a single instance was tolerable, but didn't scale to each domain
* Things kept going wrong

Needing to workaround all of this led us to create this module.

![Image depicting a flowchart of the problem of apex redirects and solution this module provides](docs/apex-redirect-fargate.png)

## Usage

[See our examples directory](./examples/)

## Contributing

We welcome contributions.  To contribute please read our [CONTRIBUTING](CONTRIBUTING.md) document.  All contributions are subject to the license and in no way imply compensation for contributions.

### Terraform 0.12

Our code base now exists in Terraform 0.13 and we are halting new features in the Terraform 0.12 major version.  If you wish to make a PR or merge upstream changes back into 0.12, please submit a PR to the `terraform-0.12` branch.

## Code of Conduct

We strive for a welcoming and inclusive environment for all SBA projects.

Please follow this guidelines in all interactions:

* Be Respectful: use welcoming and inclusive language.
* Assume best intentions: seek to understand other's opinions.

## Security Policy

Please do not submit an issue on GitHub for a security vulnerability.
Instead, contact the development team through [HQVulnerabilityManagement](mailto:HQVulnerabilityManagement@sba.gov).
Be sure to include **all** pertinent information.

The agency reserves the right to change this policy at any time.
