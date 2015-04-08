use_inline_resources

action :create do
	username = new_resource.username
	password = new_resource.password
	groups = new_resource.groups
	mounts = new_resource.mounts

	hashed_password = hash_password(password)

	user "#{username}" do
		shell "/bin/false"
		gid "sftp"
		password hashed_password
		home "/home/#{username}"
	end

	directory "/home/#{username}" do
		owner "root"
		group "root"
		mode "0755"
	end

	group "sftp" do
		action :modify
		members "#{username}"
		append true
	end

	groups.each do |groupname|
		group groupname do
			action :modify
			members username
			append true
		end
	end

	mounts.each do |source, destination|
		if ::File.exists?("#{source}")
			directory "/home/#{username}/#{destination}" do
				owner "root"
				group "root"
				mode "0777"
				action :create
			end

			mount "/home/#{username}/#{destination}" do
				device "#{source}"
				action [:mount, :enable]
				options "rw,bind"
			end
		else
			abort("Folder #{source} does not exist - can not mount it to chrooted home of user #{userName}")
		end
	end

end


private

# TODO ruby way of doing this
def hash_password(pw)
	`echo '#{pw}' | makepasswd --clearfrom=- --crypt-md5 |awk '{ print $2 }'`.strip
end
