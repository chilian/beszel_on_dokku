# Security Policy

## Supported Versions

This project tracks the latest version of [Beszel](https://github.com/henrygd/beszel). Security updates are applied by updating to the newest Beszel release.

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| < Latest| :x:                |

## Reporting a Vulnerability

### For Beszel Core Issues

If you discover a security vulnerability in Beszel itself, please report it directly to the upstream project:
- **Repository**: [henrygd/beszel](https://github.com/henrygd/beszel)
- **Security Policy**: See [Beszel's Security Policy](https://github.com/henrygd/beszel/security/policy)

### For This Deployment Configuration

If you find a security issue specific to this Dokku deployment configuration (Dockerfile, scripts, or deployment process), please report it by:

1. **DO NOT** open a public issue
2. Contact me privately via:
   - [GitHub Security Advisories](https://github.com/chilian/beszel_on_dokku/security/advisories/new) (preferred)
   - Or open a private issue if available

### What to Include

- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact
- Suggested fix (if any)

## Security Best Practices

When using this deployment:

1. **Keep Updated**: Run `./update.sh` regularly to stay current with Beszel releases
2. **Review Changes**: Check the [Beszel release notes](https://github.com/henrygd/beszel/releases) before updating
3. **Secure Your Dokku Instance**: 
   - Use HTTPS/TLS certificates
   - Keep Dokku and host system updated
   - Follow Dokku security best practices
4. **Limit Access**: Restrict SSH and administrative access to your Dokku server
5. **Monitor Logs**: Regularly review application and system logs

## Security Updates

Security updates are delivered through:
- Upstream Beszel releases
- Updates to this repository's Dockerfile or deployment scripts

The `update.sh` script automates the process of pulling and deploying the latest Beszel version.

## Acknowledgments

Security vulnerabilities in Beszel core should be credited to the upstream maintainers.