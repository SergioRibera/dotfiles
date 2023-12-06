from typing import Optional, List

import urllib, urllib.request, sys, os

url_config_json = "https://gist.githubusercontent.com/SergioRibera/c30e826d7ada4a8385ac9b04a732bbb5/raw/9f87a2199722424dcd219e20d7b70a786561e6a4/config.json"
url_packages_raw = "https://gist.githubusercontent.com/SergioRibera/c30e826d7ada4a8385ac9b04a732bbb5/raw/9f87a2199722424dcd219e20d7b70a786561e6a4/packages"

raw_packages: List[str] = urllib.request.urlopen(url_packages_raw).read().decode('utf-8').split('\n')
packages: List[str] = ["git", "base-devel"]
aur_packages: List[str] = []

urllib.request.urlretrieve(url_config_json, "config.json")
sys.argv.extend(['--config', './config.json'])

import archinstall
from archinstall import Installer, Path
from archinstall.lib.models import User
from archinstall import profile
from archinstall import SysInfo
from archinstall import mirrors
from archinstall import disk
from archinstall import menu
from archinstall import models
from archinstall import locale
from archinstall import info, debug

install_config = [
    "mkdir -p ~/Repos && mkdir -p ~/.config",
    "git clone --depth 1 https://github.com/SergioRibera/DotFiles ~/Repos/DotFiles",
    "git clone --depth 1 https://github.com/SergioRibera/NvimDotFiles ~/Repos/NvimDotFiles",
    "ln -s $HOME/Repos/NvimDotfiles $HOME/.config/nvim",
]

def ask_user_questions():
	global_menu = archinstall.GlobalMenu(data_store=archinstall.arguments)

	global_menu.enable('archinstall-language')
	global_menu.enable('mirror_config')
	global_menu.enable('locale_config')
	global_menu.enable('disk_config', mandatory=True)
	global_menu.enable('disk_encryption')
	global_menu.enable('bootloader')
	global_menu.enable('swap')
	global_menu.enable('hostname')
	global_menu.enable('!root-password', mandatory=True)
	global_menu.enable('!users', mandatory=True)
	global_menu.enable('profile_config')
	global_menu.enable('audio_config')
	global_menu.enable('kernels', mandatory=True)

	if archinstall.arguments.get('advanced', True):
		global_menu.enable('parallel downloads')

	global_menu.enable('network_config')
	global_menu.enable('timezone')
	global_menu.enable('ntp')
	# global_menu.enable('services')
	global_menu.enable('additional-repositories')
	global_menu.enable('__separator__')
	global_menu.enable('save_config')
	global_menu.enable('install')
	global_menu.enable('abort')

	global_menu.run()

