# echo "mypassword" | makepasswd --clearfrom=- --crypt-md5 |awk '{ print $2 }'

node.override['build-essential'][:compile_time] = true
include_recipe "build-essential"

chef_gem "ruby-shadow"

group "sftp"

ssh_config nil do
	options ({
		:Subsystem => "sftp internal-sftp",
		:Match => "group sftp",
		:X11Forwarding => "no",	
		:ChrootDirectory => "no",	
		:AllowTcpForwarding => "no",	
		:ForceCommand => "internal-sftp",	
		:PasswordAuthentication => "yes"
		})
end

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
