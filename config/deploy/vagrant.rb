set :stage, :vagrant

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
#role :app, %w{deploy@example.com}
#role :web, %w{deploy@example.com}
#role :db,  %w{deploy@example.com}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server "core@localhost:2222", roles: %w[web app db], primary: true

require 'ostruct'
 
class VagrantSSHConfig < OpenStruct
  def initialize
    super parse_options(`vagrant ssh-config`)
  end
 
  private
 
  def parse_options(option_string)
    option_string.split("\n").inject({ }) do |options, key_value_string|
      (key, value) = key_value_string.split
      options.merge(key => value)
    end
  end
end

ssh_config = VagrantSSHConfig.new

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
set :ssh_options, {
  keys: ssh_config.IdentityFile,
#  forward_agent: true,
#  auth_methods: %w(password)
}
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

set :rsync_stage, '.'
#Rake::Task["rsync:stage"].clear
set :rsync_options, ["-av", "-e\"vagrant ssh --\""]
set :rsync_cache, nil

# Override rsync task
#Rake::Task["rsync"].clear
#desc "Stage and rsync to the server"
#task :rsync => %w[rsync:stage] do
#  roles(:all).each do |role|
#    user = role.user + "@" if !role.user.nil?
#
#    rsync = %w[rsync]
#    rsync.concat fetch(:rsync_options)
#    rsync << fetch(:rsync_stage) + "/"
#    rsync << ":#{release_path}"
#
#    Kernel.system *rsync.join(" ")
#  end
#end

# fetch(:default_env).merge!(rails_env: :vagrant)
