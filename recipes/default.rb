# echo "mypassword" | makepasswd --clearfrom=- --crypt-md5 |awk '{ print $2 }'

node.override['build-essential'][:compile_time] = true
include_recipe "build-essential"

chef_gem "ruby-shadow"

group "sftp"

ssh_config "Subsystem sftp" do
	string "Subsystem sftp internal-sftp"
end

ssh_config "Match group sftp" do
	string "Match group sftp\\n X11Forwarding no\\n ChrootDirectory %h\\n AllowTcpForwarding no\\n ForceCommand internal-sftp\\n"
	action :add_multiline
end

ssh_config "enable PasswordAuthentication" do
	string "PasswordAuthentication yes"
	action :add
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
