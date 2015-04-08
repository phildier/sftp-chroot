# echo "mypassword" | makepasswd --clearfrom=- --crypt-md5 |awk '{ print $2 }'

package "makepasswd"

node.override['build-essential'][:compile_time] = true
include_recipe "build-essential"
chef_gem "ruby-shadow"

group "sftp"

node.override[:openssh] = {
	:server => {
		"Subsystem" => "sftp internal-sftp",
		"match" => {
			"group sftp" => {
				:X11Forwarding => "no",	
				:ChrootDirectory => "no",	
				:AllowTcpForwarding => "no",	
				:ForceCommand => "internal-sftp",	
				:PasswordAuthentication => "yes"
			}
		}
	}
}
include_recipe "openssh"


case node['platform']
when "redhat","centos","scientific","fedora","suse","amazon"
	service "sshd" do
		action :restart
	end
when "debian","ubuntu"
	service "ssh" do
		action :restart
	end
end
