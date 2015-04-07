actions [:create]
default_action :create

attribute :username, :kind_of => String, :name_attribute => true
attribute :password, :kind_of => String
attribute :groups, :kind_of => Array
attribute :directories, :kind_of => Hash
