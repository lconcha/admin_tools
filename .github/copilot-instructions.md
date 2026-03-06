# AI Agent Guidelines for fMRI Lab Admin Tools

## Project Overview
This repository manages infrastructure for an fMRI research cluster at INB (Instituto de Neurobiología), UNAM. It contains shell scripts for system administration, backup automation, user management, and environment module configuration for neuroimaging software.

**Key Infrastructure Components:**
- **Hosts**: lauterbur, mansfield, sesamo (NFS servers), garza, kanbalam
- **Job Scheduler**: Sun Grid Engine (SGE) at `/opt/sge`
- **Module System**: Environment Modules (Tcl) at `/home/inb/soporte/admin_tools/modulesfiles`
- **Backup**: Borg backup to sesamo NFS, excluding patterns in `fmrilab_borg_exclude.txt`
- **Configuration**: Sourced via `fmrilab_configfile` loaded in system-wide `/etc/profile`

## Critical Workflows

### Configuration & Environment
- **System profile**: User shells source `/home/inb/soporte/admin_tools/fmrilab_configfile` (prevents double-sourcing via `FMRILAB_CONFIGFILE_RAN` flag)
- **Module loading**: Uses `/etc/profile.d/modules.sh`, then sets `MODULEPATH` to custom `modulesfiles/` directory
- **Default module**: `inb_tools` is auto-loaded for all cluster users

### Backup System (Borg-based)
Scripts like `fmrilab_borg_backup_sesamo5.sh` follow this pattern:
1. Root-only execution check
2. SSH key setup for remote backup (admin@sesamo)
3. Passphrase from `private/` directory (git-ignored)
4. AutoFS keepalive loop (touch dirs every 30s) to prevent unmount during long backups
5. Exclude patterns from `fmrilab_borg_exclude.txt`
6. Error notification via email

**Key exports**: `BORG_REPO`, `BORG_PASSPHRASE`, `BORG_EXCLUDEFILE`

### Status Checking
Scripts like `fmrilab_check_status.sh` verify:
- Host availability via ping (hosts from `/etc/hosts` with `inb.unam.mx` suffix)
- NFS mounts (grep `/etc/fstab` for `nfs`, check with `stat -f -L`)
- SGE configuration integrity

### User Management
- `fmrilab_disable_inactive_users.sh`: Reads user list, prompts for confirmation, uses `chage -E0`
- `fmrilab_add_nis_user.sh`: Integrates NIS user management
- Uses `echolor` function for colored terminal output

## Code Patterns & Conventions

### Utility Functions
- **`echolor_function`**: Print colored text (red, green, yellow, blue, magenta, cyan, orange, bold, reverse)
  - Usage: `echolor green "Message here"`
- **SGE Setup**: Source `${SGE_ROOT}/fmrilab/common/settings.sh` after verifying `/opt/sge` exists

### Error Handling
- Explicit root permission checks before dangerous operations
- Use `trap` for cleanup (see backup scripts: `trap 'kill $KEEP_ALIVE_PID' INT TERM EXIT`)
- Double-check critical state before proceeding (e.g., autofs wakeup test in backups)

### Environment Variables
Common patterns across scripts:
```bash
export BORG_REPO=admin@sesamo:/volume1/fmrilab/backup/borg_repo
export BORG_PASSPHRASE=$(cat `dirname $0`/private/borg_passphrase_sesamo5)
export MODULEPATH=/home/inb/soporte/admin_tools/modulesfiles
export SGE_ROOT=/opt/sge
```

## File Organization

### Root Level Scripts
- `fmrilab_*.sh`: Core administration scripts (backups, monitoring, user management)
- `setup_*.sh`: Software setup (FreeSurfer, FSL, MRtrix3)
- Utility scripts: `echolor_function`, `merge_rocket_user_lists.sh`, `x2go_*.sh`

### Module Files (`modulesfiles/`)
Each neuroimaging tool has versioned module files (Tcl format):
- **Location**: `modulesfiles/{TOOL}/{VERSION}`
- **Pattern**: Define `PATH`, `LD_LIBRARY_PATH`, tool-specific env vars
- Example (`modulesfiles/fsl/6.0.7.1`):
  ```tcl
  set root /home/inb/soporte/lanirem_software/fsl_6.0.7.1
  prepend-path PATH $root/share/fsl/bin
  setenv FSLOUTPUTTYPE NIFTI_GZ
  ```

### Configuration Files
- `fmrilab_configfile*`: Main environment config (sourced by `/etc/profile`)
- `fmrilab_fsl_sub.yml`: FSL submission template
- `fmrilab_borg_exclude.txt`: Borg backup exclusion patterns
- `fmrilab_backup_exclude.txt`: rsync backup exclusions

### Archive & Motd
- `archive/`: Legacy scripts and configs (do not modify; reference only)
- `motd/`: Message-of-the-day files (motd_data_in_home.txt, etc.)
- `private/`: Git-ignored credentials (passphrases, ssh keys, credentials)

## Integration Points

### Cross-Script Communication
- **Job Scheduling**: Backup scripts may interact with SGE via `qconf -sel` (list exec hosts)
- **NFS Mounts**: Multiple scripts depend on `/etc/fstab` configuration
- **Email Notifications**: Some scripts call notification scripts; must have mail configured

### External Dependencies
- **Borg**: Remote backup tool with `--remote-path=/usr/local/bin/borg`
- **SSH Keys**: Root must have passwordless SSH to backup servers
- **AutoFS**: Used for lazy-mounting large datasets; requires keepalive during long operations

## When Modifying Scripts

1. **Test on non-production**: Scripts affect system services, backups, user accounts
2. **Root operations**: Always verify running context; document permission requirements
3. **Paths**: Use absolute paths; reference `/home/inb/soporte/admin_tools/` consistently
4. **Error messages**: Use `echolor red` for errors, include machine hostname in logs
5. **Credentials**: Never commit to `private/` unless specifically git-ignored; regenerate in safe environment
6. **Backward compatibility**: Many scripts may be called via cron; avoid breaking existing invocations

## Key Files to Reference
- [fmrilab_configfile](fmrilab_configfile) – System environment setup
- [echolor_function](echolor_function) – Logging/output utilities
- [fmrilab_borg_backup_sesamo5.sh](fmrilab_borg_backup_sesamo5.sh) – Backup pattern example
- [fmrilab_check_status.sh](fmrilab_check_status.sh) – Health check pattern
- [modulesfiles/fsl/6.0.7.1](modulesfiles/fsl/6.0.7.1) – Module file template
