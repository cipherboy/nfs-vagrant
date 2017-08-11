# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # If you'd prefer to pull your boxes from Hashicorp's repository, you can
    # replace the config.vm.box and config.vm.box_url declarations with the line below.
    #
    # config.vm.box = "fedora/25-cloud-base"
    config.vm.box = "f26-cloud-libvirt"
    config.vm.box_url = "https://download.fedoraproject.org/pub/fedora/linux/releases"\
                        "/26/CloudImages/x86_64/images/Fedora-Cloud-Base-Vagrant-26-1"\
                        ".5.x86_64.vagrant-libvirt.box"

    # Optionally update the host's /etc/hosts file with the hostname of the
    # guest VM.
    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
    end

    #Dir.mkdir('.dnf-cache') unless File.exists?('.dnf-cache')
    #config.vm.synced_folder ".dnf-cache", "/var/cache/dnf", type: "sshfs", sshfs_opts_append: "-o nonempty"
    # To cache update packages (which is helpful if frequently doing `vagrant
    # destroy && vagrant up`) create a local directory and share it to the
    # guest's DNF cache.

    # Comment this line if you would like to disable the automatic update during provisioning
    config.vm.provision "shell", inline: "sudo dnf upgrade -y"

    # Disable SELinux
    config.vm.provision "shell", inline: "setenforce 0"
    config.vm.provision "shell", inline: "sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config"

    # Bootstrap and run with ansible
    config.vm.provision "shell", inline: "sudo dnf -y install python2-dnf libselinux-python psmisc"

    # Install development tools
    config.vm.provision "shell", inline: "sudo dnf -y install gdb valgrind git vim emacs-nox rxvt-unicode-256color strace nmap ltrace lsof systemtap"

    # Install debug symbols
    config.vm.provision "shell", inline: "sudo dnf -y debuginfo-install gdb valgrind glibc krb5-workstation krb5-server gssproxy"

    config.vm.define "vkdc" do |vkdc|
        vkdc.vm.host_name = "vkdc.mivehind.net"
        vkdc.vm.network :private_network, ip: "192.168.56.5"

        vkdc.vm.provider :libvirt do |domain|
            domain.cpus = 4
            domain.graphics_type = "spice"
            domain.memory = 2048
            domain.video_type = "qxl"
            domain.random :model => "random"

            vkdc.vm.provision "ansible" do |ansible|
                ansible.playbook = "vkdc-playbook.yml"
            end
        end
    end

    config.vm.define "nfs-server" do |server|
        server.vm.host_name = "nfs-server.mivehind.net"
        server.vm.network :private_network, ip: "192.168.56.10"

        server.vm.provider :libvirt do |domain|
            domain.cpus = 4
            domain.graphics_type = "spice"
            domain.memory = 2048
            domain.video_type = "qxl"
            domain.random :model => "random"

            server.vm.provision "ansible" do |ansible|
                ansible.playbook = "server-playbook.yml"
            end
        end
    end

    config.vm.define "nfs-client" do |client|
        client.vm.host_name = "nfs-client.mivehind.net"
        client.vm.network :private_network, ip: "192.168.56.15"

        client.vm.provider :libvirt do |domain|
            domain.cpus = 4
            domain.graphics_type = "spice"
            domain.memory = 2048
            domain.video_type = "qxl"
            domain.random :model => "random"

            client.vm.provision "ansible" do |ansible|
                ansible.playbook = "client-playbook.yml"
            end
        end
    end
end
