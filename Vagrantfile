# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "fedora/27-cloud-base"

    # Optionally update the host's /etc/hosts file with the hostname of the
    # guest VM.
    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
    end

    # Cache update packages (helpful if frequently doing `vagrant destroy &&
    # vagrant up`) by creating a local directory and sharing it to the guest's
    # DNF cache.
    Dir.mkdir('.dnf-cache') unless File.exists?('.dnf-cache')
    config.vm.synced_folder ".dnf-cache", "/var/cache/dnf", type: "sshfs",
                            sshfs_opts_append: "-o nonempty"

    # # Avoid mirror inconsistency.
    # config.vm.provision "shell",
    #                     inline: "sudo sed -i -e 's/metalink/\#metalink/g' "\
    #                             "-e 's/\#baseurl/baseurl/g' "\
    #                             "-e 's/download.fedoraproject.org\\/pub/mirrors.mit.edu/g' "\
    #                             "/etc/yum.repos.d/*.repo"

    # Cope with cache and mirror failures by doing this in two parts.
    config.vm.provision "shell", inline: "sudo dnf upgrade -y --downloadonly"
    config.vm.provision "shell", inline: "sudo dnf -C upgrade -y || true"

    # Disable SELinux
    config.vm.provision "shell", inline: "setenforce 0"
    config.vm.provision "shell", inline: "sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config"

    # Bootstrap and run with ansible
    config.vm.provision "shell", inline: "sudo dnf -y install python2-dnf libselinux-python psmisc"

    # Install development tools
    config.vm.provision "shell", inline: "sudo dnf -y install gdb valgrind git vim emacs-nox rxvt-unicode-256color strace nmap ltrace lsof systemtap"

    # Install debug symbols
    config.vm.provision "shell", inline: "sudo dnf -y debuginfo-install gdb valgrind glibc krb5-workstation krb5-server krb5-libs gssproxy nfs-utils"

    config.vm.define "vkdc" do |vkdc|
        vkdc.vm.host_name = "vkdc.nfs.test"
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
        server.vm.host_name = "nfs-server.nfs.test"
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
        client.vm.host_name = "nfs-client.nfs.test"
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