def perform_installation(mountpoint: Path):
	"""
	Performs the installation steps on a block device.
	Only requirement is that the block devices are
	formatted and setup prior to entering this function.
	"""
	info('Starting installation')
	disk_config: disk.DiskLayoutConfiguration = archinstall.arguments['disk_config']

	# Retrieve list of additional repositories and set boolean values appropriately
	enable_testing = 'testing' in archinstall.arguments.get('additional-repositories', [])
	enable_multilib = 'multilib' in archinstall.arguments.get('additional-repositories', [])
	locale_config: locale.LocaleConfiguration = archinstall.arguments['locale_config']
	disk_encryption: disk.DiskEncryption = archinstall.arguments.get('disk_encryption', None)

	for package in raw_packages:
		try:
			if archinstall.SysCommand(f"pacman -Ss ^{package}\\$").exit_code == 0:
				packages.append(package)
			else:
				aur_packages.append(package)

		except archinstall.exceptions.SysCallError:
			aur_packages.append(package)

	with Installer(
		mountpoint,
		disk_config,
		disk_encryption=disk_encryption,
		kernels=archinstall.arguments.get('kernels', ['linux-lts'])
	) as installation:
		# Mount all the drives to the desired mountpoint
		if disk_config.config_type != disk.DiskLayoutType.Pre_mount:
			installation.mount_ordered_layout()

		installation.sanity_check()

		if disk_config.config_type != disk.DiskLayoutType.Pre_mount:
			if disk_encryption and disk_encryption.encryption_type != disk.EncryptionType.NoEncryption:
				installation.generate_key_files()

		# Set mirrors used by pacstrap (outside of installation)
		if mirror_config := archinstall.arguments.get('mirror_config', None):
			if mirror_config.mirror_regions:
				mirrors.use_mirrors(mirror_config.mirror_regions)
			if mirror_config.custom_mirrors:
				mirrors.add_custom_mirrors(mirror_config.custom_mirrors)

		installation.minimal_installation(
			testing=enable_testing,
			multilib=enable_multilib,
			hostname=archinstall.arguments.get('hostname', 'archlinux'),
			locale_config=locale_config
		)

		if mirror_config := archinstall.arguments.get('mirror_config', None):
			installation.set_mirrors(mirror_config)  # Set the mirrors in the installation medium

		if archinstall.arguments.get('swap'):
			installation.setup_swap('zram')

		if archinstall.arguments.get("bootloader") == models.Bootloader.Grub and SysInfo.has_uefi():
			installation.add_additional_packages("grub")

		installation.add_bootloader(archinstall.arguments["bootloader"])

		network_config = archinstall.arguments.get('network_config', None)

		if network_config:
			network_config.install_network_config(
				installation,
				archinstall.arguments.get('profile_config', None)
			)

		users: List[User] = archinstall.arguments.get('!users', None)
		installation.create_users(users)

		audio_config: Optional[models.AudioConfiguration] = archinstall.arguments.get('audio_config', None)
		if audio_config:
			audio_config.install_audio_config(installation)
		else:
			info("No audio server will be installed")

		installation.add_additional_packages(packages)

		if profile_config := archinstall.arguments.get('profile_config', None):
			profile.profile_handler.install_profile_config(installation, profile_config)

		if timezone := archinstall.arguments.get('timezone', None):
			installation.set_timezone(timezone)

		if archinstall.arguments.get('ntp', False):
			installation.activate_time_synchronization()

		if archinstall.accessibility_tools_in_use():
			installation.enable_espeakup()

		if (root_pw := archinstall.arguments.get('!root-password', None)) and len(root_pw):
			installation.user_set_pw('root', root_pw)

		installation.genfstab()

		mount_location = installation.target

		with open(f'{mount_location}/etc/sudoers.d/auruser', 'w') as fh:
			fh.write(f"auruser ALL=(ALL:ALL) NOPASSWD: ALL\n")
		installation.user_create("auruser")

		installation.arch_chroot("git clone https://aur.archlinux.org/paru-bin.git /tmp/paru && cd /tmp/paru && makepkg -si --clean --force --cleanbuild --noconfirm --needed", run_as="auruser")
		installation.arch_chroot(f"paru --skipreview --cleanafter --noconfirm -Sy {' '.join(aur_packages)}", run_as="auruser")
		installation.arch_chroot("/usr/bin/killall -u auruser")
		installation.arch_chroot("/usr/bin/userdel auruser")

		if archinstall.arguments.get('services', None):
			installation.enable_service(archinstall.arguments.get('services', []))

        # Download configs
		archinstall.run_custom_user_commands(install_config, installation)

        # Link Configs
		directory = os.fsencode(f"{mount_location}/home/{users[0].username}/Repos/DotFiles/configs")
		for cfg in os.listdir(directory):
			filename = os.fsdecode(cfg)
			installation.arch_chroot(f"ln -s $HOME/Repos/DotFiles/configs/{filename} $HOME/.config/{filename}")

		installation.arch_chroot(f"ln -s $HOME/Repos/DotFiles/scripts $HOME/.config/scripts")
		installation.arch_chroot(f"ln -s $HOME/Repos/NvimDotfiles $HOME/.config/nvim")

		info("For post-installation tips, see https://wiki.archlinux.org/index.php/Installation_guide#Post-installation")

		if not archinstall.arguments.get('silent'):
			prompt = 'Would you like to chroot into the newly created installation and perform post-installation configuration?'
			choice = menu.Menu(prompt, menu.Menu.yes_no(), default_option=menu.Menu.yes()).run()
			if choice.value == menu.Menu.yes():
				try:
					installation.drop_to_shell()
				except Exception:
					pass

	debug(f"Disk states after installing: {disk.disk_layouts()}")

ask_user_questions()

fs_handler = disk.FilesystemHandler(
	archinstall.arguments['disk_config'],
	archinstall.arguments.get('disk_encryption', None)
)

fs_handler.perform_filesystem_operations()

perform_installation(archinstall.storage.get('MOUNT_POINT', Path('/mnt')))
